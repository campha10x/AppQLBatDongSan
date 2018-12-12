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
        if let email = UserDefaults.standard.string(forKey: "email") {
            return email
        }
        return nil
        
    }
    
    func saveAccount(account: Account?) {
        if let getAccount = account {
            Storage.shared.addOrUpdate([getAccount], type: Account.self)
            UserDefaults.standard.set(getAccount.email, forKey: "email")
        } else {
            UserDefaults.standard.set(nil, forKey: "email")
        }
    }
    
}
