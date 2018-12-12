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
    @objc dynamic  var DonGia: String = ""
    @objc dynamic var DienTich: String = ""
    @objc dynamic var DiaChi: String = ""
     @objc dynamic var TieuDe: String = ""
     @objc dynamic var MoTa: String = ""
     @objc dynamic var AnhCanHo: String = ""
      @objc dynamic var NgayTao: String = ""
    
    
    var maCanHo: String {
        return "CT \(IdCanHo)"
    }
    override static func primaryKey() -> String? {
        return "IdCanHo"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["maCanHo"]
    }
    convenience init(json: JSON ) {
        self.init()
        self.IdCanHo = json["idCanHo"].stringValue
        self.DonGia = json["donGia"].stringValue
        self.DienTich = json["dienTich"].stringValue
        self.DiaChi = json["diaChi"].stringValue
        self.TieuDe = json["tieuDe"].stringValue
        self.MoTa = json["moTa"].stringValue
        self.AnhCanHo = json["anhCanHo"].stringValue
        self.NgayTao = json["ngayTao"].stringValue
        
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = CanHo()
        copy.IdCanHo = self.IdCanHo
        copy.DonGia =  self.DonGia
        copy.DienTich = self.DienTich
         copy.DiaChi = self.DiaChi
        copy.TieuDe = self.TieuDe
        copy.MoTa = self.MoTa
        copy.AnhCanHo = self.AnhCanHo
        copy.NgayTao = self.NgayTao
        return copy
    }
}
