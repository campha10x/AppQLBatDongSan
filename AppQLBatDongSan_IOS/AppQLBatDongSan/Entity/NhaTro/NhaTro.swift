//
//  NhaTro.swift
//  AppQLBatDongSan
//
//  Created by User on 10/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class NhaTro: BaseRealmObject, NSCopying {
    
    @objc dynamic var idNhaTro: String = ""
    @objc dynamic  var tenNhaTro: String = ""
    @objc dynamic  var ghiChu: String = ""
    
    
    override static func primaryKey() -> String? {
        return "idNhaTro"
    }
    
    convenience init(json: JSON ) {
        self.init()
        self.idNhaTro = json["idNhaTro"].stringValue
        self.tenNhaTro = json["tenNhaTro"].stringValue
        self.ghiChu = json["ghiChu"].stringValue
        
    }
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(NhaTro.self).sorted(byKeyPath: "idNhaTro").last?.idNhaTro, let value = Int(retNext)  {
            return value + 1
        }else{
            return 1
        }
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = NhaTro()
        copy.idNhaTro = self.idNhaTro
        copy.tenNhaTro  = self.tenNhaTro
        copy.ghiChu  = self.ghiChu
        return copy
    }
}
