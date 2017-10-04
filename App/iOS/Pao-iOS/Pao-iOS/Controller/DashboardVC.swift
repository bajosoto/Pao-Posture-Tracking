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

    @IBOutlet weak var dashScrollView: UIScrollView!
    @IBOutlet weak var profilePicImg: UIImageView!
    @IBOutlet weak var postureBar: UIView!
    @IBOutlet weak var postureChart: LineChartView!
    
    // Axis format delegate
     weak var axisFormatDelegate: IAxisValueFormatter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round off profile picture
        profilePicImg.layer.cornerRadius = profilePicImg.frame.size.width / 2
        profilePicImg.layer.borderWidth = 3.0
        let blueColor = UIColor(red: 124/255, green: 188/255, blue: 232/255, alpha: 1.0)
        profilePicImg.layer.borderColor = blueColor.cgColor
        
        // Set axis format delegate
        axisFormatDelegate = self
        // Plot data
        updateChartWithData()

    }
    @IBAction func onTestBtnPress(_ sender: Any) {
        let postureEntry = PostureEntry()
        postureEntry.posture = Double(arc4random()) / Double(UINT32_MAX) // random number between 0 and 1
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
}

extension UIViewController: IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm.ss"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
