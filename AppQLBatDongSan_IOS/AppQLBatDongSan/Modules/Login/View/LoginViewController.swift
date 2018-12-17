//
//  LoginViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 9/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var containerViewLogin: UIView!
    @IBOutlet weak var containerViewRegister: UIView!
    
    var viewRegister: ViewRegisterViewController?
    var viewLogin: ViewLoginViewController?
    
    let manager = Alamofire.SessionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        showContainer(containerView: self.containerViewLogin)
        listenForEvent()
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
    
    func login(username email: String, password: String, typeLogin: TypeLogin) {
        SVProgressHUD.show()
        if typeLogin.rawValue == TypeLogin.ChuCanho.rawValue {
            manager.request("https://localhost:5001/Account/Index/\(email)/\(password)", method: .get, parameters: [:], encoding: JSONEncoding(options: [])).responseJSON { response in
                do {
                    let json: JSON = try JSON.init(data: response.data! )
                    let account  = Account.init(json: json)
//                    Storage.shared.addOrUpdate([account], type: Account.self)
                    AppState.shared.saveAccount(account: account, typeLogin: typeLogin)
                    
                    self.presentMainScreen( animated: true)
                } catch {
                    
                    self.loginFail(error: error.localizedDescription)
                }
                SVProgressHUD.dismiss()
            }
        } else {
            manager.request("https://localhost:5001/KhachHang/Index/\(email)/\(password)", method: .get, parameters: [:], encoding: JSONEncoding(options: [])).responseJSON { response in
                do {
                    let json: JSON = try JSON.init(data: response.data! )
                    let khachHang  = KhachHang.init(json: json)
//                    Storage.shared.addOrUpdate([khachHang], type: KhachHang.self)
                    AppState.shared.saveKhachHang(khachHang: khachHang, typeLogin: typeLogin)
                    
                    self.presentMainScreen( animated: true)
                } catch {
                    
                    self.loginFail(error: error.localizedDescription)
                }
                SVProgressHUD.dismiss()
            }
        }
       
    }
    
    func presentMainScreen(animated: Bool) {
        let main = HoaDonWireFrame.createHoaDon()
        self.navigationController?.pushViewController(main, animated: animated)
    }
    
    func listenForEvent() {
        viewLogin?.onRegister = {
            self.showContainer(containerView: self.containerViewRegister)
        }
        viewLogin?.onLogin = { email, password, typeLogin in
            self.login(username: email, password: password, typeLogin: typeLogin)
        }
        
        viewRegister?.onLogin = {
            self.showContainer(containerView: self.containerViewLogin)
        }
        
    }
    
    func showContainer(containerView: UIView) {
        UIView.animate(withDuration: 0.2) {
            self.containerViewLogin.alpha = self.containerViewLogin == containerView ? 1 : 0
            self.containerViewRegister.alpha = self.containerViewRegister == containerView ? 1: 0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ViewLoginViewController {
            viewLogin = segue.destination as? ViewLoginViewController
        } else if segue.destination is ViewRegisterViewController {
            viewRegister = segue.destination as? ViewRegisterViewController
            viewRegister?.delegate = self
        }
    }
    
}

extension LoginViewController: RegisterDelegates {
    func loginFail(error: String) {
        Notice.make(type: .Error, content: "Tài khoản không đúng mời bạn nhập lại").show()
    }
    
    func didRegister(email: String, phone: String, password: String ) {
        let parameters: [String: String] = [
            "Email" : email,
            "MatKhau" :password ,
            "SDT" : phone
        ]
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/Account/AddAccount", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    Notice.make(type: .Success, content: "Đăng kí tài khoản thành công! ").show()
                    self.showContainer(containerView: self.containerViewLogin)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
    }
    
}
