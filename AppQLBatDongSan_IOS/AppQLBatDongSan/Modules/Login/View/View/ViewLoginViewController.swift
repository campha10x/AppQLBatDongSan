//
//  ViewLoginViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 9/25/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

enum TypeLogin: Int {
    case ChuCanho = 0
    case NguoiThue = 1
}

class ViewLoginViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var textfieldEmail: UITextField!
    var onRegister: (()->())?
    var onLogin: ((_ email: String, _ passWord: String, _ typeLogin: TypeLogin)->())?
    
    @IBOutlet weak var checkboxTypeLogin: MyCheckboxGroup!
    override func viewDidLoad() {
        super.viewDidLoad()
        textfieldEmail.placeholder = "Địa chỉ email hoặc số điện thoại"
        textfieldPassword.placeholder = "Mật khẩu"
        textfieldEmail.text = "phamxuanduy1996@gmail.com"
        textfieldPassword.text = "thaythuoc"
        textfieldPassword.isSecureTextEntry = true
        btnLogin.backgroundColor = MyColor.cyan
        btnLogin.layer.cornerRadius = MyUI.buttonCornerRadius
        checkboxTypeLogin.addTitleAndOptions("", options: [TypeLogin.ChuCanho.rawValue:  "Bạn là chủ căn hộ",TypeLogin.NguoiThue.rawValue: "Bạn là người thuê"],isRadioBox: true)
            checkboxTypeLogin.selecteAt(index: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func eventLogin(_ sender: Any) {
        guard let email = textfieldEmail.text, let password = textfieldPassword.text, email.isValidEmail(), !email.isEmpty, !password.isEmpty else {
            Notice.make(type: .Error, content: "Đăng nhập thất bại mời bạn kiểm tra lại").show()
            return
            
        }
        if let type = TypeLogin.init(rawValue: checkboxTypeLogin.selectedId ?? 0){
            onLogin?(email, password, type)
        }

    }

    @IBAction func eventRegister(_ sender: Any) {
        onRegister?()
    }
}
