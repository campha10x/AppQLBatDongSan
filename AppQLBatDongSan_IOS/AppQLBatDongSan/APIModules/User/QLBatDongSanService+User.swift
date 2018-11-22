//
//  QLBatDongSanService+User.swift
//  AppQLBatDongSan
//
//  Created by User on 9/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension QLBatDongSanService {
    /**
     Calls the Login Web Service to authenticate the user
     */
    public func login(username:String, password: String,completionHandler: @escaping CompletionHandler){
        self.completions[key.login] = completionHandler
        // Handle Authentication challenge
        
        let delegate: Alamofire.SessionDelegate = QLBatDongSanService.Manager.delegate
        delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = QLBatDongSanService.Manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
        
        QLBatDongSanService.Manager.request("https://localhost:5001/Account/Index/\(username)/\(password)", method: .get, parameters: [:], encoding: JSONEncoding(options: [])).responseJSON { response in
            do {
                let json: JSON = try JSON.init(data: response.data! )
                self.completions[key.login]!(json, nil)
            } catch {
                self.completions[key.login]!(nil, response.error)
            }

        }
    }
}
