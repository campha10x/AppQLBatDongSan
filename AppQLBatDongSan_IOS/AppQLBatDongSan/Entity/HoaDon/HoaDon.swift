//
//  Account.swift
//  AppQLBatDongSan
//
//  Created by User on 9/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
class HoaDon: BaseRealmObject, NSCopying {
    
    @objc dynamic var idHoaDon: String = ""
    @objc dynamic  var idPhong: String = ""
    @objc dynamic  var soPhieu: String = ""
    @objc dynamic  var ngayTao: String = ""
    @objc dynamic  var soTien: String = ""
    @objc dynamic  var daTra: String = ""
    @objc dynamic var tenPhong: String = ""
    
    override static func primaryKey() -> String? {
        return "idHoaDon"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.idHoaDon = json["idHoaDon"].stringValue
        self.idPhong = json["idPhong"].stringValue
        self.soPhieu = json["soPhieu"].stringValue
        self.ngayTao = json["ngayTao"].stringValue
        self.soTien = json["soTien"].stringValue
        self.daTra = json["daTra"].stringValue
        self.tenPhong = json["tenPhong"].stringValue
    }
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(HoaDon.self).sorted(byKeyPath: "idHoaDon").last?.idHoaDon, let value = Int(retNext)  {
            return value + 1
        }else{
            return 1
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = HoaDon()
        copy.idHoaDon = self.idHoaDon
        copy.idPhong  = self.idPhong
        copy.soPhieu  = self.soPhieu
        copy.ngayTao  = self.ngayTao
        copy.soTien  = self.soTien
        copy.daTra  = self.daTra
        copy.tenPhong = self.tenPhong
        return copy
    }
}
