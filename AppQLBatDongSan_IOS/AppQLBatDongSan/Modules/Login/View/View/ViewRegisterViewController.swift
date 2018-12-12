//
//  ViewRegisterViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 9/25/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

protocol RegisterDelegates {
    func didRegister(email: String, phone: String, password: String )
}

class ViewRegisterViewController: UIViewController {

    var onLogin: (()->())?
    var delegate: RegisterDelegates?
    
    
    @IBOutlet weak var tfEmail: MyTextField!
    @IBOutlet weak var tfPhone: MyTextField!
    @IBOutlet weak var tfPassword: MyTextField!
    @IBOutlet weak var tfRePassword: MyTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmail.placeholder = "Địa chỉ email"
        tfPhone.placeholder = "Số điên thoại"
        tfPassword.placeholder = "Mật khẩu"
        tfRePassword.placeholder = "Nhập lại mật khẩu"
        tfPassword.isSecureTextEntry = true
        tfRePassword.isSecureTextEntry = true
        
    }

    @IBAction func eventRegister(_ sender: Any) {
        let password1 = tfPassword.text?.trimmingCharacters(in: .whitespaces)
        let password2 = tfRePassword.text?.trimmingCharacters(in: .whitespaces)
        guard let email = tfEmail.text ,let phone = tfPhone.text, let password = tfPassword.text, password1 == password2, !email.isEmpty, !phone.isEmpty, !password.isEmpty  else {
            if password1 != password2 {
                tfPassword.warning()
                tfRePassword.warning()
                Notice.make(type: .Error, content: "Mật khẩu phải trùng nhau").show()
            }
            if let email = tfEmail.text, email.isEmpty{
                Notice.make(type: .Error, content: "Email không được rỗng").show()
                tfEmail.warning()
            }
            if let phone = tfPhone.text, phone.isEmpty {
                Notice.make(type: .Error, content: "Điện thoại không được rỗng").show()
                tfEmail.warning()
            }
            if let password = tfPassword.text, let rePassword = tfRePassword.text,  password.isEmpty , rePassword.isEmpty {
                Notice.make(type: .Error, content: "Mật khẩu không được để rỗng").show()
                tfEmail.warning()
            }
            return
        }
        delegate?.didRegister(email: email, phone: phone, password: password)
        resetControl()
    }
    
    func resetControl(){
        tfEmail.text = ""
        tfPhone.text = ""
        tfPassword.text = ""
        tfRePassword.text = ""
    }
    
    @IBAction func eventLogin(_ sender: Any) {
        onLogin?()
    }
    
}
