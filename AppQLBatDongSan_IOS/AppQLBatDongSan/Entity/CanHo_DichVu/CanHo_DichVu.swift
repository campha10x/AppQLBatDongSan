//
//  CanHo_DichVu.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 12/2/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class CanHo_DichVu: BaseRealmObject, NSCopying {

        @objc dynamic var IdDichVu_CanHo: String = ""
        @objc dynamic var IdCanHo: String = ""
        @objc dynamic var IdDichVu: String = ""
    
        override static func primaryKey() -> String? {
            return "IdDichVu_CanHo"
        }
        
        convenience init(json: JSON ) {
            self.init()
            self.IdDichVu_CanHo = json["idDichVu_CanHo"].stringValue
            self.IdCanHo = json["idCanHo"].stringValue
            self.IdDichVu = json["idDichVu"].stringValue
        }
        
        
        func copy(with zone: NSZone? = nil) -> Any {
            let copy = CanHo_DichVu()
            copy.IdDichVu_CanHo = self.IdDichVu_CanHo
            copy.IdCanHo = self.IdCanHo
            copy.IdDichVu = self.IdDichVu
            return copy
        }

}
