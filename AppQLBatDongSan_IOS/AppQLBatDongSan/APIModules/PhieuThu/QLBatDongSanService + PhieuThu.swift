//
//  PhieuThu.swift
//  AppQLBatDongSan
//
//  Created by User on 10/8/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension QLBatDongSanService {
    
    public func loadListPhieuThu(completionHandler: @escaping CompletionHandler){
        self.completions[key.loadPhieuThu] = completionHandler
        // Handle Authentication challenge
        
//        let delegate: Alamofire.SessionDelegate = QLBatDongSanService.Manager.delegate
//        delegate.sessionDidReceiveChallenge = { session, challenge in
//            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
//            var credential: URLCredential?
//            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
//                disposition = URLSession.AuthChallengeDisposition.useCredential
//                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
//            } else {
//                if challenge.previousFailureCount > 0 {
//                    disposition = .cancelAuthenticationChallenge
//                } else {
//                    credential = QLBatDongSanService.Manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
//                    if credential != nil {
//                        disposition = .useCredential
//                    }
//                }
//            }
//            return (disposition, credential)
//        }
        
        QLBatDongSanService.Manager.request("https://localhost:5001/HoaDon/GetListPhieuThu", method: .get, parameters: [:], encoding: JSONEncoding(options: [])).responseJSON { response in
            do {
                let json: JSON = try JSON.init(data: response.data! )
                self.completions[key.loadPhieuThu]!(json, nil)
            } catch {
                self.completions[key.loadPhieuThu]!(nil, response.error)
            }
            self.completions[key.loadPhieuThu] = nil
        }
    }
    
    
    public func removePhieuThu(parameters: [String: String] ,completionHandler: @escaping CompletionHandler){
        self.completions[key.removePhieuThu] = completionHandler
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
        QLBatDongSanService.Manager.request("https://localhost:5001/PhieuThu/RemoveListPhieuThu", method: .post, parameters: nil, encoding: JSONEncoding(options: []), headers: parameters).responseJSON { response in
            do {
                let json: JSON = try JSON.init(data: response.data! )
                self.completions[key.removePhieuThu]!(json, nil)
            } catch {
                self.completions[key.removePhieuThu]!(nil, response.error)
            }
            
        }
    }
    
    public func addPhieuThu(parameters: [String: String ],completionHandler: @escaping CompletionHandler){
        
        self.completions[key.addPhieuThu] = completionHandler
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
        
        QLBatDongSanService.Manager.request("https://localhost:5001/PhieuThu/AddPhieuThu", method: .post, parameters: nil, encoding: JSONEncoding(options: []), headers: parameters).responseJSON { response in
            do {
                let json: JSON = try JSON.init(data: response.data! )
                self.completions[key.addPhieuThu]!(json, nil)
            } catch {
                self.completions[key.addPhieuThu]!(nil, response.error)
            }
        }
        
    }
}
