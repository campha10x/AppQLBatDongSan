//
//  Double+Extension.swift
//  AppQLBatDongSan
//
//  Created by User on 10/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

extension Double {
    func formatNumber(format: String? = nil, type: MyNumberFieldFormat, isRemoveComma: Bool) -> String {
        let formatter = POSFormatter.number
        formatter.numberStyle = .decimal
        if isRemoveComma == false {
            formatter.groupingSeparator =  ","
            formatter.decimalSeparator =  "."
        } else {
            formatter.groupingSeparator =  ""
            formatter.decimalSeparator =  ""
        }
        formatter.minimumIntegerDigits =  1
        formatter.groupingSize =  3
        let stringFormat = "%@"
        if type == .decimal {
            formatter.maximumFractionDigits =  2
            formatter.minimumFractionDigits =  2
        }
        else if type == .integer || type == .money {
            formatter.maximumFractionDigits = 0
            formatter.minimumFractionDigits = 0
        }
        let abs = fabs(self)
        let string = formatter.string(from: NSNumber(value: abs)) ?? ""
        let result = String(format: stringFormat, string)
        return self >= 0 ? result : ("-" + result)
    }
        func toInt() -> Int? {
            if self > Double(Int.min) && self < Double(Int.max) {
                return Int(self)
            } else {
                return nil
            }
        }
}

