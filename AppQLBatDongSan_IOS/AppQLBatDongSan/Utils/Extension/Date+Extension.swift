//
//  Date+Extension.swift
//  AppQLBatDongSan
//
//  Created by User on 10/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

import UIKit
import SwiftyJSON
extension Date {
    
    var day:Int {return Calendar.current.component(.day, from:self)}
    var month:Int {return Calendar.current.component(.month, from:self)}
    var year:Int {return Calendar.current.component(.year, from:self)}
    
    func toString(format: String) -> String? {
        let formatter = POSFormatter.date
        formatter.calendar = Calendar.current
        formatter.dateFormat = format
        let tmp = formatter.string(from: self)
        if tmp.contains("%@") {
            let day = Calendar.current.component(.day, from: self)
            var ext = "th"
            if day == 1 { ext = "st" }
            else if day == 2 { ext = "nd"}
            else if day == 3 { ext = "rd"}
            return String(format: tmp, ext)
        }
        return tmp
    }
    
//    func toStringWithStoreTimeZone(format: String) -> String? {
//        let formatter = DateFormatter()
//        if let magentoSetting = (Storage.shared.getObjects(type: MagentoSetting.self) as! [MagentoSetting]).first, let store = magentoSetting.store {
//            let temp = JSON.init(parseJSON: store)
//            let secondsFromGMT = temp["time_zone"].intValue
//            let currentGMT = TimeZone.current.secondsFromGMT()
//            if secondsFromGMT < 0 {
//                formatter.timeZone = TimeZone.init(secondsFromGMT: currentGMT + abs(secondsFromGMT))
//            }else {
//                formatter.timeZone = TimeZone.init(secondsFromGMT: currentGMT - abs(secondsFromGMT))
//            }
//        }
//        formatter.dateFormat = format
//        return formatter.string(from: self)
//    }
    
    func toDate(format:String, value:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return dateFormatter.date(from: value)
    }
    
    func dayOnly() -> Date? {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
