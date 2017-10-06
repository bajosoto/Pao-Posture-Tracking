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

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: {
            // Revert responder to previous
            self.bleConn.responder = self._prevResponder
        })
    }
    
    func onPaoFound() {
        // Nothing needed here I think
    }
    
    func onMsgReceived(message: String!) {
        // Nothing to do here for now
        consoleTextView.text = message;
    }
    
}
