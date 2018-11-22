//
//  PhieuChi.swift
//  AppQLBatDongSan
//
//  Created by User on 10/15/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
class PhieuChi: BaseRealmObject, NSCopying {
    @objc dynamic var IdPhieuChi: String = ""
    @objc dynamic var IdPhong: String = ""
    @objc dynamic var Sotien: String = ""
    @objc dynamic var Ngay: String = ""
    @objc dynamic var DienGiai: String = ""
    
    override static func primaryKey() -> String? {
        return "IdPhieuChi"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.IdPhieuChi = json["idPhieuChi"].stringValue
        self.IdPhong = json["idPhong"].stringValue
        self.Sotien = json["sotien"].stringValue
        self.Ngay = json["ngay"].stringValue
        self.DienGiai = json["dienGiai"].stringValue
        
    }
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(PhieuChi.self).sorted(byKeyPath: "IdPhieuChi").last?.IdPhieuChi, let value = Int(retNext)  {
            return value + 1
        }else{
            return 1
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = PhieuChi()
        copy.IdPhieuChi = self.IdPhieuChi
        copy.IdPhong = self.IdPhong
        copy.Sotien = self.Sotien
        copy.Ngay = self.Ngay
        copy.DienGiai = self.DienGiai
        return copy
    }
    
}

