//
//  ViewLoginViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 9/25/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class ViewLoginViewController: UIViewController {

    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldEmail: UITextField!
    var onRegister: (()->())?
    var onLogin: ((_ email: String, _ passWord: String)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldEmail.placeholder = "Địa chỉ email hoặc số điện thoại"
        textfieldPassword.placeholder = "Mật khẩu"
        textfieldEmail.text = "phamxuanduy1996@gmail.com"
        textfieldPassword.text = "thaythuoc"
        textfieldPassword.isSecureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func eventLogin(_ sender: Any) {
        guard let email = textfieldEmail.text, let password = textfieldPassword.text else { return }
        onLogin?(email, password)
    }

    @IBAction func eventRegister(_ sender: Any) {
        onRegister?()
    }
}
