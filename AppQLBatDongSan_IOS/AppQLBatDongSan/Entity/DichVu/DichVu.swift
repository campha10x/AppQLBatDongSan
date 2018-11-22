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
    @objc dynamic var idDonvi: String = ""
    @objc dynamic var MacDinh: String = ""
    
    override static func primaryKey() -> String? {
        return "idDichVu"
    }
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(HopDong.self).sorted(byKeyPath: "idDichVu").first?.idHopDong, let value = Int(retNext)  {
            return value + 1
        }else{
            return 1
        }
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.idDichVu = json["idDichVu"].stringValue
        self.TenDichVu = json["tenDichVu"].stringValue
        self.DonGia = json["donGia"].stringValue
         self.idDonvi = json["idDonvi"].stringValue
         self.MacDinh = json["macDinh"].stringValue
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = DichVu()
        copy.idDichVu = self.idDichVu
        copy.TenDichVu = self.TenDichVu
        copy.DonGia = self.DonGia
        copy.idDonvi = self.idDonvi
         copy.MacDinh = self.MacDinh
        return copy
    }
    
}
