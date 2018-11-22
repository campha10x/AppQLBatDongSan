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

class Phong: BaseRealmObject, NSCopying {
    
    @objc dynamic var idPhong: String = ""
    @objc dynamic  var tenPhong: String = ""
    @objc dynamic  var donGia: String = ""
    @objc dynamic  var soDien: String = ""
    @objc dynamic  var soNuoc: String = ""
    @objc dynamic var idNhaTro: String = ""
    
    override static func primaryKey() -> String? {
        return "idPhong"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.idPhong = json["idPhong"].stringValue
        self.tenPhong = json["tenPhong"].stringValue
        self.donGia = json["donGia"].stringValue
        self.soDien = json["soDien"].stringValue
        self.soNuoc = json["soNuoc"].stringValue
        self.idNhaTro = json["idNhaTro"].stringValue
        
    }
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(Phong.self).sorted(byKeyPath: "idPhong").last?.idPhong, let value = Int(retNext)  {
            return value + 1
        }else{
            return 1
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Phong()
        copy.idPhong = self.idPhong
        copy.tenPhong  = self.tenPhong
        copy.donGia  = self.donGia
        copy.soDien  = self.soDien
        copy.soNuoc  = self.soNuoc
        copy.idNhaTro = self.idNhaTro
        return copy
    }
}
