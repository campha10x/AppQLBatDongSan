//
//  DichVu.swift
//  AppQLBatDongSan
//
//  Created by User on 10/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class DichVu: BaseRealmObject, NSCopying {
    @objc dynamic var idDichVu: String = ""
    @objc dynamic var TenDichVu: String = ""
    @objc dynamic var DonGia: String = ""
    @objc dynamic var DonVi: String = ""
    
    override static func primaryKey() -> String? {
        return "idDichVu"
    }
    
    
    convenience init(json: JSON ) {
        self.init()
        self.idDichVu = json["idDichVu"].stringValue
        self.TenDichVu = json["tenDichVu"].stringValue
        self.DonGia = json["donGia"].stringValue
         self.DonVi = json["donVi"].stringValue
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = DichVu()
        copy.idDichVu = self.idDichVu
        copy.TenDichVu = self.TenDichVu
        copy.DonGia = self.DonGia
        copy.DonVi = self.DonVi
        return copy
    }
    
}
