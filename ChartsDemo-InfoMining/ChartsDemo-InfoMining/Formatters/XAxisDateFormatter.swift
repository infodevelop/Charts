//
//  XAxisDateFormatter.swift
//  ChartsDemo-InfoMining
//
//  Created by Heo on 2021/03/19.
//
import Foundation
import Charts

class XAxisDateFormatter: NSObject {
    fileprivate var referenceTimeInterval: TimeInterval?
    fileprivate var dateFormatter: DateFormatter?

    init(referenceTimeInterval: TimeInterval, dateFormatter: DateFormatter) {
        self.referenceTimeInterval = referenceTimeInterval
        self.dateFormatter = dateFormatter
    }
}

extension XAxisDateFormatter: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let dateFormatter = dateFormatter,
        let referenceTimeInterval = referenceTimeInterval
        else {
            return ""
        }
        let date = Date(timeIntervalSince1970: value + referenceTimeInterval)
        let dateLabel = dateFormatter.string(from: date)
        
        return dateLabel
    }
}
