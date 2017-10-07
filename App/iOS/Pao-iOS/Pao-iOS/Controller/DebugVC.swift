//
//  DebugVC.swift
//  Pao-iOS
//
//  Created by Sergio on 10/6/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import UIKit

class DebugVC: UIViewController, bleConnectionResponder {

    @IBOutlet weak var consoleTextView: UITextView!
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
        
        // Do any additional setup after loading the view.
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
        bleConn.write()
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
    }
    @IBAction func onBtnSendDrag(_ sender: Any) {
        btnSend.isPressed = false
    }
    
    
    func onPaoFound() {
        // Nothing needed here I think
    }
    
    func onMsgReceived(message: String!) {
        // Nothing to do here for now
        consoleTextView.text = message;
    }
    
}
