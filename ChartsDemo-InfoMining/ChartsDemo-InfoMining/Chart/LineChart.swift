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
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 0, easingOption: .easeInSine)

        // ReferenceTimeInterval Setting
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
        chartDataSet.setCircleColor(UIColor.blue)
        chartDataSet.circleHoleColor = UIColor.blue
        chartDataSet.circleRadius = 4.0

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
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .rightTop
        ll1.valueFont = .systemFont(ofSize: 10)
        
        // --- Highlight Area
        
        // --- LeftAxis
        let leftAxis = lineChartView.leftAxis
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.addLimitLine(ll1)
//        InfoVitalChartLeftAxis.addHighligh
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

