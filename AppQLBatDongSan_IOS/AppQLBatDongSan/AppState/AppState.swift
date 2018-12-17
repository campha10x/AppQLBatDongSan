//
//  AppState.swift
//  AppQLBatDongSan
//
//  Created by User on 9/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import RealmSwift
class AppState  {
    
    static let shared =  AppState()
    var account: String? {
        return getAccount()
    }
    
    var typeLogin: Int {
        return UserDefaults.standard.integer(forKey: "TypeLogin")
    }
    
    func getAccount()-> String?  {
        if let email = UserDefaults.standard.string(forKey: "email") {
            return email
        }
        return nil
        
    }
    
    var khachHangObject: KhachHang? {
        let listkhachHang = Storage.shared.getObjects(type: KhachHang.self) as! [KhachHang]
        return listkhachHang.filter({$0.Email == account }).first
    }
    
    func saveAccount(account: Account?, typeLogin: TypeLogin?) {
        if let getAccount = account {
            UserDefaults.standard.set(typeLogin?.rawValue, forKey: "TypeLogin")
            Storage.shared.addOrUpdate([getAccount], type: Account.self)
            UserDefaults.standard.set(getAccount.email, forKey: "email")
        } else {
             UserDefaults.standard.set(nil, forKey: "TypeLogin")
            UserDefaults.standard.set(nil, forKey: "email")
        }
    }
    
    func saveKhachHang(khachHang: KhachHang?, typeLogin: TypeLogin?) {
        if let getkhachHang = khachHang {
            UserDefaults.standard.set(typeLogin?.rawValue, forKey: "TypeLogin")
            Storage.shared.addOrUpdate([getkhachHang], type: KhachHang.self)
            UserDefaults.standard.set(getkhachHang.Email, forKey: "email")
        } else {
            UserDefaults.standard.set(nil, forKey: "TypeLogin")
            UserDefaults.standard.set(nil, forKey: "email")
        }
    }
}
