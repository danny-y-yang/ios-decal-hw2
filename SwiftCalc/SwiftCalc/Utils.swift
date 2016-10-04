//
//  Utils.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/21/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import Foundation

// MARK:  Define any general utilities here

class Helper {
    // MARK: Sample Helper Class
    /*
        Helper.log10(100.0)
        >> Double = 2
    */
    class func log10(x: Double) -> Double {
        return log(x)/log(10.0)
    }
    
    
    // Count of numbers displayed in text
    var numbersDisplayed = 0
    
    // Binary operations utilities
    var firstOperand = ""
    var secondOperand = ""
    var operatorSet = ""
    
    
    // Utilities for respecting order of operations
    var accumulated = ""
    var pendingOperator = ""
    
    // For scientific notation conversion
    func changeToScientific(x : Double) -> String {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .scientific
        return numFormatter.string(from: NSNumber(value: x))!
    }
    
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> String {
        print("Calculation requested for \(a) \(operation) \(b)")

        // No pending operations that need to be conducted
        if self.accumulated == "" {
            if operation == "+" {
                return String(a + b)
            } else if operation == "-" {
                return String(a - b)
            } else if operation == "*" {
                return String(a * b)
            } else if operation == "/" {
                
                // If two integers division results in a double, return a double
                if (Double(a)/Double(b)).truncatingRemainder(dividingBy: 1) != 0 {
                    return String(Double(a)/Double(b))
                }
                return String(a / b)
            }

        } else {
            let accumulated = Int(self.accumulated)!
            self.accumulated = ""
            let result = Int(self.intCalculate(a: a, b: b, operation: operation))!
            return self.intCalculate(a: accumulated, b: result, operation: self.pendingOperator)
        }
        return ""
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b:String, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        let a = Double(a)!
        let b = Double(b)!
        if operation == "+" {
            return a + b
        } else if operation == "-" {
            return a - b
        } else if operation == "*" {
            return a * b
        } else if operation == "/" {
            return a / b
        }

        return 0.0
    }

    
    
    
}
