//
//  PhieuChi.swift
//  AppQLBatDongSan
//
//  Created by User on 10/15/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift
class PhieuChi: BaseRealmObject, NSCopying {
    @objc dynamic var IdPhieuChi: String = ""
    @objc dynamic var IdCanHo: String = ""
    @objc dynamic var Sotien: String = ""
    @objc dynamic var Ngay: String = ""
    @objc dynamic var DienGiai: String = ""
    
    override static func primaryKey() -> String? {
        return "IdPhieuChi"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.IdPhieuChi = json["idPhieuChi"].stringValue
        self.IdCanHo = json["idCanHo"].stringValue
        self.Sotien = json["sotien"].stringValue
        self.Ngay = json["ngay"].stringValue
        self.DienGiai = json["dienGiai"].stringValue
        
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = PhieuChi()
        copy.IdPhieuChi = self.IdPhieuChi
        copy.IdCanHo = self.IdCanHo
        copy.Sotien = self.Sotien
        copy.Ngay = self.Ngay
        copy.DienGiai = self.DienGiai
        return copy
    }
    
}

