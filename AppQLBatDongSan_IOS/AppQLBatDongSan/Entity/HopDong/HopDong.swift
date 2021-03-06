//
//  HopDong.swift
//  AppQLBatDongSan
//
//  Created by User on 11/3/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class HopDong: BaseRealmObject, NSCopying {
    @objc dynamic var IdHopDong: String = ""
    @objc dynamic var IdChuCanHo: String = ""
    @objc dynamic var IdCanHo: String = ""
    @objc dynamic var SoTienCoc: String = ""
    @objc dynamic var NgayBD: String = ""
    @objc dynamic var NgayKT: String = ""
    @objc dynamic var GhiChu: String = ""
    @objc dynamic var IdKhachHang: String = ""
    @objc dynamic var TienDien: String = ""
    @objc dynamic var TienNuoc: String = ""
    @objc dynamic var SoDienBd: String = ""
    @objc dynamic var SoNuocBd: String = ""
    
    var active: Bool {
        get {
            let month = returnMonth(ngayTao: self.NgayKT)
            let year = returnYear(ngayTao: self.NgayKT)
            let monthNow = Calendar.current.component(.month, from: Date())
            let yearNow = Calendar.current.component(.year, from: Date())
            if (month < monthNow && year == yearNow || year < yearNow ){
                return false
            } else {
                return true
            }
        }

    }
    
    func returnMonth(ngayTao: String) -> Int {
        if let ngayTaoConvert = ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") {
            return Calendar.current.component(.month, from: ngayTaoConvert)
        } else {
            return 0
        }
        
    }
    
    func returnYear(ngayTao: String) -> Int {
        if let ngayTaoConvert = ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") {
            return Calendar.current.component(.year, from: ngayTaoConvert)
        } else {
            return 0
        }
        
    }
    
    var maHopDong: String {
        let id = (Int(IdHopDong) ?? 0) + 9444001
        return "HD-\(id)"
    }
    
    override static func primaryKey() -> String? {
        return "IdHopDong"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.IdHopDong = json["idHopDong"].stringValue
        self.IdChuCanHo = json["idChuCanHo"].stringValue
        self.IdCanHo = json["idCanHo"].stringValue
        self.SoTienCoc = json["soTienCoc"].stringValue
        self.NgayBD = json["ngayBD"].stringValue
        self.NgayKT = json["ngayKT"].stringValue
        self.GhiChu = json["ghiChu"].stringValue
        self.IdKhachHang = json["idKhachHang"].stringValue
        self.TienDien = json["tienDien"].stringValue
        self.TienNuoc = json["tienNuoc"].stringValue
        self.SoDienBd = json["soDienBd"].stringValue
        self.SoNuocBd = json["soNuocBd"].stringValue
    }

    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = HopDong()
        copy.IdHopDong = self.IdHopDong
        copy.IdChuCanHo = self.IdChuCanHo
        copy.IdCanHo = self.IdCanHo
        copy.SoTienCoc = self.SoTienCoc
        copy.NgayBD = self.NgayBD
        copy.NgayKT = self.NgayKT
        copy.GhiChu = self.GhiChu
        copy.IdKhachHang = self.IdKhachHang
        copy.TienDien = self.TienDien
        copy.TienNuoc = self.TienNuoc
        copy.SoDienBd = self.SoDienBd
        copy.SoNuocBd = self.SoNuocBd
        return copy
    }
    
}
