//
//  LoginPresenterProtocol.swift
//  AppQLBatDongSan
//
//  Created by User on 9/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SVProgressHUD

class LoginPresenter: LoginPresenterProtocol {
    
    var view: LoginViewProtocol?
    
    var interacter: LoginInteractorProtocol?
    
    var wireframe: LoginWireFrameProtocol?
    
    func login(username: String, password: String) {

        interacter?.login(username: username, password: password)
    }
    
    func loginSuccess() {
        wireframe?.presentMainScreen(from: view!, animated: false)
    }
    
    func loginFail(error: String) {
        view?.loginFail(error: error)
    }
}
