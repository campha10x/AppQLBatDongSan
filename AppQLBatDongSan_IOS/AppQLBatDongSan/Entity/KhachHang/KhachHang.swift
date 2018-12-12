//
//  KhachHang.swift
//  AppQLBatDongSan
//
//  Created by User on 10/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class KhachHang: BaseRealmObject, NSCopying {
    @objc dynamic var idKhachHang: String = ""
    @objc dynamic var TenKH: String = ""
    @objc dynamic var IdCanHo: String = ""
    @objc dynamic var NgaySinh: String = ""
    @objc dynamic var GioiTinh: String = ""
    @objc dynamic var SDT: String = ""
    @objc dynamic var Email: String = ""
    @objc dynamic var CMND: String = ""
    @objc dynamic var Quequan: String = ""
     @objc dynamic var NgayCap: String = ""
     @objc dynamic var NoiCap: String = ""
     @objc dynamic var DiaChi: String = ""
    
    override static func primaryKey() -> String? {
        return "idKhachHang"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.idKhachHang = json["idKhachHang"].stringValue
        self.IdCanHo = json["idCanHo"].stringValue
        self.TenKH = json["tenKH"].stringValue
        self.IdCanHo = json["idCanHo"].stringValue
        self.NgaySinh = json["ngaySinh"].stringValue
        self.GioiTinh = json["gioiTinh"].stringValue
        self.SDT = json["sdt"].stringValue
        self.Email = json["email"].stringValue
        self.CMND = json["cmnd"].stringValue
         self.Quequan = json["quequan"].stringValue
        self.NgayCap = json["ngayCap"].stringValue
        self.NoiCap = json["noiCap"].stringValue
    }
    
   
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = KhachHang()
        copy.idKhachHang = self.idKhachHang
        copy.IdCanHo = self.IdCanHo
        copy.TenKH = self.TenKH
        copy.NgaySinh = self.NgaySinh
        copy.GioiTinh = self.GioiTinh
        copy.SDT = self.SDT
        copy.Email = self.Email
        copy.CMND = self.CMND
        copy.Quequan = self.Quequan
         copy.NgayCap = self.NgayCap
         copy.NoiCap = self.NoiCap
        return copy
    }
    
}


