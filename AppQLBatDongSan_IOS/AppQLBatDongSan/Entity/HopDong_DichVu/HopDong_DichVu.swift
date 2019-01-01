//
//  HopDong_DichVu.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 12/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class HopDong_DichVu: BaseRealmObject, NSCopying {
    
    @objc dynamic var IdHopDong: String = ""
    @objc dynamic var IdDichVu: String = ""
    @objc dynamic var DonGia: String = ""
    @objc dynamic var IdHopDong_DichVu: String = ""
    
    override static func primaryKey() -> String? {
        return "IdHopDong_DichVu"
    }
    convenience init(json: JSON ) {
        self.init()
        self.IdHopDong = json["idHopDong"].stringValue
        self.IdDichVu = json["idDichVu"].stringValue
        self.DonGia = json["donGia"].stringValue
        self.IdHopDong_DichVu = json["idHopDong_DichVu"].stringValue
    }
    
    func toDics() -> [String: String] {
        return ["IdHopDong": IdHopDong,
                "IdDichVu" : IdDichVu,
                "DonGia": DonGia]
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = HopDong_DichVu()
        copy.IdHopDong = self.IdHopDong
        copy.IdDichVu = self.IdDichVu
        copy.DonGia = self.DonGia
        copy.IdHopDong_DichVu = self.IdHopDong_DichVu
        return copy
    }
    
}
