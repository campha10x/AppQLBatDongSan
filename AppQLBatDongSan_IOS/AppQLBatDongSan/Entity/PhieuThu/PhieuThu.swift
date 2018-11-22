//
//  PhieuThu.swift
//  AppQLBatDongSan
//
//  Created by User on 10/8/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class PhieuThu: BaseRealmObject, NSCopying {
    @objc dynamic var IdPhieuThu: String = ""
    @objc dynamic var IdPhong: String = ""
    @objc dynamic var IdHoaDon: String = ""
    @objc dynamic var SoTien: String = ""
    @objc dynamic var Ngay: String = ""
    @objc dynamic var GhiChu: String = ""
    
    override static func primaryKey() -> String? {
        return "IdPhieuThu"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.IdPhieuThu = json["idPhieuThu"].stringValue
        self.IdPhong = json["idPhong"].stringValue
        self.IdHoaDon = json["idHoaDon"].stringValue
        self.SoTien = json["sotien"].stringValue
        self.Ngay = json["ngay"].stringValue
        self.GhiChu = json["ghiChu"].stringValue
        
    }
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(PhieuThu.self).sorted(byKeyPath: "IdPhieuThu").last?.IdPhieuThu, let value = Int(retNext)  {
            return value + 1
        }else{
            return 1
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = PhieuThu()
        copy.IdPhieuThu = self.IdPhieuThu
        copy.IdPhong = self.IdPhong
        copy.IdHoaDon = self.IdHoaDon
        copy.SoTien = self.SoTien
        copy.Ngay = self.Ngay
        copy.GhiChu = self.GhiChu
        return copy
    }
    
}