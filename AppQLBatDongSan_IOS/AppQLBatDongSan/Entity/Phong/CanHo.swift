//
//  Phong.swift
//  AppQLBatDongSan
//
//  Created by User on 10/3/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class CanHo: BaseRealmObject, NSCopying {
    
    @objc dynamic var IdCanHo: String = ""
    @objc dynamic  var TenCanHo: String = ""
    @objc dynamic  var DonGia: String = ""
    @objc dynamic  var SoDienCu: String = ""
    @objc dynamic  var SoNuocCu: String = ""
    @objc dynamic var DienTich: String = ""
    @objc dynamic var DiaChi: String = ""
    
    override static func primaryKey() -> String? {
        return "IdCanHo"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.IdCanHo = json["idCanHo"].stringValue
        self.TenCanHo = json["tenCanHo"].stringValue
        self.DonGia = json["donGia"].stringValue
        self.SoDienCu = json["soDienCu"].stringValue
        self.SoNuocCu = json["soNuocCu"].stringValue
        self.DienTich = json["dienTich"].stringValue
        self.DiaChi = json["diaChi"].stringValue
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = CanHo()
        copy.IdCanHo = self.IdCanHo
        copy.TenCanHo  = self.TenCanHo
        copy.DonGia =  self.DonGia
        copy.SoDienCu  = self.SoDienCu
        copy.SoNuocCu  = self.SoNuocCu
        copy.DienTich = self.DienTich
         copy.DiaChi = self.DiaChi
        return copy
    }
}
