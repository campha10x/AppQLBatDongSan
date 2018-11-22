//
//  DonVi.swift
//  AppQLBatDongSan
//
//  Created by User on 10/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class DonVi: BaseRealmObject, NSCopying {
    @objc dynamic var idDonVi: String = ""
    @objc dynamic var TenDonVi: String = ""
    @objc dynamic var GhiChu: String = ""
    
    override static func primaryKey() -> String? {
        return "idDonVi"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.idDonVi = json["idDonVi"].stringValue
        self.TenDonVi = json["tenDonVi"].stringValue
        self.GhiChu = json["ghiChu"].stringValue
        
    }
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(DonVi.self).sorted(byKeyPath: "idDonVi").first?.idDonVi, let value = Int(retNext)  {
            return value + 1
        }else{
            return 1
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = DonVi()
        copy.idDonVi = self.idDonVi
        copy.TenDonVi = self.TenDonVi
        copy.GhiChu = self.GhiChu
        return copy
    }
    
}
