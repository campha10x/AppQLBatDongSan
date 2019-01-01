//
//  ChiTietHoaDon.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 12/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class ChiTietHoaDon: BaseRealmObject, NSCopying {

    @objc dynamic var Id_CTHD: String = ""
    @objc dynamic var Id_HoaDon: String = ""
    @objc dynamic var TenDichVu: String = ""
    @objc dynamic var SoCu: String = ""
    @objc dynamic var SoMoi: String = ""
    @objc dynamic var DonGia: String = ""
    
    var thanhTien: Double {
        get {
            let value = (Double(DonGia) ?? 0) *  (((Double(SoMoi) ?? 0)) - ((Double(SoCu) ?? 0)))
            return SoCu.isEmpty ? (Double(DonGia) ?? 0) : value
        }
    }
    
    override static func primaryKey() -> String? {
        return "Id_CTHD"
    }
    

    convenience init(json: JSON ) {
        self.init()
        self.Id_CTHD = json["id_CTHD"].stringValue
        self.Id_HoaDon = json["id_HoaDon"].stringValue
        self.TenDichVu = json["tenDichVu"].stringValue
        self.SoCu = json["soCu"].stringValue
        self.SoMoi = json["soMoi"].stringValue
        self.DonGia = json["donGia"].stringValue
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = ChiTietHoaDon()
        copy.Id_CTHD = self.Id_CTHD
        copy.Id_HoaDon = self.Id_HoaDon
        copy.TenDichVu = self.TenDichVu
        copy.SoCu = self.SoCu
        copy.SoMoi = self.SoMoi
        copy.DonGia = self.DonGia
        return copy
    }
    
    func toDics() -> [String: String] {
        return ["Id_CTHD": Id_CTHD,
                "Id_HoaDon": Id_HoaDon,
                "TenDichVu": TenDichVu,
                "SoCu": SoCu,
                "SoMoi": SoMoi,
                "DonGia": DonGia
        ]
    }
}
