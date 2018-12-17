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

        @objc dynamic var IdCanHo: String = ""
        @objc dynamic var IdDichVu: String = ""
    
        override static func primaryKey() -> String? {
            return "IdCanHo"
        }
        
        convenience init(json: JSON ) {
            self.init()
            self.IdCanHo = json["idCanHo"].stringValue
            self.IdDichVu = json["idDichVu"].stringValue
        }
        
        
        func copy(with zone: NSZone? = nil) -> Any {
            let copy = CanHo_DichVu()
            copy.IdCanHo = self.IdCanHo
            copy.IdDichVu = self.IdDichVu
            return copy
        }

}
