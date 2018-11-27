//
//  Account.swift
//  AppQLBatDongSan
//
//  Created by User on 9/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SwiftyJSON

class Account:  BaseRealmObject, NSCopying {
    
    @objc dynamic var IdAccount: String = "0"
    @objc dynamic var email: String = ""
    @objc dynamic var matKhau: String = ""
    @objc dynamic var hoten: String = ""
    @objc dynamic var gioitinh: String = "1" // Nam
    @objc dynamic var namSinh: String = ""
    @objc dynamic var sdt: String = ""
    @objc dynamic var diaChi: String = ""
    @objc dynamic var anhDaiDien: String = ""
    
    override static func primaryKey() -> String? {
        return "IdAccount"
    }
    

    
    convenience init(json: JSON ) {
        self.init()
        self.IdAccount = json["idAccount"].stringValue
        self.email = json["email"].stringValue
        self.matKhau = json["matKhau"].stringValue
        self.hoten = json["hoten"].stringValue
        self.gioitinh = json["gioitinh"].stringValue
        self.namSinh = json["namSinh"].stringValue
        self.sdt = json["sdt"].stringValue
        self.diaChi = json["diaChi"].stringValue
        self.anhDaiDien = json["anhDaiDien"].stringValue
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(IdAccount, forKey: "IdAccount")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(matKhau, forKey: "matKhau")
        aCoder.encode(hoten, forKey: "hoten")
        aCoder.encode(gioitinh, forKey: "gioitinh")
        aCoder.encode(namSinh, forKey: "namSinh")
        aCoder.encode(sdt, forKey: "sdt")
        aCoder.encode(diaChi, forKey: "diaChi")
        aCoder.encode(anhDaiDien, forKey: "anhDaiDien")
    }
    

    
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Account()
        copy.IdAccount = self.IdAccount
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
