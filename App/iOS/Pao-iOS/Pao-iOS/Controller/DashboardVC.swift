//
//  DashboardVC.swift
//  Pao-iOS
//
//  Created by Sergio on 10/3/17.
//  Copyright © 2017 Sergio. All rights reserved.
//

import UIKit
import Charts
import ChartsRealm
import RealmSwift
import Recognition

class DashboardVC: UIViewController, bleConnectionResponder {

    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var postureBar: PaoPostureBarView!
    @IBOutlet weak var postureChart: LineChartView!
    
    @IBOutlet weak var btnTrainView: AssetBtnTrainView!
    @IBOutlet weak var btnDebugView: AssetBtnDebugView!
    @IBOutlet weak var btnConfigView: AssetBtnConfigView!
    @IBOutlet weak var btnHelpView: AssetBtnHelpView!
    @IBOutlet weak var btnGoalsView: UIButton!
    
    // Train Buttons
    @IBOutlet weak var btnTrainSitOk: AssetBtnTrainSittingOkView!
    @IBOutlet weak var btnTrainSitNok: AssetBtnTrainSittingNokView!
    @IBOutlet weak var btnTrainStndOk: AssetBtnTrainStandingOkView!
    @IBOutlet weak var btnTrainStndNok: AssetBtnTrainStandingNokView!
    @IBOutlet weak var btnTrainMvOk: AssetBtnTrainMovingOkView!
    @IBOutlet weak var btnTrainMvNok: AssetBtnTrainMovingNokView!
    @IBOutlet weak var btnTrainBack: AssetBtnBackView!
    
    @IBOutlet weak var btnGoalsBackView: AssetBtnBackView!
    
    @IBOutlet weak var BlurEffectVC: UIVisualEffectView!
    @IBOutlet var trainButtonsView: UIView!
    @IBOutlet var goalsConfigView: UIView!
    
    // Sliders
    @IBOutlet weak var sittingSlider: UISlider!
    @IBOutlet weak var standingSlider: UISlider!
    @IBOutlet weak var movingSlider: UISlider!
    @IBOutlet weak var stepsSlider: UISlider!
    @IBOutlet weak var sittingGoalLbl: UILabel!
    @IBOutlet weak var standingGoalLbl: UILabel!
    @IBOutlet weak var movingGoalLbl: UILabel!
    @IBOutlet weak var stepsGoalLbl: UILabel!

    // Goal circle bar views
    @IBOutlet weak var goalSitBarView: PaoSittingGoalView!
    @IBOutlet weak var goalStandingBarView: PaoStandingGoalView!
    @IBOutlet weak var goalMovingBarView: PaoMovingGoalView!
    @IBOutlet weak var goalStepsBarView: PaoStepsGoalView!
    
    // Goal targets (percentage / steps)
    var goalSit: Float = 0.2
    var goalStand: Float = 0.4
    var goalMove: Float = 0.5
    var goalSteps: Float = 15.0
    
    // Goal total (to calculate percentage)
    var totSit: Float = 0
    var totStand: Float = 0
    var totMove: Float = 0
    
    // Goal currents (good postures / steps)
    var currSit: Float = 0
    var currStand: Float = 0
    var currMove: Float = 0
    var currSteps: Float = 0
    
    
    var effect: UIVisualEffect!
    
    private var _bleConn: BleConnection!
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
    
    
    // Axis format delegate
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    // Colors
    let blueColor = UIColor(red: 124/255, green: 188/255, blue: 232/255, alpha: 1.0)
    let darkBlueColor = UIColor(red: 72/255, green: 175/255, blue: 234/255, alpha: 1.0)
    let redColor = UIColor(red: 231/255, green: 121/255, blue: 121/255, alpha: 1.0)
    let grayColor = UIColor(red: 115/255, green: 115/255, blue: 115/255, alpha: 1.0)
    let whiteColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let whiteAlphaColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
    let paoBarBlue = UIColor(red: 0.024, green: 0.671, blue: 0.925, alpha: 1.000)
    let paoBarGreen = UIColor(red: 0.184, green: 0.886, blue: 0.686, alpha: 1.000)
    
