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
    @objc dynamic var idPhong: String = ""
    @objc dynamic var SoTienCoc: String = ""
    @objc dynamic var NgayBD: String = ""
    @objc dynamic var NgayKT: String = ""
    @objc dynamic var GhiChu: String = ""
    @objc dynamic var GioiTinh: String = ""
    @objc dynamic var idDichVu: String = ""
    @objc dynamic var SDTKhachHang: String = ""
    @objc dynamic var emailKhachHang: String = ""
    override static func primaryKey() -> String? {
        return "idHopDong"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.idHopDong = json["idHopDong"].stringValue
        self.ChuHopDong = json["chuHopDong"].stringValue
        self.idPhong = json["idPhong"].stringValue
        self.SoTienCoc = json["soTienCoc"].stringValue
        self.NgayBD = json["ngayBD"].stringValue
        self.NgayKT = json["ngayKT"].stringValue
        self.GhiChu = json["ghiChu"].stringValue
        self.GioiTinh = json["gioiTinh"].stringValue
        self.idDichVu = json["idDichVu"].stringValue
        self.SDTKhachHang = json["sdtKhachHang"].stringValue
        self.emailKhachHang = json["emailKhachHang"].stringValue
    }
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(HopDong.self).sorted(byKeyPath: "idHopDong").last?.idHopDong, let value = Int(retNext)  {
            return value + 1
        }else{
            return 1
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = HopDong()
        copy.idHopDong = self.idHopDong
        copy.ChuHopDong = self.ChuHopDong
        copy.idPhong = self.idPhong
        copy.SoTienCoc = self.SoTienCoc
        copy.NgayBD = self.NgayBD
        copy.NgayKT = self.NgayKT
        copy.GhiChu = self.GhiChu
        copy.GioiTinh = self.GioiTinh
        copy.SDTKhachHang = self.SDTKhachHang
        copy.emailKhachHang = self.emailKhachHang
        return copy
    }
    
}
