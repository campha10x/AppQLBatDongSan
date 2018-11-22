//
//  LoginInteracter.swift
//  AppQLBatDongSan
//
//  Created by User on 9/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LoginInteractor: LoginInteractorProtocol {
    var presenter: LoginPresenterProtocol?

    
    func login(username email: String, password: String) {
//        SVProgressHUD.show()
//        QLBatDongSanService.shared.login(username: email, password: password) { (json, error) in
//            if let json = json {
//                let account  = Account.init(json: json)
//
//                AppState.shared.saveAccount(account: account)
//                self.presenter?.loginSuccess()
//            } else if let error = error {
//                self.presenter?.loginFail(error: error)
//            }
//            SVProgressHUD.dismiss()
//        }
        
        
        let listUser: [Account] = Storage.shared.getObjects(type: Account.self) as! [Account]
        for user in listUser {
            if user.email == email && user.matKhau == password {
                AppState.shared.saveAccount(account: user)
                self.presenter?.loginSuccess()
            } else {
                self.presenter?.loginFail(error: "")
            }
        }
        
    }
    
    open func createSessionManager() -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["localhost": .disableEvaluation]
        
        return Alamofire.SessionManager(configuration: configuration, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }
}