    // Training states and label
    var currLabel: String = ""
    var sampleCnt: Int = 0
    var isSampling: Bool = false
    
    // Classifying state
    var isClassifying: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Store blur effect
        effect = BlurEffectVC.effect
        BlurEffectVC.effect = nil
        
        // Goal slider colors
        sittingSlider.minimumTrackTintColor = paoBarBlue
        sittingSlider.maximumTrackTintColor = paoBarGreen
        standingSlider.minimumTrackTintColor = paoBarBlue
        standingSlider.maximumTrackTintColor = paoBarGreen
        movingSlider.minimumTrackTintColor = paoBarBlue
        movingSlider.maximumTrackTintColor = paoBarGreen
        stepsSlider.minimumTrackTintColor = paoBarBlue
        stepsSlider.maximumTrackTintColor = paoBarGreen
        
        sittingSlider.value = goalSit
        standingSlider.value = goalStand
        movingSlider.value = goalMove
        stepsSlider.value = goalSteps
        
        // Corners for train buttons view
        trainButtonsView.layer.cornerRadius = 5
        goalsConfigView.layer.cornerRadius = 5
        
        // Set this VC as the current responder
        if let bleConnResp = self as bleConnectionResponder? {
            bleConn.responder = bleConnResp
        }
        
        // Create a classifier
        classifier = Classifier(numSamples: 30, bleConn: _bleConn)
        
        // Round off profile picture
        profilePicImg.layer.cornerRadius = profilePicImg.frame.size.width / 2
        profilePicImg.layer.borderWidth = 3.0
        profilePicImg.layer.borderColor = whiteAlphaColor.cgColor
        
        // Set axis format delegate
        axisFormatDelegate = self
        // Plot data
        updateChartWithData()
        
