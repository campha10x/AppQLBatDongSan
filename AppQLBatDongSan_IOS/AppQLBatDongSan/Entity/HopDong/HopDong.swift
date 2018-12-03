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
    @objc dynamic var idHopDong: String = ""
    @objc dynamic var ChuHopDong: String = ""
    @objc dynamic var IdCanHo: String = ""
    @objc dynamic var SoTienCoc: String = ""
    @objc dynamic var NgayBD: String = ""
    @objc dynamic var NgayKT: String = ""
    @objc dynamic var GhiChu: String = ""
    @objc dynamic var IdKhachHang: String = ""
    @objc dynamic var idDichVu: String = ""
    override static func primaryKey() -> String? {
        return "idHopDong"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.idHopDong = json["idHopDong"].stringValue
        self.ChuHopDong = json["chuHopDong"].stringValue
        self.IdCanHo = json["idCanHo"].stringValue
        self.SoTienCoc = json["soTienCoc"].stringValue
        self.NgayBD = json["ngayBD"].stringValue
        self.NgayKT = json["ngayKT"].stringValue
        self.GhiChu = json["ghiChu"].stringValue
        self.IdKhachHang = json["idKhachHang"].stringValue
        self.idDichVu = json["idDichVu"].stringValue
    }

    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = HopDong()
        copy.idHopDong = self.idHopDong
        copy.ChuHopDong = self.ChuHopDong
        copy.IdCanHo = self.IdCanHo
        copy.SoTienCoc = self.SoTienCoc
        copy.NgayBD = self.NgayBD
        copy.NgayKT = self.NgayKT
        copy.GhiChu = self.GhiChu
        copy.IdKhachHang = self.IdKhachHang
        return copy
    }
    
}
