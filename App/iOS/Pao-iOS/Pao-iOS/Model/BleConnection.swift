//
//  BleConnection.swift
//  Pao-iOS
//
//  Created by Sergio on 10/3/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import Foundation
import BlueCapKit
import CoreBluetooth

class BleConnection {
    
    private var dataCharacteristicTx : Characteristic?
    private var dataCharacteristicRx : Characteristic?
    
    // Responder to interface with ViewController
    weak var _responder: bleConnectionResponder?
    
    public enum AppError : Error {
        case dataCharactertisticNotFound
        case enabledCharactertisticNotFound
        case updateCharactertisticNotFound
        case serviceNotFound
        case invalidState
        case resetting
        case poweredOff
        case unknown
    }
    
    init(responder: bleConnectionResponder) {
        // Set a responder
        self._responder = responder
    }
    
    func connectBlePao() {
        
        let serviceUUID = CBUUID(string:"6e400001-b5a3-f393-e0a9-e50e24dcca9e")
        var peripheral: Peripheral?
        let dateCharacteristicTxUUID = CBUUID(string:"6e400002-b5a3-f393-e0a9-e50e24dcca9e")
        let dateCharacteristicRxUUID = CBUUID(string:"6e400003-b5a3-f393-e0a9-e50e24dcca9e")
        //initialize a central manager with a restore key. The restore key allows to resuse the same central manager in future calls
        let manager = CentralManager(options: [CBCentralManagerOptionRestoreIdentifierKey : "CentralMangerKey" as NSString])
        
        //A future stram that notifies us when the state of the central manager changes
        let stateChangeFuture = manager.whenStateChanges()
        
        //handle state changes and return a scan future if the bluetooth is powered on.
        let scanFuture = stateChangeFuture.flatMap { state -> FutureStream<Peripheral> in
            switch state {
            case .poweredOn:
                DispatchQueue.main.async {
                    //self.connectionStatusLabel.text = "Looking for a pao..."
                    print("Looking for a pao...")
                }
                //scan for peripherlas that advertise the ec00 service
                return manager.startScanning(forServiceUUIDs: [serviceUUID])
            case .poweredOff:
                throw AppError.poweredOff
            case .unauthorized, .unsupported:
                throw AppError.invalidState
            case .resetting:
                throw AppError.resetting
            case .unknown:
                //generally this state is ignored
                throw AppError.unknown
            }
        }
        
        scanFuture.onFailure { error in
            guard let appError = error as? AppError else {
                return
            }
            switch appError {
            case .invalidState:
                break
            case .resetting:
                manager.reset()
            case .poweredOff:
                break
            case .unknown:
                break
            default:
                break;
            }
        }
        
        //We will connect to the first scanned peripheral
        let connectionFuture = scanFuture.flatMap { p -> FutureStream<Void> in
            //stop the scan as soon as we find the first peripheral
            manager.stopScanning()
            peripheral = p
            guard let peripheral = peripheral else {
                throw AppError.unknown
            }
            DispatchQueue.main.async {
                //self.connectionStatusLabel.text = "Found a Pao! [\(peripheral.identifier.uuidString)]. Trying to connect"
                print("Found a Pao! [\(peripheral.identifier.uuidString)]. Trying to connect")
            }
            //connect to the peripheral in order to trigger the connected mode
            return peripheral.connect(connectionTimeout: 10, capacity: 5)
        }
        
        //we will next discover the "ec00" service in order be able to access its characteristics
        let discoveryFuture = connectionFuture.flatMap { _ -> Future<Void> in
            guard let peripheral = peripheral else {
                throw AppError.unknown
            }
            return peripheral.discoverServices([serviceUUID])
            }.flatMap { _ -> Future<Void> in
                guard let discoveredPeripheral = peripheral else {
                    throw AppError.unknown
                }
                guard let service = discoveredPeripheral.services(withUUID:serviceUUID)?.first else {
                    throw AppError.serviceNotFound
                }
                peripheral = discoveredPeripheral
                DispatchQueue.main.async {
                    //self.connectionStatusLabel.text = "Discovered service \(service.uuid.uuidString). Trying to discover characteristics"
                    print("Discovered service \(service.uuid.uuidString). Trying to discover characteristics")
                }
                //we have discovered the service, the next step is to discover the "ec0e" characteristic
                return service.discoverCharacteristics([dateCharacteristicTxUUID, dateCharacteristicRxUUID])
        }
        
        /**
         1- checks if the characteristic is correctly discovered
         2- Register for notifications using the dataFuture variable
         */
        let dataFuture = discoveryFuture.flatMap { _ -> Future<Void> in
            guard let discoveredPeripheral = peripheral else {
                throw AppError.unknown
            }
            guard let dataCharactTx = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID:dateCharacteristicTxUUID)?.first else {
                throw AppError.dataCharactertisticNotFound
            }
            guard let dataCharactRx = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID:dateCharacteristicRxUUID)?.first else {
                throw AppError.dataCharactertisticNotFound
            }
            self.dataCharacteristicTx = dataCharactTx
            self.dataCharacteristicRx = dataCharactRx
            DispatchQueue.main.async {
                //self.connectionStatusLabel.text = "Discovered characteristic \(dataCharactTx.uuid.uuidString). COOL :)"
                print("Discovered characteristic \(dataCharactTx.uuid.uuidString). COOL :)")
                print("Discovered characteristic \(dataCharactRx.uuid.uuidString). COOL :)")
            }
            // Inform responder that pao was found
            self._responder?.onPaoFound()
//            DispatchQueue.main.async {
//                self.loadingView.isHidden = true
//                self.characteristicView.isHidden = false
//            }
            //read the data from the characteristic
            //self.read()
            //Ask the characteristic to start notifying for value change
            return dataCharactRx.startNotifying()
            
            }.flatMap { _ -> FutureStream<Data?> in
                guard let discoveredPeripheral = peripheral else {
                    throw AppError.unknown
                }
                guard let characteristic = discoveredPeripheral.services(withUUID:serviceUUID)?.first?.characteristics(withUUID:dateCharacteristicRxUUID)?.first else {
                    throw AppError.dataCharactertisticNotFound
                }
                //regeister to recieve a notifcation when the value of the characteristic changes and return a future that handles these notifications
                return characteristic.receiveNotificationUpdates(capacity: 10)
        }
        
        //The onSuccess method is called every time the characteristic value changes
        dataFuture.onSuccess { data in
            let s = String(data:data!, encoding: .utf8 )
            DispatchQueue.main.async {
                print("notified value is \(String(describing: s!)) ")
            }
        }
        
        //handle any failure in the previous chain
        dataFuture.onFailure { error in
            switch error {
            case PeripheralError.disconnected:
                peripheral?.reconnect()
            case AppError.serviceNotFound:
                break
            case AppError.dataCharactertisticNotFound:
                break
            default:
                break
            }
        }
    }
    
    
    func write(){
        //self.valueToWriteTextField.resignFirstResponder()
        //guard let text = self.valueToWriteTextField.text else{
        //    return;
        //}
        //write a value to the characteristic
        let text = "1"
        let writeFuture = self.dataCharacteristicTx?.write(data:text.data(using: .ascii)!)
        writeFuture?.onSuccess(completion: { (_) in
            print("write succes")
        })
        writeFuture?.onFailure(completion: { (e) in
            print("write failed")
        })
    }
}

// A protocol for the ViewController to adhere in order to edit instances in the view
protocol bleConnectionResponder: class {
    
    func onPaoFound()
}
