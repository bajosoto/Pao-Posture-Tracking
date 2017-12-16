//
//  BleConnectVC.swift
//  Pao
//
//  Created by Sergio Soto on 02/10/2017.
//  Copyright © 2017 Sergio Soto. All rights reserved.
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
            bleConn = BleConnection(newResponder: bleConnResp)
        }
        // Initialize the BT connection
        bleConn?.connectBlePao()
        
        // Setup the Pao Finding animation timer @ 30Hz
        clockTimer = Timer.scheduledTimer( timeInterval: 0.03, target: self, selector: #selector(BleConnectVC.advancePaoFindingAnimation), userInfo: nil, repeats: true)
    }
    
    // Advance the finding pao animation
    @objc func advancePaoFindingAnimation() {
        // No need to call setNeedsDisplay() since we do that in the setter for animationProgress
        paoEggView.animationProgress += 0.015 // (1/0.015) * 30ms ~= 2s egg oscillation
        if isFadingOut {
            if fadeOut.alpha < 1 {
                fadeOut.alpha += 0.06  // (1/0.025) * 30ms = 1.2s transition
            } else {
                // Stop timer
                clockTimer.invalidate()
                clockTimer = nil
                // Perform segue
                performSegue(withIdentifier: "toDashboard", sender: bleConn)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DashboardVC {
            if let newConnection = sender as? BleConnection {
                dest.bleConn = newConnection
            }
        }
    }
    
    func onPaoFound() {
        // print("A pao was found! ============================")
        scanStatusLbl.text = "Pao found! :)"
        spinnningIndicator.isHidden = true
        isFadingOut = true
    }
    
    func onMsgReceived(message: String!) {
        // No functionality on this view
    }
    
    func redrawConsole() {
        // No functionality here
    }
    
    func getSensorData(_ ax: Int16, _ ay: Int16, _ az: Int16, _ gx: Int16, _ gy: Int16, _ gz: Int16,
                       _ phi: Int16, _ theta: Int16, _ psi: Int16) {
        // Nothing to do
    }

    func getPedo(_ pedo: Int16) {
        
    }
    
    func getNewEntry(_ label: Int16, _ proba: Int16, _ timestamp: Int16) {
        
    }
    
}

