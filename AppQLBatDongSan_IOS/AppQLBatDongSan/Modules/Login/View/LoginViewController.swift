//
//  LoginViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 9/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var presenter: LoginPresenterProtocol?
    
    @IBOutlet weak var containerViewLogin: UIView!
    @IBOutlet weak var containerViewRegister: UIView!
    
    var viewRegister: ViewRegisterViewController?
    var viewLogin: ViewLoginViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        showContainer(containerView: self.containerViewLogin)
        listenForEvent()
    }
    
    
    func listenForEvent() {
        viewLogin?.onRegister = {
            self.showContainer(containerView: self.containerViewRegister)
        }
        viewLogin?.onLogin = { email, passowrd in
            self.presenter?.login(username: email, password: passowrd)
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
        }
    }
    
}

extension LoginViewController: LoginViewProtocol {
    func loginFail(error: String) {
        Notice.make(type: .Error, content: "Tài khoản không đùng mời bạn nhập lại").show()
    }
    
    
}
