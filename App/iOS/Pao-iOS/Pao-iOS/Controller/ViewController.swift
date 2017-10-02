//
//  ViewController.swift
//  SimpleBleCentral
//
//  Created by yassine benabbas on 22/01/2017.
//  Copyright © 2017 yassine benabbas. All rights reserved.
//

import UIKit
import BlueCapKit
import CoreBluetooth

class ViewController: UIViewController, UITextViewDelegate {
    
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
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var characteristicView: UIView!
    @IBOutlet weak var connectionStatusLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueToWriteTextField: UITextField!
    @IBOutlet weak var notifiedValueLabel: UILabel!
    
    // IB outlet to Pao Finding View
    @IBOutlet weak var paoFindingViewIB: PaoFindingView!
    // Timer we'll use to refresh the Pao Finding animation
    fileprivate var clockTimer : Timer!
    
    var dataCharacteristicTx : Characteristic?
    var dataCharacteristicRx : Characteristic?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Setup the Pao Finding animation timer
        clockTimer = Timer.scheduledTimer( timeInterval: 0.03, target: self, selector: #selector(ViewController.advancePaoFindingAnimation), userInfo: nil, repeats: true)
        
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
                    self.connectionStatusLabel.text = "Looking for a pao..."
                    print(self.connectionStatusLabel.text!)
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
                self.connectionStatusLabel.text = "Found a Pao! [\(peripheral.identifier.uuidString)]. Trying to connect"
                print(self.connectionStatusLabel.text!)
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
                    self.connectionStatusLabel.text = "Discovered service \(service.uuid.uuidString). Trying to discover characteristics"
                    print(self.connectionStatusLabel.text!)
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
                self.connectionStatusLabel.text = "Discovered characteristic \(dataCharactTx.uuid.uuidString). COOL :)"
                print(self.connectionStatusLabel.text!)
                print("Discovered characteristic \(dataCharactRx.uuid.uuidString). COOL :)")
            }
            //when we successfully discover the characteristic, we can show the characteritic view
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.characteristicView.isHidden = false
            }
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
                self.notifiedValueLabel.text = "notified value is \(String(describing: s!))"
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        clockTimer.invalidate()
        clockTimer = nil
    }
    
    @IBAction func onWriteTapped(_ sender: Any) {
        self.write()
    }
    
    @IBAction func onRefreshTap(_ sender: Any) {
        self.read()
    }
    
    func read(){
        print("I should be reading")
        //read a value from the characteristic
        let readFuture = self.dataCharacteristicRx?.read(timeout: 5)
        readFuture?.onSuccess { (_) in
            //the value is in the dataValue property
            let s = String(data:(self.dataCharacteristicRx?.dataValue)!, encoding: .utf8)
            DispatchQueue.main.async {
                self.valueLabel.text = "Read value is \(String(describing: s))"
                print(self.valueLabel.text!)
            }
        }
        readFuture?.onFailure { (_) in
            self.valueLabel.text = "read error"
        }
    }
    
    func write(){
        self.valueToWriteTextField.resignFirstResponder()
        guard let text = self.valueToWriteTextField.text else{
            return;
        }
        //write a value to the characteristic
        let writeFuture = self.dataCharacteristicTx?.write(data:text.data(using: .ascii)!)
        writeFuture?.onSuccess(completion: { (_) in
            print("write succes")
        })
        writeFuture?.onFailure(completion: { (e) in
            print("write failed")
        })
    }
    
    // Advance the finding pao animation
    @objc func advancePaoFindingAnimation() {
        // No need to call setNeedsDisplay() since we do that in the setter for animationProgress
        paoFindingViewIB.animationProgress += 0.015
    }
    
}

