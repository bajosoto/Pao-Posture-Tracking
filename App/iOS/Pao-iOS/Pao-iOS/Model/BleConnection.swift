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
    
    var bleRxBuff: [UInt8] = [UInt8](repeating: 0, count: 30)
    
    var consoleMessages: NSMutableAttributedString = NSMutableAttributedString()
    
    // Responder to interface with ViewController
    weak var _responder: bleConnectionResponder!
    var responder: bleConnectionResponder {
        get {
            return _responder
        }
        set (newResponder) {
            _responder = newResponder
        }
    }
    
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
    
    init(newResponder: bleConnectionResponder) {
        // Set a responder
        self._responder = newResponder
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
                    self.logMsg(message: "Looking for pao...")
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
                self.logMsg(message: "pao found! [\(peripheral.identifier.uuidString)]. Trying to connect...")
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
                    self.logMsg(message: "Discovered service \(service.uuid.uuidString). Trying to discover characteristics")
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
                self.logMsg(message: "Discovered characteristic \(dataCharactTx.uuid.uuidString).")
                self.logMsg(message: "Discovered characteristic \(dataCharactRx.uuid.uuidString).")
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
                if s != nil {
                    //self.logMsg(message: "Data (as string) received:")// \(String(describing: s!)) ")
                    print("Data (as string) received: \(String(describing: s!)) ")
                }
                if let safeData = data {
                    self.receive(rawData: safeData)
                }
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
    
    func logMsg(message: String) {
        let paoBarBlue = UIColor(red: 0.024, green: 0.671, blue: 0.925, alpha: 1.000)
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        let newLine = "[\(dateString)]:\(message)\n"
        
        let mutableString = NSMutableAttributedString(string: newLine, attributes: [NSAttributedStringKey.font:UIFont(name: "Avenir", size: 10.0)!])
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: paoBarBlue, range: NSRange(location:0,length:10))
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.white, range: NSRange(location:11,length:message.characters.count))
        // set label Attribute
        consoleMessages.append(mutableString)
        //labName.attributedText = myMutableString
        
        self._responder?.redrawConsole()
    }
    
    
    
    
    //func receive(dataAsString: String!) {
    func receive(rawData: Data) {
        // Do some processing here
        bleRxBuff = rawData.withUnsafeBytes {
            Array(UnsafeBufferPointer<UInt8>(start: $0, count: (rawData.count)/MemoryLayout<UInt8>.size))
        }
        print(bleRxBuff)
        
        //self._responder?.onMsgReceived(message: dataAsString)
    }
    
    
    func write(msg: String){

        var reversedMsg = String();
        
        if(msg.characters.count > 0 && msg.characters.count % 2 == 0) {
            
            self.logMsg(message: "Writing message: \(msg)")
        
            // Data reversal
            let iter = msg.characters.count/2 - 1
            for i in 0...iter {
                let range = msg.index(msg.startIndex, offsetBy: 2 * (iter - i))...msg.index(msg.startIndex, offsetBy: (2 * (iter - i) + 1))
                let substring = msg[range]
                reversedMsg.append(String(substring))
            }
            print("Reversed message: \(reversedMsg)")
        
            let parsedData = Scanner(string: reversedMsg)
            var value: UInt64 = 0
            if parsedData.scanHexInt64(&value) {
                // let writeFuture = self.dataCharacteristicTx?.write(data: Data(bytes: &value, count: sizeof(UInt64)))
                // let writeFuture = self.dataCharacteristicTx?.write(data:text.data(using: .ascii)!)
                let myData = Data(bytes: &value, count: MemoryLayout<UInt64>.size)
                let writeFuture = self.dataCharacteristicTx?.write(data: myData)
                writeFuture?.onSuccess(completion: { (_) in
                    print("write succes")
                })
                writeFuture?.onFailure(completion: { (e) in
                    print("write failed")
                })
            }
        } else {
            self.logMsg(message: "Invalid message length")
        }
    }
}

//extension String {
//
////    subscript (i: Int) -> Character {
////        return self[index(startIndex, offsetBy: i)]
////    }
//
//    subscript (i: Int) -> String {
//        return String(self[i] as Character)
//    }
//
//    subscript (r: Range<Int>) -> String {
//        let start = index(startIndex, offsetBy: r.lowerBound)
//        let end = index(startIndex, offsetBy: r.upperBound)
//        return String(self[Range(start ..< end)])
//    }
//
//    var asciiArray: [UInt32] {
//        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
//    }
//}


// A protocol for the ViewController to adhere in order to edit instances in the view
protocol bleConnectionResponder: class {
    
    func onPaoFound()
    func onMsgReceived(message: String!)
    func redrawConsole()
}