        // Request data dump
        bleConn.write(msg: "7E07")

    }
    
    func animateGoalViewIn() {
        self.view.addSubview(goalsConfigView)
        goalsConfigView.center = self.view.center
        goalsConfigView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        goalsConfigView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.BlurEffectVC.effect = self.effect
            self.goalsConfigView.alpha = 1
            self.goalsConfigView.transform = CGAffineTransform.identity
        }
    }
    
    func animateGoalViewOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.goalsConfigView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.goalsConfigView.alpha = 0
            self.BlurEffectVC.effect = nil
        }) { (success:Bool) in
            self.goalsConfigView.removeFromSuperview()
        }
    }
    
    func animateTrainButtonsIn() {
        self.view.addSubview(trainButtonsView)
        trainButtonsView.center = self.view.center
        trainButtonsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        trainButtonsView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.BlurEffectVC.effect = self.effect
            self.trainButtonsView.alpha = 1
            self.trainButtonsView.transform = CGAffineTransform.identity
        }
    }
    
    func animateTrainButtonsOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.trainButtonsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.trainButtonsView.alpha = 0
            self.BlurEffectVC.effect = nil
        }) { (success:Bool) in
            self.trainButtonsView.removeFromSuperview()
        }
    }
    
    @IBAction func onHiddenButtonPress(_ sender: Any) {
        //        let postureEntry = PostureEntry()
        //        let randInt = (Double(arc4random()) / Double(UINT32_MAX) ) * 2.0 - 1.0
        //        postureEntry.posture = randInt // random number between -1 and 1
        //        postureEntry.save()
        //        updateChartWithData()
        
        // Reset numbers for demo
        totSit = 0
        currSit = 0
        totStand = 0
        currStand = 0
        totMove = 0
        currMove = 0
        
        // Reset history for demo
        try! classifier.entriesRealm.write{
            classifier.entriesRealm.deleteAll()
        }
        updateChartWithData()
    }
    @IBAction func onHiddenEraseCalBtnPress(_ sender: Any) {
//        classifier.hasBeenTrained = false
//        try! classifier.rawRealm.write {
//            classifier.rawRealm.deleteAll()
//        }
    }
    
    func updateChartWithData() {
        var dataEntries: [ChartDataEntry] = []
        let postureEntries = getPostureEntriesFromDatabase()
        for i in 0..<postureEntries.count {
            let timeIntervalForDate: TimeInterval = postureEntries[i].date.timeIntervalSince1970
            let dataEntry = ChartDataEntry(x: Double(timeIntervalForDate), y: Double(postureEntries[i].posture))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Posture")
        let chartData = LineChartData(dataSet: chartDataSet)
        postureChart.data = chartData
        
        // This probably goes somewhere else ====================================================================================
        postureChart.noDataText = "Pao has no data available (yet!)"
//        postureChart.borderLineWidth = 3.0
//        postureChart.borderColor = blueColor
//        postureChart.drawBordersEnabled = false
        postureChart.chartDescription?.text = ""
        // postureChart.animate(yAxisDuration: 1.0, easingOption: .easeOutCubic)
        postureChart.scaleYEnabled = false
        postureChart.highlightPerTapEnabled = false
        postureChart.highlightPerDragEnabled = false
        if(chartDataSet.entryCount > 0) {   // TODO: This should be in terms of the time interval measurements ar etaken
            postureChart.setVisibleXRangeMaximum(60.0)  // In seconds. Will make the app crash if insufficient data is available
            postureChart.setVisibleXRangeMinimum(3.0)   // In seconds. Will make the app crash if insufficient data is available
            
        }
        postureChart.legend.enabled = false
        
        chartDataSet.mode = .horizontalBezier
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.drawFilledEnabled = true
        let locations: [CGFloat] = [ 0.3, 0.7 ]
        let colors = [paoBarBlue.cgColor, paoBarGreen.cgColor] as CFArray
        let colorspace = CGColorSpaceCreateDeviceRGB()
        if let gradient = CGGradient(colorsSpace: colorspace, colors: colors, locations: locations) {
            // fill with gradient
            chartDataSet.fillAlpha = 1
            chartDataSet.fill = Fill(linearGradient: gradient, angle: 90)
            chartDataSet.drawFilledEnabled = true
        }
        chartDataSet.drawValuesEnabled = false
        chartDataSet.colors = [NSUIColor(cgColor: whiteColor.cgColor)]
        chartDataSet.lineWidth = 1.0
        
        postureChart.xAxis.drawAxisLineEnabled = false
        postureChart.xAxis.drawGridLinesEnabled = true
        postureChart.xAxis.labelCount = 6
        postureChart.xAxis.labelRotationAngle = 0
        postureChart.xAxis.drawLimitLinesBehindDataEnabled = false
        postureChart.xAxis.labelTextColor = whiteAlphaColor
        postureChart.xAxis.gridColor = whiteAlphaColor
        
        
        postureChart.leftAxis.axisMinimum = -1.05
        postureChart.leftAxis.axisMaximum = 1.05
        postureChart.leftAxis.drawGridLinesEnabled = false
        postureChart.leftAxis.drawZeroLineEnabled = true
        postureChart.leftAxis.axisLineWidth = 0
        postureChart.leftAxis.zeroLineColor = NSUIColor(cgColor: whiteAlphaColor.cgColor)
        postureChart.leftAxis.zeroLineWidth = 1.0
        postureChart.leftAxis.drawLabelsEnabled = false
        postureChart.leftAxis.removeAllLimitLines()
        
        postureChart.rightAxis.axisMinimum = -1.05
        postureChart.rightAxis.axisMaximum = 1.05
        postureChart.rightAxis.drawGridLinesEnabled = false
        postureChart.rightAxis.drawZeroLineEnabled = true
        postureChart.rightAxis.axisLineWidth = 0
        postureChart.rightAxis.zeroLineColor = NSUIColor(cgColor: whiteAlphaColor.cgColor)
        postureChart.rightAxis.zeroLineWidth = 1.0
        postureChart.rightAxis.drawLabelsEnabled = false
        postureChart.rightAxis.removeAllLimitLines()
        
        let gradient = CAGradientLayer()
        gradient.frame = postureChart.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.05, 0.15, 0.85, 0.95]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y:0.5);
        postureChart.layer.mask = gradient
        
        // End of: This probably goes somewhere else ====================================================================================

