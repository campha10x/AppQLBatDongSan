//
//  AppState.swift
//  AppQLBatDongSan
//
//  Created by User on 9/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

class AppState  {
    
    static let shared =  AppState()
    var account: String? {
        return getAccount()
    }
    
    
    func getAccount()-> String?  {
//        if let decoded  = UserDefaults.standard.object(forKey: "account") as? Data ,  let code_login = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? Account {
//            return code_login
//        }
//        return nil
        
//        if let accounts: [Account]  = Storage.shared.getObjects(type: Account.self) as! [Account] {
//            for item in accounts {
//
//            }
//            return code_login
//        }
        if let email = UserDefaults.standard.string(forKey: "email") {
            return email
        }
        return nil
        
    }
    
    func saveAccount(account: Account) {
            UserDefaults.standard.set(account.email, forKey: "email")
//        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: account)
//        UserDefaults.standard.set(encodedData, forKey: "account")
//        UserDefaults.standard.synchronize()
    }
    
}
