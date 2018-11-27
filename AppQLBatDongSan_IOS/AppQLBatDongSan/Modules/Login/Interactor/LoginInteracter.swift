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
    let manager = Alamofire.SessionManager()
    
    func login(username email: String, password: String) {
        configService()
        SVProgressHUD.show() 
        manager.request("https://localhost:5001/Account/Index/\(email)/\(password)", method: .get, parameters: [:], encoding: JSONEncoding(options: [])).responseJSON { response in
            do {
                let json: JSON = try JSON.init(data: response.data! )
                let account  = Account.init(json: json)
                Storage.shared.addOrUpdate([account], type: Account.self)
                AppState.shared.saveAccount(account: account)
                self.presenter?.loginSuccess()
            } catch {
                self.presenter?.loginFail(error: error.localizedDescription)
            }
            SVProgressHUD.dismiss()
        }
    }

    func configService() {
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: (challenge.protectionSpace.serverTrust ?? nil)!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = self.manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            
            return (disposition, credential)
        }
    }
    
}
