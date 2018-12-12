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
    @objc dynamic  var IdCanHo: String = ""
    @objc dynamic  var soPhieu: String = ""
    @objc dynamic  var ngayTao: String = ""
    @objc dynamic  var soTien: String = ""
    @objc dynamic  var daTra: String = ""
    @objc dynamic var soDienMoi: String = ""
    @objc dynamic var soNuocMoi: String = ""
     @objc dynamic var idPhieuThu: String = ""
    
    override static func primaryKey() -> String? {
        return "idHoaDon"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.idHoaDon = json["idHoaDon"].stringValue
        self.IdCanHo = json["idCanHo"].stringValue
        self.soPhieu = json["soPhieu"].stringValue
        self.ngayTao = json["ngayTao"].stringValue
        self.soTien = json["soTien"].stringValue
        self.daTra = json["daTra"].stringValue
        self.soDienMoi = json["soDienMoi"].stringValue
        self.soNuocMoi = json["soNuocMoi"].stringValue
          self.idPhieuThu = json["idPhieuThu"].stringValue
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = HoaDon()
        copy.idHoaDon = self.idHoaDon
        copy.IdCanHo  = self.IdCanHo
        copy.soPhieu  = self.soPhieu
        copy.ngayTao  = self.ngayTao
        copy.soTien  = self.soTien
        copy.daTra  = self.daTra
        copy.soDienMoi = self.soDienMoi
        copy.soNuocMoi = self.soNuocMoi
        copy.idPhieuThu = self.idPhieuThu 
        return copy
    }
}
