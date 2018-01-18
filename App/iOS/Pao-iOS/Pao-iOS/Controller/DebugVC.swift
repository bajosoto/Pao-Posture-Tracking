//
//  DebugVC.swift
//  Pao-iOS
//
//  Created by Sergio on 10/6/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import UIKit

class DebugVC: UIViewController, UITextFieldDelegate, bleConnectionResponder {

    @IBOutlet weak var segmentedThingie: UISegmentedControl!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var img5: UIImageView!
    @IBOutlet weak var img6: UIImageView!
    
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var title3: UILabel!
    @IBOutlet weak var text3: UILabel!
    @IBOutlet weak var title4: UILabel!
    @IBOutlet weak var text4: UILabel!
    @IBOutlet weak var title5: UILabel!
    @IBOutlet weak var text5: UILabel!
    @IBOutlet weak var title6: UILabel!
    @IBOutlet weak var text6: UILabel!
    
    @IBOutlet weak var consoleTextView: UITextView!
    @IBOutlet weak var msgHexValueTxtFld: UITextField!
    @IBOutlet weak var btnPing: AssetBtnPing!
    @IBOutlet weak var btnSend: AssetBtnSend!
    @IBOutlet weak var btnBack: AssetBtnBackView!
    @IBOutlet weak var btnExport: AssetBtnExport!
    
    @IBOutlet weak var axLbl: UILabel!
    @IBOutlet weak var ayLbl: UILabel!
    @IBOutlet weak var azLbl: UILabel!
    @IBOutlet weak var gxLbl: UILabel!
    @IBOutlet weak var gyLbl: UILabel!
    @IBOutlet weak var gzLbl: UILabel!
    @IBOutlet weak var phiLabel: UILabel!
    @IBOutlet weak var thetaLabel: UILabel!
    @IBOutlet weak var psiLabel: UILabel!
    
    
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
    
    private var _classifier: Classifier!
    var classifier: Classifier {
        get {
            return _classifier
        }
        set (newClassifier) {
            _classifier = newClassifier
        }
    }
    
    // Training states and label
    var currLabel: String = ""
    var sampleCnt: Int = 0
    var isSampling: Bool = false
    
    // Classifying state
    var isClassifying: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set this VC as the current responder
        if let bleConnResp = self as bleConnectionResponder? {
            // Store previous responder
            _prevResponder = bleConn.responder
            // Set new responder
            bleConn.responder = bleConnResp
        }
        
        segChanged(self)
        
//        // Set self as delegate for the text field
//        self.msgHexValueTxtFld.delegate = self
//
//        // Do any additional setup after loading the view.
//
//        // Text view stuff
//        consoleTextView.layoutManager.allowsNonContiguousLayout = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        consoleTextView.attributedText = bleConn.consoleMessages;
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
        // Scroll down to bottom
        let bottom = NSMakeRange(consoleTextView.text.characters.count - 2, 0)
        consoleTextView.scrollRangeToVisible(bottom)
    }
    
    func getSensorData(_ ax: Int16, _ ay: Int16, _ az: Int16, _ gx: Int16, _ gy: Int16, _ gz: Int16,
                       _ phi: Int16, _ theta: Int16, _ psi: Int16) {
        DispatchQueue.main.async {  //UIKit is not thread safe
            self.axLbl.text = "\(ax)"
            self.ayLbl.text = "\(ay)"
            self.azLbl.text = "\(az)"
            self.gxLbl.text = "\(gx)"
            self.gyLbl.text = "\(gy)"
            self.gzLbl.text = "\(gz)"
            self.phiLabel.text = "\(phi)"
            self.thetaLabel.text = "\(theta)"
            self.psiLabel.text = "\(psi)"
        }
        
        var shouldSaveSample = false
        var shouldClassifySample = false
        DispatchQueue.main.async {
            // Training data generation:
            if(self.isSampling == true) {//} || self.sampleCnt > 0) {
                shouldSaveSample = true
            } else if (self.isClassifying == true) {
                shouldClassifySample = true
            }
            
            if(shouldSaveSample == true) {
                self.classifier.addToDataset(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz, phi: phi,
                                             theta: theta, psi: psi, label: self.currLabel)
                self.sampleCnt += 1
            } else if(shouldClassifySample == true) {
                print("classifying...")
                // accumulate 10 samples
                // Array of 10 posture entries []
                // predictSampleSoft(_ testdata: [IPostureEntry]) -> [IPostureEntry]
                // get label
                // get posture (number)
                
//                self.classifier.classifyKnn(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz, nNeighbours: 15)
                self.classifier.addAndClassifySample(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz, phi: phi, theta: theta, psi: psi)
                
                self.sampleCnt += 1
            }
            
            if(self.sampleCnt == 10) {
                self.sampleCnt = 0
                if(self.isSampling == false) {
                    self.currLabel = ""
                }
            }
        }
    }
    
    func getPedo(_ pedo: Int16) {
        bleConn.logMsg(message: "Got pedo... \(pedo)")
    }
    
    func getNewEntry(_ label: Int16, _ proba: Int16, _ timestamp: Int16) {
        //bleConn.logMsg(message: "Received l:\(label) p:\(proba) t:\(timestamp)")
        self.classifier.storeReceivedEntry(label: label, proba: proba, timestamp: timestamp)
    }
    
    @IBAction func segChanged(_ sender: Any) {
        if segmentedThingie.selectedSegmentIndex == 0 {
            img1.image = UIImage(named: "video1")
            title1.text = "Sitting Posture Introduction"
            text1.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
            img2.image = UIImage(named: "video2")
            title2.text = "Sitting Posture Techniques"
            text2.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
            img3.image = UIImage(named: "video3")
            title3.text = "Standing Posture Introduction"
            text3.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
            img4.image = UIImage(named: "video4")
            title4.text = "Power Posing Introduction"
            text4.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
            img5.image = UIImage(named: "video5")
            title5.text = "Power Posing Techniques"
            text5.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
            img6.image = UIImage(named: "video6")
            title6.text = "Advanced Posture"
            text6.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
        } else {
            img1.image = UIImage(named: "video7")
            title1.text = "Introduction To Meditation"
            text1.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
            img2.image = UIImage(named: "video8")
            title2.text = "Breathing Meditations"
            text2.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
            img3.image = UIImage(named: "video9")
            title3.text = "Meditation Exercises Level 1"
            text3.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
            img4.image = UIImage(named: "video10")
            title4.text = "Meditation Exercises Level 2"
            text4.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
            img5.image = UIImage(named: "video11")
            title5.text = "Meditation Exercises Level 3"
            text5.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
            img6.image = UIImage(named: "video12")
            title6.text = "Meditation Exercises Level 4"
            text6.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet."
        }
    }
}
