//
//  DebugVC.swift
//  Pao-iOS
//
//  Created by Sergio on 10/6/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import UIKit

class DebugVC: UIViewController, UITextFieldDelegate, bleConnectionResponder {

    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var msgHexValueTxtFld: UITextField!
    @IBOutlet weak var btnPing: AssetBtnPing!
    @IBOutlet weak var btnSend: AssetBtnSend!
    @IBOutlet weak var btnBack: AssetBtnBackView!
    @IBOutlet weak var btnExport: AssetBtnExport!
    
    var _bleConn: BleConnection!
    // Reference to the previous responder (e.g. parent VC)
    var _prevResponder: bleConnectionResponder!
    var bleConn: BleConnection {
        get {
            return _bleConn
        }
        set (newConn) {
            _bleConn = newConn
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set this VC as the current responder
        if let bleConnResp = self as bleConnectionResponder? {
            // Store previous responder
            _prevResponder = bleConn.responder
            // Set new responder
            bleConn.responder = bleConnResp
        }
        
        // Set self as delegate for the text field
        self.msgHexValueTxtFld.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        consoleTextView.attributedText = bleConn.consoleMessages;
    }
    
    // Hide keyboard when pressing outside the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide keyboard and send message when pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        msgHexValueTxtFld.resignFirstResponder()
        if let message = msgHexValueTxtFld.text as String! {
            bleConn.write(msg: message)
            bleConn.logMsg(message: "Sent Message: \(message)")
        }
        return (true)
    }
    
    /* Back Button*/
    @IBAction func onBtnBackPressed(_ sender: Any) {
        btnBack.isPressed = true
    }
    @IBAction func onBtnBackRelease(_ sender: Any) {
        btnBack.isPressed = false
        dismiss(animated: true, completion: {
            // Revert responder to previous
            self.bleConn.responder = self._prevResponder
        })
    }
    @IBAction func onBtnBackDrag(_ sender: Any) {
        btnBack.isPressed = false
    }
    
    /* Export Button */
    @IBAction func onBtnExportPressed(_ sender: Any) {
        btnExport.isPressed = true
    }
    @IBAction func onBtnExportRelease(_ sender: Any) {
        btnExport.isPressed = false
        bleConn.logMsg(message: "Log file stored")
        let activity: UIActivityViewController = UIActivityViewController(activityItems: [consoleTextView.text], applicationActivities: nil)
        self.present(activity, animated: true, completion: nil)
    }
    @IBAction func onBtnExportDrag(_ sender: Any) {
        btnExport.isPressed = false
    }
    
    /* Ping Button */
    @IBAction func onBtnPingPressed(_ sender: Any) {
        btnPing.isPressed = true
    }
    @IBAction func onBtnPingRelease(_ sender: Any) {
        btnPing.isPressed = false
        bleConn.logMsg(message: "Ping...")
        bleConn.write(msg: "7E00")
    }
    @IBAction func onBtnPingDrag(_ sender: Any) {
        btnPing.isPressed = false
    }
    
    /* Send Button */
    @IBAction func onBtnSendPressed(_ sender: Any) {
        btnSend.isPressed = true
    }
    @IBAction func onBtnSendRelease(_ sender: Any) {
        btnSend.isPressed = false
        if let message = msgHexValueTxtFld.text as String! {
            bleConn.write(msg: message)
        }
        
    }
    @IBAction func onBtnSendDrag(_ sender: Any) {
        btnSend.isPressed = false
    }
    
    
    func onPaoFound() {
        // Nothing needed here I think
    }
    
    func onMsgReceived(message: String!) {
        
        //let type: Int = BleCommProt.getType(msg: message)
        //bleConn.logMsg(message: "The received message type substring is: \(type)")
        // Nothing to do here for now
        //bleConn.logMsg(message: message)
    }
    
    func redrawConsole() {
        // No functionality here
        consoleTextView.attributedText = bleConn.consoleMessages;
    }
    
}
