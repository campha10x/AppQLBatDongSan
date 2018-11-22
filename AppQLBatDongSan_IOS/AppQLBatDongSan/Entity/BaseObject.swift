//
//  BaseObject.swift
//  ConnectPOS
//
//  Created by User on 12/23/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

protocol BaseObject {
}

// Trait - Swift 2.0 or more
extension BaseObject {
    
    func toDictionary() -> [String : Any] {
        var dictionary = [String:Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label {
                if let temp = child.value as? List<String>  {
                    dictionary[key] = temp.count > 0 ? temp.reduce([String](), {$0 + [$1]}) : [String]()
                }
                else if let temp = child.value as? List<Double>  {
                    dictionary[key] =  temp.reduce([Double](), {$0 + [$1]})
                }
                else if let temp = child.value as? List<Int>  {
                    dictionary[key] =  temp.reduce([Int](), {$0 + [$1]})
                }
//                else if let temp = child.value as? List<Register>  {
//                    let array = temp.map({$0.toDictionary()})
//                    dictionary[key] = JSON(array).rawString() ?? ""
                else if let temp = child.value as? [BaseObject] {
                    let json = JSON(temp.map({$0.toDictionary()})).rawString() ?? ""
                    dictionary[key] = json
                }
                else if let tmp = child.value as? BaseObject {
                    dictionary[key] = JSON(tmp.toDictionary()).rawString() ?? ""
                }
                else {
                    dictionary[key] = child.value
                }
            }
        }
        return dictionary
    }
    
}
