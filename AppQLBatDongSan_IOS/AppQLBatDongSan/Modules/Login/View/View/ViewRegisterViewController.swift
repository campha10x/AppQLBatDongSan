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
    
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfRePassword: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tfEmail.placeholder = "Địa chỉ email"
        tfPhone.placeholder = "Số điên thoại"
        tfPassword.placeholder = "Mật khẩu"
        tfRePassword.placeholder = "Nhập lại mật khẩu"
        
    }

    @IBAction func eventRegister(_ sender: Any) {
        guard let email = tfEmail.text ,let phone = tfPhone.text, let password = tfPassword.text else { return  }
        delegate?.didRegister(email: email, phone: phone, password: password)
    }
    
    @IBAction func eventLogin(_ sender: Any) {
        onLogin?()
    }
    
}
