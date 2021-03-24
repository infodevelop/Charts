//
//  LinearFunctionGraph.swift
//  Charts
//
//  Created by Heo on 2021/03/22.
//

import Foundation

public class LinearFunctionGraph {
    
    private var slope = Double(0.0)
    private var yIntercept = Double(0.0)
    
    public func set(xStart: Double, yStart: Double, xEnd: Double, yEnd: Double) {
        
        let xIncrease = xEnd - xStart
        let yIncrease = yEnd - yStart
        
        if xIncrease == 0 || yIncrease == 0 {
            slope = 0
        } else {
            slope = yIncrease / xIncrease
        }
        
        yIntercept = -slope * xStart + yStart
    }
    
    public func getY(x: Double) -> Double {
        let y = slope * x + yIntercept
        return Double(y)
    }
    
}

public func happy() {
    print("happy")
}
