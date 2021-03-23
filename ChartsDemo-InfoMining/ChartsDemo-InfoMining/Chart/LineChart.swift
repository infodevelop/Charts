//
//  LineChart.swift
//  ChartsDemo-InfoMining
//
//  Created by Heo on 2021/03/19.
//

import UIKit
import Charts

class LineChart: UIView {
    
    // Line Graph Properties
    let lineChartView = LineChartView()
    var lineDataEntry: [ChartDataEntry] = []
    
    // Chart data
    var time = [Date]()
    var bpm = [String]()
    
    // reference TimeInterval
    var referenceTimeInterval: TimeInterval = 0
    
    // delegate
    var delegate: GetChartData! {
        didSet {
            populateData()
            lineChartSetUp()
        }
    }
    
    func populateData() {
        time = delegate.time
        bpm = delegate.bpm
    }

    func lineChartSetUp() {

        // Line Chart Config
        self.backgroundColor = UIColor.white
        self.addSubview(lineChartView)
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        lineChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        // Line Chart Animation
        lineChartView.animate(xAxisDuration: 5.0, yAxisDuration: 0, easingOption: .easeInSine)

        // ReferenceTimeInterval Seatting
        if let minTimeInterval = (time.map{$0.timeIntervalSince1970}).min() {
            referenceTimeInterval = TimeInterval(minTimeInterval)
        }
        
        // Line Chart Population
        setLineChart(dataPoints: time, values: bpm)
    }
    
    
    func setLineChart(dataPoints: [Date], values: [String]) {

        // --- No data setup
        lineChartView.noDataTextColor = UIColor.white
        lineChartView.noDataText = "No data for the chart."
        lineChartView.backgroundColor = UIColor.white

        // --- Data point setup & color config
        for index in 0..<dataPoints.count {
            let timeInterval = dataPoints[index].timeIntervalSince1970
            let xValue = (timeInterval - referenceTimeInterval)
            let yValue = Double(values[index]) ?? 0
            let dataPoint = ChartDataEntry(x: xValue, y: yValue)
            lineDataEntry.append(dataPoint)
        }
        let chartDataSet = LineChartDataSet(entries: lineDataEntry, label: "BPM")
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        chartDataSet.colors = [UIColor.blue]
        chartDataSet.lineWidth = 2
        chartDataSet.setCircleColor(UIColor.blue)
        chartDataSet.circleHoleColor = UIColor.blue
        chartDataSet.circleRadius = 0
        chartDataSet.mode = .linear

        // --- Gradient fill
        let gradientColors = [UIColor.blue.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocaions: [CGFloat] = [1,0, 0.0] // positioning of gradient
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocaions) else {
            print("gradient Error"); return }
        chartDataSet.fill = LinearGradientFill(gradient: gradient, angle: 90.0)
        chartDataSet.drawFilledEnabled = false

        // --- Define chart xValue Formatter
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "HH:mm"
        dateFormat.locale = Locale(identifier: "ko_kr")
        dateFormat.timeZone = TimeZone(abbreviation: "KST")
        let xValuesFormatter = ChartXAxisDateFormatter(referenceTimeInterval: referenceTimeInterval, dateFormatter: dateFormat)
        
        // --- XAxis Setup
        let xAxis = lineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = xValuesFormatter
        
        // --- limitLine
        let ll1 = ChartLimitLine(limit: 105, label: "Upper Limit")
        ll1.lineWidth = 2
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .rightTop
        ll1.valueFont = .systemFont(ofSize: 10)
        
        let limitTime = dataPoints[5].timeIntervalSince1970 - referenceTimeInterval
        let ll2 = ChartLimitLine(limit: limitTime, label: "Limit")
        ll2.lineWidth = 2
        ll2.lineDashLengths = [5, 5]
        ll2.labelPosition = .rightTop
        ll2.valueFont = .systemFont(ofSize: 10)
        
        
        // --- Highlight Area
        let ha1 = HighlightedArea(startValue: 85, endValue: 95)
        ha1.backgroundColor = UIColor(red: 255/255.0, green: 0/255.0, blue: 255/255.0, alpha: 0.5)
        ha1.lineWidth = 2
        ha1.lineDashLengths = [5, 5]
        ha1.lineColor = UIColor(red: 240/255.0, green: 0/255.0, blue: 240/255.0, alpha: 1.0)
        
        let startTime = dataPoints[1].timeIntervalSince1970 - referenceTimeInterval
        let endTime = dataPoints[4].timeIntervalSince1970 - referenceTimeInterval
        let ha2 = HighlightedArea(startValue: startTime, endValue: endTime)
        ha2.backgroundColor = UIColor(red: 0/255.0, green: 255/255.0, blue: 255/255.0, alpha: 0.5)
        ha2.lineWidth = 2
        ha2.lineDashLengths = [5, 5]
        ha2.lineColor = UIColor(red: 0/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        // --- XAxis Component
        xAxis.drawLimitLinesBehindDataEnabled = true
        xAxis.addLimitLine(ll2)
        xAxis.drawHighlightedAreasBehindDataEnabled = true
        xAxis.addHighlightedArea(ha2)
        
        
        // --- LeftAxis
        let leftAxis = lineChartView.leftAxis
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.addLimitLine(ll1)
        leftAxis.drawHighlightedAreasBehindDataEnabled = true
        leftAxis.addHighlightedArea(ha1)
        
        leftAxis.drawGridLinesEnabled = true
        leftAxis.enabled = true
        
        // --- RightAxis
        lineChartView.rightAxis.enabled = false
        
        // --- ???
        lineChartView.chartDescription.enabled = false
        lineChartView.legend.enabled = false
        lineChartView.data = chartData
    }
}

