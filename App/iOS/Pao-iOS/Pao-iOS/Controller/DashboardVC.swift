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

class DashboardVC: UIViewController {

    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var postureBar: UIView!
    @IBOutlet weak var postureChart: LineChartView!
    

    @IBOutlet weak var btnTrainView: AssetBtnTrainView!
    @IBOutlet weak var btnDebugView: AssetBtnDebugView!
    @IBOutlet weak var btnConfigView: AssetBtnConfigView!
    @IBOutlet weak var btnHelpView: AssetBtnHelpView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round off profile picture
        profilePicImg.layer.cornerRadius = profilePicImg.frame.size.width / 2
        profilePicImg.layer.borderWidth = 3.0
        profilePicImg.layer.borderColor = whiteAlphaColor.cgColor
        
        // Set axis format delegate
        axisFormatDelegate = self
        // Plot data
        updateChartWithData()

    }
    @IBAction func onTestBtnPress(_ sender: Any) {
        let postureEntry = PostureEntry()
        let randInt = (Double(arc4random()) / Double(UINT32_MAX) ) * 2.0 - 1.0
        postureEntry.posture = randInt // random number between -1 and 1
        postureEntry.save()
        updateChartWithData()
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
        postureChart.animate(yAxisDuration: 1.0, easingOption: .easeOutCubic)
        postureChart.scaleYEnabled = false
        postureChart.highlightPerTapEnabled = false
        postureChart.highlightPerDragEnabled = false
        postureChart.setVisibleXRangeMaximum(10.0)  // In seconds. Will make the app crash if insufficient data is available
        postureChart.setVisibleXRangeMinimum(3.0)   // In seconds. Will make the app crash if insufficient data is available
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
        
        
        postureChart.leftAxis.axisMinimum = -1.0
        postureChart.leftAxis.axisMaximum = 1.0
        postureChart.leftAxis.drawGridLinesEnabled = false
        postureChart.leftAxis.drawZeroLineEnabled = true
        postureChart.leftAxis.axisLineWidth = 0
        postureChart.leftAxis.zeroLineColor = NSUIColor(cgColor: whiteAlphaColor.cgColor)
        postureChart.leftAxis.zeroLineWidth = 1.0
        postureChart.leftAxis.drawLabelsEnabled = false
        postureChart.leftAxis.removeAllLimitLines()
        
        postureChart.rightAxis.axisMinimum = -1.0
        postureChart.rightAxis.axisMaximum = 1.0
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
        
    }
    
    func getPostureEntriesFromDatabase() -> Results<PostureEntry> {
        do {
            let realm = try Realm()
            return realm.objects(PostureEntry.self)
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    
    @IBAction func onbtnTrainPressed(_ sender: Any) {
        btnTrainView.isPressed = true
    }
    @IBAction func onBtnTrainReleased(_ sender: Any) {
        btnTrainView.isPressed = false
    }
    @IBAction func onBtnTrainDrag(_ sender: Any) {
        btnTrainView.isPressed = false
    }
    
    
    @IBAction func onBtnDebugPressed(_ sender: Any) {
        btnDebugView.isPressed = true
    }
    @IBAction func onBtnDebugReleased(_ sender: Any) {
        btnDebugView.isPressed = false
    }
    @IBAction func onBtnDebugDrag(_ sender: Any) {
        btnDebugView.isPressed = false
    }
    
    
    @IBAction func onBtnConfigPressed(_ sender: Any) {
        btnConfigView.isPressed = true
    }
    @IBAction func onBtnConfigReleased(_ sender: Any) {
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
    }
    @IBAction func onBtnHelpDrag(_ sender: Any) {
        btnHelpView.isPressed = false
    }
    
    
}

extension UIViewController: IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}