//        let goodBadPosture = ChartLimitLine(limit: 0.5)
//        goodBadPosture.lineColor = NSUIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1.0)
//        goodBadPosture.lineWidth = 1.5
//        postureChart.leftAxis.addLimitLine(goodBadPosture)
        
        let xaxis = postureChart.xAxis
        xaxis.valueFormatter = axisFormatDelegate
        
        // Scroll view to show last item  -> I disabled it because it's annoying that it wont let you zoom in and explore without resetting. maybe when interval period is longer...
//        if let lastXVal = postureEntries.last?.date.timeIntervalSince1970 {
//            postureChart.moveViewToX(Double(lastXVal))
//        }
    }
    
    func getPostureEntriesFromDatabase() -> Results<PostureEntry> {
//        do {
//            let realm = try Realm()
//            return realm.objects(PostureEntry.self)
//        } catch let error as NSError {
//            fatalError(error.localizedDescription)
//        }
        return self.classifier.entriesRealm.objects(PostureEntry.self).sorted(byKeyPath: "date", ascending: true)
        
    }
    
    @IBAction func onBtnGoalsReleased(_ sender: Any) {
        animateGoalViewIn()
    }
    
    @IBAction func onBtnGoalsBackPressed(_ sender: Any) {
        btnGoalsBackView.isPressed = true
    }
    @IBAction func onBtnGoalsBackReleased(_ sender: Any) {
        btnGoalsBackView.isPressed = false
        animateGoalViewOut()
    }
    @IBAction func onBtnGoalsBackDrag(_ sender: Any) {
        btnGoalsBackView.isPressed = false
    }
    
    @IBAction func onbtnTrainPressed(_ sender: Any) {
        btnTrainView.isPressed = true
    }
    @IBAction func onBtnTrainReleased(_ sender: Any) {
        btnTrainView.isPressed = false
        //isClassifying = false     // IoT
        animateTrainButtonsIn()
        // Request ES state to S4_TRAINING
        bleConn.write(msg: "7E0504")
    }
    @IBAction func onBtnTrainDrag(_ sender: Any) {
        btnTrainView.isPressed = false
    }
    
    @IBAction func onBtnDebugPressed(_ sender: Any) {
        btnDebugView.isPressed = true
    }
    @IBAction func onBtnDebugReleased(_ sender: Any) {
        btnDebugView.isPressed = false
        performSegue(withIdentifier: "toDebug", sender: bleConn)
    }
    @IBAction func onBtnDebugDrag(_ sender: Any) {
        btnDebugView.isPressed = false
    }
    
    
    @IBAction func onBtnConfigPressed(_ sender: Any) {
        btnConfigView.isPressed = true
    }
    @IBAction func onBtnConfigReleased(_ sender: Any) {
        // Snooze button
        bleConn.write(msg: "7E04")
        btnConfigView.isPressed = false
    }
    @IBAction func onBtnConfigDrag(_ sender: Any) {
        btnConfigView.isPressed = false
    }
    
    
    @IBAction func onBtnHelpPressed(_ sender: Any) {
        btnHelpView.isPressed = true
    }
    @IBAction func onBtnHelpReleased(_ sender: Any) {
        btnHelpView.isPressed = false
        // Send ping message (which also calibrates)
        bleConn.write(msg: "7E00")
        classifier.train()
    }
    @IBAction func onBtnHelpDrag(_ sender: Any) {
        btnHelpView.isPressed = false
    }
    
    // Training Buttons
    @IBAction func onBtnTrainSitOkPressed(_ sender: Any) {
        btnTrainSitOk.isPressed = true
    }
    @IBAction func onBtnTrainSitOkReleased(_ sender: Any) {
        if(btnTrainSitOk.takingMeasurement == false){
            btnTrainSitOk.takingMeasurement = true
            btnTrainSitOk.isPressed = true
//            isSampling = true     // IoT
//            currLabel = "SitOk"   // IoT
            
            // Label 0, enable training
            bleConn.write(msg: "7E060001")
        } else {
            btnTrainSitOk.takingMeasurement = false
            btnTrainSitOk.isPressed = false
//            isSampling = false    // IoT
            
            // Label 0, disable training
            bleConn.write(msg: "7E060000")
        }
    }
    @IBAction func onBtnTrainSitOkDrag(_ sender: Any) {
        btnTrainSitOk.isPressed = false
    }
    
    @IBAction func onBtnTrainSitNokPressed(_ sender: Any) {
        btnTrainSitNok.isPressed = true
    }
    @IBAction func onBtnTrainSitNokReleased(_ sender: Any) {
        if(btnTrainSitNok.takingMeasurement == false){
            btnTrainSitNok.takingMeasurement = true
            btnTrainSitNok.isPressed = true
//            isSampling = true         // IoT
//            currLabel = "SitNok"      // IoT
            
            // Label 1, enable training
            bleConn.write(msg: "7E060101")
        } else {
            btnTrainSitNok.takingMeasurement = false
            btnTrainSitNok.isPressed = false
//            isSampling = false        // IoT
            
            // Label 1, disable training
            bleConn.write(msg: "7E060100")
        }
    }
    @IBAction func onBtnTrainSitNokDrag(_ sender: Any) {
        btnTrainSitNok.isPressed = false
    }
    
    @IBAction func onBtnTrainStndOkPressed(_ sender: Any) {
        btnTrainStndOk.isPressed = true
    }
    @IBAction func onBtnTrainStndOkReleased(_ sender: Any) {
        if(btnTrainStndOk.takingMeasurement == false){
            btnTrainStndOk.takingMeasurement = true
            btnTrainStndOk.isPressed = true
//            isSampling = true         // IoT
//            currLabel = "StandOk"     // IoT
        } else {
            btnTrainStndOk.takingMeasurement = false
            btnTrainStndOk.isPressed = false
//            isSampling = false        // IoT
        }
    }
    @IBAction func onBtnTrainStndOkDrag(_ sender: Any) {
        btnTrainStndOk.isPressed = false
    }
    
    @IBAction func onBtnTrainStndNokPressed(_ sender: Any) {
        btnTrainStndNok.isPressed = true
    }
    @IBAction func onBtnTrainStndNokReleased(_ sender: Any) {
        if(btnTrainStndNok.takingMeasurement == false){
            btnTrainStndNok.takingMeasurement = true
            btnTrainStndNok.isPressed = true
//            isSampling = true             // IoT
//            currLabel = "StandNok"        // IoT
        } else {
            btnTrainStndNok.takingMeasurement = false
            btnTrainStndNok.isPressed = false
//            isSampling = false            // IoT
        }
    }
    @IBAction func onBtnTrainStndNokDrag(_ sender: Any) {
        btnTrainStndNok.isPressed = false
    }
    
    @IBAction func onBtnTrainMvOkPressed(_ sender: Any) {
        btnTrainMvOk.isPressed = true
    }
    @IBAction func onBtnTrainMvOkReleased(_ sender: Any) {
        if(btnTrainMvOk.takingMeasurement == false){
            btnTrainMvOk.takingMeasurement = true
            btnTrainMvOk.isPressed = true
//            isSampling = true     // IoT
//            currLabel = "MovOk"   // IoT
            
            // Label 2, enable training
            bleConn.write(msg: "7E060201")
        } else {
            btnTrainMvOk.takingMeasurement = false
            btnTrainMvOk.isPressed = false
//            isSampling = false    // IoT
            
            // Label 2, disable training
            bleConn.write(msg: "7E060200")
        }
    }
    @IBAction func onBtnTrainMvOkDrag(_ sender: Any) {
        btnTrainMvOk.isPressed = false
    }
    
    @IBAction func onBtnTrainMvNokPressed(_ sender: Any) {
        btnTrainMvNok.isPressed = true
    }
    @IBAction func onBtnTrainMvNokReleased(_ sender: Any) {
        if(btnTrainMvNok.takingMeasurement == false){
            btnTrainMvNok.takingMeasurement = true
            btnTrainMvNok.isPressed = true
//            isSampling = true     // IoT
//            currLabel = "MovNok"  // IoT
            
            // Label 3, enable training
            bleConn.write(msg: "7E060301")
        } else {
            btnTrainMvNok.takingMeasurement = false
            btnTrainMvNok.isPressed = false
//            isSampling = false        // IoT
            
            // Label 3, disbale training
            bleConn.write(msg: "7E060300")
        }
    }
    @IBAction func onBtnTrainMvNokDrag(_ sender: Any) {
        btnTrainMvNok.isPressed = false
    }
    
    @IBAction func onBtnTrainBackPressed(_ sender: Any) {
        btnTrainBack.isPressed = true
    }
    @IBAction func onBtnTrainBackReleased(_ sender: Any) {
        btnTrainBack.isPressed = false
//        classifier.train()    // IoT
//        isClassifying = true  // IoT
        animateTrainButtonsOut()
        // Request ES state to S3_CONNECTED
        bleConn.write(msg: "7E0503")
    }
    @IBAction func onBtnTrainBackDrag(_ sender: Any) {
        btnTrainBack.isPressed = false
    }
    
    
    // Sliders
    @IBAction func onSittingSliderChange(_ sender: Any) {
        goalSit = sittingSlider.value
        sittingGoalLbl.text = String(format: "SITTING: %.0f%%", goalSit * 100)
        
    }
    
    @IBAction func onStandingSliderChange(_ sender: Any) {
        goalStand = standingSlider.value
        standingGoalLbl.text = String(format: "STANDING: %.0f%%", goalStand * 100)
    }
    
    @IBAction func onMovingSliderChange(_ sender: Any) {
        goalMove = movingSlider.value
        movingGoalLbl.text = String(format: "MOVING: %.0f%%", goalMove * 100)
    }

    @IBAction func onStepsSliderChange(_ sender: Any) {
        goalSteps = stepsSlider.value
        stepsGoalLbl.text = String(format: "STEPS: %.0f", goalSteps)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? DebugVC {
            if let newConnection = sender as? BleConnection {
                dest.bleConn = newConnection
                dest.classifier = self.classifier
            }
        }
    }
    
    func onPaoFound() {
        // Nothing to do here for now
    }
    
    func onMsgReceived(message: String!) {
        // Nothing to do here for now
    }
    
    func redrawConsole() {
        // No functionality here
    }
    
    func getSensorData(_ ax: Int16, _ ay: Int16, _ az: Int16, _ gx: Int16, _ gy: Int16, _ gz: Int16,
                       _ phi: Int16, _ theta: Int16, _ psi: Int16) {
        
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
                self.classifier.addToDataset(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz,
                                             phi: phi, theta: theta, psi: psi, label: self.currLabel)
                self.sampleCnt += 1
            } else if(shouldClassifySample == true) {
                print("classifying...")
//                self.classifier.classifyKnn(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz, nNeighbours: 15)
                
                if self.classifier.hasBeenTrained {
                    self.classifier.addAndClassifySample(ax: ax, ay: ay, az: az, gx: gx, gy: gy, gz: gz, phi: phi, theta: theta, psi: psi)
                    self.sampleCnt += 1
                    
                    
                    var postureBarVal = 0.5
                    if let lastPostureProb = self.classifier.entriesRealm.objects(PostureEntry.self).last {
                        // Calculate value for posture bar
                        // 0.5 +/- 0...0.5
                        postureBarVal += lastPostureProb.posture / 2.0     // Unsafe unwrap! TODO: Change this
                        self.postureBar.posture = CGFloat(postureBarVal)
                        self.updateChartWithData()  // Too much overhead putting this here!
                        
                        // calculate goals
                        switch lastPostureProb.postureLbl {
                        case "SitOk":
                            self.totSit += 1.0
                            self.currSit += 1.0
                            self.goalSitBarView.posture = CGFloat((self.currSit / self.totSit) / self.goalSit)
                            break
                        case "SitNok":
                            self.totSit += 1.0
                            self.goalSitBarView.posture = CGFloat((self.currSit / self.totSit) / self.goalSit)
                            break
                        case "StandOk":
                            self.totStand += 1.0
                            self.currStand += 1.0
                            // self.goalStandingBarView.posture = CGFloat((self.currStand / self.totStand) / self.goalStand)
                            break
                        case "StandNok":
                            self.totStand += 1.0
                            // self.goalStandingBarView.posture = CGFloat((self.currStand / self.totStand) / self.goalStand)
                            break
                        case "MovOk":
                            self.totMove += 1.0
                            self.currMove += 1.0
                            self.goalMovingBarView.posture = CGFloat((self.currMove / self.totMove) / self.goalMove)
                            break
                        case "MovNok":
                            self.totMove += 1.0
                            self.goalMovingBarView.posture = CGFloat((self.currMove / self.totMove) / self.goalMove)
                            break
                            default:
                            break
                        }
                    }
                }
            }
            
            if(self.sampleCnt == 10) {      // I think this is not needed anymore?
                self.sampleCnt = 0
                if(self.isSampling == false) {
                    self.currLabel = ""
                }
            }
            
            
        }
    }
    
    
    func getPedo(_ pedo: Int16) {
        currSteps = Float(pedo)
        goalStepsBarView.posture = CGFloat(currSteps / goalSteps)
    }
    
    func getNewEntry(_ label: Int16, _ proba: Int16, _ timestamp: Int16) {
        bleConn.logMsg(message: "Received l:\(label) p:\(proba) t:\(timestamp)")
        var signedProba: Int16
        if(label == 1 || label == 3) {
            // Invert proba
            signedProba = -proba
        } else {
            signedProba = proba
        }
        self.classifier.storeReceivedEntry(label: label, proba: signedProba, timestamp: timestamp)
        
        // Update chart with new data
        self.updateChartWithData()
        
        // Update real-time posture feedback bar
        self.postureBar.posture = CGFloat(0.5 + (Double(signedProba) / 200.0))
        
        // Update goals
        switch label {
        case 0:
            self.totSit += 1.0
            self.currSit += 1.0
            self.goalSitBarView.posture = CGFloat((self.currSit / self.totSit) / self.goalSit)
            break
        case 1:
            self.totSit += 1.0
            self.goalSitBarView.posture = CGFloat((self.currSit / self.totSit) / self.goalSit)
            break
        case 4:
            self.totStand += 1.0
            self.currStand += 1.0
            // self.goalStandingBarView.posture = CGFloat((self.currStand / self.totStand) / self.goalStand)
            break
        case 5:
            self.totStand += 1.0
            // self.goalStandingBarView.posture = CGFloat((self.currStand / self.totStand) / self.goalStand)
            break
        case 2:
            self.totMove += 1.0
            self.currMove += 1.0
            self.goalMovingBarView.posture = CGFloat((self.currMove / self.totMove) / self.goalMove)
            break
        case 3:
            self.totMove += 1.0
            self.goalMovingBarView.posture = CGFloat((self.currMove / self.totMove) / self.goalMove)
            break
        default:
            break
        }
    }
    
}

extension UIViewController: IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}









