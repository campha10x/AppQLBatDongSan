//
//  QLBatDongSanService+KhachHang.swift
//  AppQLBatDongSan
//
//  Created by User on 10/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension QLBatDongSanService {
    public func loadListKhachHang(completionHandler: @escaping CompletionHandler){
        self.completions[key.loadKhachHang] = completionHandler
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
        
        QLBatDongSanService.Manager.request("https://localhost:5001/KhachHang/GetListKhachHang", method: .get, parameters: [:], encoding: JSONEncoding(options: [])).responseJSON { response in
            do {
                let json: JSON = try JSON.init(data: response.data! )
                self.completions[key.loadKhachHang]!(json, nil)
            } catch {
                self.completions[key.loadKhachHang]!(nil, response.error)
            }
            self.completions[key.loadKhachHang] = nil
        }
    }
    
    
    public func removeKhachHang(parameters: [String: String] ,completionHandler: @escaping CompletionHandler){
        self.completions[key.removeKhachHang] = completionHandler
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
        QLBatDongSanService.Manager.request("https://localhost:5001/KhachHang/RemoveListKhachHang", method: .post, parameters: nil, encoding: JSONEncoding(options: []), headers: parameters).responseJSON { response in
            do {
                let json: JSON = try JSON.init(data: response.data! )
                self.completions[key.removeKhachHang]!(json, nil)
            } catch {
                self.completions[key.removeKhachHang]!(nil, response.error)
            }
            
        }
    }
    
    public func editKhachHang(parameters: [String: String] ,completionHandler: @escaping CompletionHandler){
        self.completions[key.editKhachHang] = completionHandler
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
        QLBatDongSanService.Manager.request("https://localhost:5001/KhachHang/EditKhachHang", method: .post, parameters: nil, encoding: JSONEncoding(options: []), headers: parameters).responseJSON { response in
            do {
                let json: JSON = try JSON.init(data: response.data! )
                self.completions[key.editKhachHang]!(json, nil)
            } catch {
                self.completions[key.editKhachHang]!(nil, response.error)
            }
            
        }
    }
}
