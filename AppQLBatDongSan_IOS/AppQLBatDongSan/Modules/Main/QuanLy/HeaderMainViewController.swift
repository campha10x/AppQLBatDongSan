//
//  HeaderMainViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire

class HeaderMainViewController: UIViewController {

    let manager = Alamofire.SessionManager()
    
    var delegate: HeaderMainOptionDelegate?
    
    override func viewDidLoad() {
        configService()
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
    
    
    @IBAction func eventClickShowInforUser(_ sender: UIButton) {
        let currentViewController: MenuOptionInforViewController = UIStoryboard.init(name: "AccountInforUser", bundle: nil).instantiateViewController(withIdentifier: "MenuOptionInforViewController") as! MenuOptionInforViewController
        currentViewController.delegate = self
        currentViewController.modalPresentationStyle = .popover
        currentViewController.preferredContentSize = CGSize.init(width: 200, height: 100)
        currentViewController.popoverPresentationController?.sourceView = sender
        currentViewController.popoverPresentationController?.sourceRect = sender.bounds
        self.present(currentViewController, animated: true, completion: nil)
    }
    
}

extension HeaderMainViewController: HeaderMainOptionDelegate {
    func eventClickShowInfor() {
        delegate?.eventClickShowInfor()
    }
    
    func eventClickLogout() {
        Storage.shared.removeAll()
        AppState.shared.saveAccount(account: nil, typeLogin: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
