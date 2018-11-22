//
//  Account.swift
//  AppQLBatDongSan
//
//  Created by User on 9/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON

class Account:  BaseRealmObject {
    
    @objc dynamic var idNhaTro: Int = 0
    @objc dynamic var email: String = ""
    @objc dynamic var matKhau: String = ""
    @objc dynamic var hoten: String = ""
    @objc dynamic var gioitinh: Bool = false
    @objc dynamic var namSinh: Int = 0
    @objc dynamic var sdt: String = ""
    @objc dynamic var diaChi: String = ""
    @objc dynamic var anhDaiDien: String = ""
    @objc dynamic var idUserName: String = ""
    
    override static func primaryKey() -> String? {
        return "idUserName"
    }
    

    
    convenience init(json: JSON ) {
        self.init()
        self.idNhaTro = json["idNhaTro"].intValue
        self.email = json["email"].stringValue
        self.matKhau = json["matKhau"].stringValue
        self.hoten = json["hoten"].stringValue
        self.gioitinh = json["gioitinh"].boolValue
        self.namSinh = json["namSinh"].intValue
        self.sdt = json["sdt"].stringValue
        self.diaChi = json["diaChi"].stringValue
        self.anhDaiDien = json["anhDaiDien"].stringValue
        self.idUserName = json["idUserName"].stringValue
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(idNhaTro, forKey: "idNhaTro")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(matKhau, forKey: "matKhau")
        aCoder.encode(hoten, forKey: "hoten")
        aCoder.encode(gioitinh, forKey: "gioitinh")
        aCoder.encode(namSinh, forKey: "namSinh")
        aCoder.encode(sdt, forKey: "sdt")
        aCoder.encode(diaChi, forKey: "diaChi")
        aCoder.encode(anhDaiDien, forKey: "anhDaiDien")
         aCoder.encode(idUserName, forKey: "idUserName")
    }
    

    
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Account()
        copy.idNhaTro = self.idNhaTro
        copy.matKhau  = self.matKhau
        copy.hoten  = self.hoten
        copy.gioitinh  = self.gioitinh
        copy.namSinh  = self.namSinh
        copy.sdt  = self.sdt
        copy.diaChi = self.diaChi
        copy.anhDaiDien = self.anhDaiDien
        return copy
    }
    

    
}
