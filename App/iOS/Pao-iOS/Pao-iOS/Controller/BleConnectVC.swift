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

class BleConnectVC: UIViewController, UITextViewDelegate, bleConnectionResponder {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var scanStatusLbl: UILabel!
    @IBOutlet weak var spinnningIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fadeOut: UIView!
    // IB outlet to Pao Finding View
    @IBOutlet weak var paoEggView: PaoFindingView!
    // Timer we'll use to refresh the Pao Finding animation
    fileprivate var clockTimer : Timer!
    // Ble Connection holding the connection to find Pao
    var isFadingOut = false
    var bleConn: BleConnection?
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // Create a ble connection
        if let bleConnResp = self as bleConnectionResponder? {
            bleConn = BleConnection(responder: bleConnResp)
        }
        // Initialize the BT connection
        bleConn?.connectBlePao()
        
        // Setup the Pao Finding animation timer @ 30Hz
        clockTimer = Timer.scheduledTimer( timeInterval: 0.03, target: self, selector: #selector(BleConnectVC.advancePaoFindingAnimation), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        clockTimer.invalidate()
        clockTimer = nil
    }
    
    // Advance the finding pao animation
    @objc func advancePaoFindingAnimation() {
        // No need to call setNeedsDisplay() since we do that in the setter for animationProgress
        paoEggView.animationProgress += 0.015 // (1/0.015) * 30ms ~= 2s egg oscillation
        if isFadingOut {
            if fadeOut.alpha < 1 {
                fadeOut.alpha += 0.025  // (1/0.025) * 30ms = 1.2s transition
            } else {
                // Perform segue
            }
        }
    }
    
    func onPaoFound() {
        // print("A pao was found! ============================")
        scanStatusLbl.text = "Pao found! :)"
        spinnningIndicator.isHidden = true
        isFadingOut = true
    }
    
}

