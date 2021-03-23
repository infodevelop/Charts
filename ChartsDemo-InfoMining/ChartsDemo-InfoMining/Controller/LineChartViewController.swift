//
//  LineChartViewController.swift
//  ChartsDemo-InfoMining
//
//  Created by Heo on 2021/03/19.
//


import UIKit
import Charts

//GetChartData Protocol
protocol GetChartData {
    func getChartData(with dataPoints: [Date], values: [String])
    var time: [Date] {get set}
    var bpm: [String] {get set}
}

// vitalSign VO Model
struct vitalSign: Codable {
    let time : String
    let value : Int
}

class LineChartViewController: UIViewController, GetChartData {

    // lineChart
    @IBOutlet weak var lineChart: LineChart!
    
    // example Data(20ea)
    var allSigns = [vitalSign(time: "2021-01-26 18:45:56", value: 10),
                    vitalSign(time: "2021-01-26 18:52:08", value: 30),
                    vitalSign(time: "2021-01-26 18:55:53", value: 20),
                    vitalSign(time: "2021-01-26 18:59:35", value: 40),
                    vitalSign(time: "2021-01-26 19:03:01", value: 10),
                    vitalSign(time: "2021-01-26 19:05:32", value: 30),
                    vitalSign(time: "2021-01-26 19:07:14", value: 20),
                    vitalSign(time: "2021-01-26 19:08:14", value: 40),
                    vitalSign(time: "2021-01-26 19:12:47", value: 10),
                    vitalSign(time: "2021-01-26 19:15:20", value: 30),
                    vitalSign(time: "2021-01-26 19:17:55", value: 20),
                    vitalSign(time: "2021-01-26 19:23:35", value: 40),
                    vitalSign(time: "2021-01-26 19:26:01", value: 96),
                    vitalSign(time: "2021-01-26 19:27:32", value: 112),
                    vitalSign(time: "2021-01-26 19:30:14", value: 93),
                    vitalSign(time: "2021-01-26 19:32:54", value: 95),
                    vitalSign(time: "2021-01-26 19:35:47", value: 90),
                    vitalSign(time: "2021-01-26 19:37:24", value: 100),
                    vitalSign(time: "2021-01-26 19:39:10", value: 91),
                    vitalSign(time: "2021-01-26 19:41:27", value: 99)]
    
    // example Data(10ea)
    var allSigns2 = [vitalSign(time: "2021-01-26 18:45:00", value: 10),
                    vitalSign(time: "2021-01-26 18:50:00", value: 30),
                    vitalSign(time: "2021-01-26 18:55:00", value: 20),
                    vitalSign(time: "2021-01-26 19:00:00", value: 40),
                    vitalSign(time: "2021-01-26 19:05:00", value: 10),
                    vitalSign(time: "2021-01-26 19:10:00", value: 30),
                    vitalSign(time: "2021-01-26 19:15:00", value: 20),
                    vitalSign(time: "2021-01-26 19:20:00", value: 40),
                    vitalSign(time: "2021-01-26 19:25:00", value: 50),
                    vitalSign(time: "2021-01-26 19:30:00", value: 60)]
    
    // Chart Data 변수
    var time = [Date]()
    var bpm = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate chart data
        populateChartData()

        // Line Delegate
        lineChart.delegate = self
    }
    
    // Populate data
    func populateChartData() {
        
        time = allSigns2.map{convertToDate($0.time)}
        bpm = allSigns2.map{String($0.value)}
        
        self.getChartData(with: time, values: bpm)
    }
    
    // convert String to Date
    func convertToDate(_ stringDate: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormat.date(from: stringDate)!
    }
    
    // Conform to protocol
    func getChartData(with dataPoints: [Date], values: [String]) {
        self.time = dataPoints
        self.bpm = values
    }
}


