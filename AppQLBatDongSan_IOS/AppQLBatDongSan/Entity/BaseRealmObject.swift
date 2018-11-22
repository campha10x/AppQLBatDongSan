//
//  BaseObject.swift
//  ConnectPOS
//
//  Created by HarryNg on 10/10/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import SwiftyJSON

public class BaseRealmObject: Object, BaseObject, Codable {
    
    // Delete
    func delete(realm: Realm){
        realm.delete(self)
    }
    
    // MARK: - Check object with ID
    // Check exist id in Realm
    func isEqualId(_ object: Any?) -> Bool {
        guard let obj = object as? BaseRealmObject, obj.getObjectId == self.getObjectId else {return false}
        return true
    }
    
    // Implement get object id
    public var getObjectId : String {
//        if let item = self as? Product {
//            return item.id
//        }
//        if let item = self as? Customer {
//            return item.id
//        }
//        if let item = self as? Category {
//            return item.id
//        }
//        if let item = self as? Order {
//            return item.order_id
//        }
//        if let item = self as? Shift {
//            return item.id
//        }
//        if let item = self as? CardPayment {
//            return item.id
//        }
//        if let item = self as? Outlet {
//            return item.id
//        }
//        if let item = self as? Register {
//            return item.id
//        }
//        if let item = self as? Region {
//            return item.region_id
//        }
//        if let item = self as? Country {
//            return item.id
//        }
//        if let item = self as? Receipt {
//            return item.id
//        }
//        if let item = self as? Store {
//            return item.id
//        }
        // Auto detect Id property
        let mirror = Mirror(reflecting: self)
        return (mirror.children.first(where: {$0.label == "id"})?.value as? String) ?? ""
    }
    
}



