//
//  LoginListProtocol.swift
//  AppQLBatDongSan
//
//  Created by User on 9/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

protocol LoginViewProtocol: class {
    var presenter: LoginPresenterProtocol? {set get}
    
    func loginFail(error: String)
}

protocol LoginPresenterProtocol: class {
    var view: LoginViewProtocol? {set get}
    var interacter: LoginInteractorProtocol? {set get}
    var wireframe: LoginWireFrameProtocol? {set get}
    
    func login(username: String, password: String)
    func loginSuccess()
    func loginFail(error: String)
}

protocol LoginInteractorProtocol: class {
    var presenter: LoginPresenterProtocol? {set get}
    func login(username: String, password: String)
}


protocol LoginWireFrameProtocol {
    func presentMainScreen(from view: LoginViewProtocol, animated: Bool)
}
