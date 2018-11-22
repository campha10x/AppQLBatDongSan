//
//  QLBatDongSanService+PhieuChi.swift
//  AppQLBatDongSan
//
//  Created by User on 10/15/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension QLBatDongSanService {
    public func loadListPhieuChi(completionHandler: @escaping CompletionHandler){
        self.completions[key.loadPhieuChi] = completionHandler
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
        
        QLBatDongSanService.Manager.request("https://localhost:5001/PhieuChi/GetListPhieuChi", method: .get, parameters: [:], encoding: JSONEncoding(options: [])).responseJSON { response in
            do {
                let json: JSON = try JSON.init(data: response.data! )
                self.completions[key.loadPhieuChi]!(json, nil)
            } catch {
                self.completions[key.loadPhieuChi]!(nil, response.error)
            }
               self.completions[key.loadPhieuChi] = nil
        }
    }
    
    
    public func removePhieuChi(parameters: [String: String] ,completionHandler: @escaping CompletionHandler){
        self.completions[key.removePhieuChi] = completionHandler
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
        QLBatDongSanService.Manager.request("https://localhost:5001/PhieuChi/RemoveListPhieuChi", method: .post, parameters: nil, encoding: JSONEncoding(options: []), headers: parameters).responseJSON { response in
            do {
                let json: JSON = try JSON.init(data: response.data! )
                self.completions[key.removePhieuChi]!(json, nil)
            } catch {
                self.completions[key.removePhieuChi]!(nil, response.error)
            }
            
        }
    }
    
    public func editPhieuChi(parameters: [String: String] ,completionHandler: @escaping CompletionHandler){
        self.completions[key.editPhieuChi] = completionHandler
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
        QLBatDongSanService.Manager.request("https://localhost:5001/PhieuChi/EditPhieuChi", method: .post, parameters: nil, encoding: JSONEncoding(options: []), headers: parameters).responseJSON { response in
            do {
                let json: JSON = try JSON.init(data: response.data! )
                self.completions[key.editPhieuChi]!(json, nil)
            } catch {
                self.completions[key.editPhieuChi]!(nil, response.error)
            }
            
        }
    }
    
}
