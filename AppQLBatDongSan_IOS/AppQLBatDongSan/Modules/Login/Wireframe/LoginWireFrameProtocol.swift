//
//  LoginWireFrameProtocol.swift
//  AppQLBatDongSan
//
//  Created by User on 9/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit


class LoginWireFrame: LoginWireFrameProtocol {
    class func createLogin() -> LoginViewController {
        let view = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() as! LoginViewController
        let presenter: LoginPresenterProtocol = LoginPresenter()
        let wireframe: LoginWireFrameProtocol = LoginWireFrame()
        let interactor: LoginInteractorProtocol = LoginInteractor()
        
        view.presenter = presenter
        presenter.view = view 
        presenter.wireframe = wireframe
        presenter.interacter = interactor
        interactor.presenter = presenter
        
        return view
    }
    func presentMainScreen(from view: LoginViewProtocol, animated: Bool) {
        let main = HoaDonWireFrame.createHoaDon()
        if let sourceView = view as? LoginViewController {
            sourceView.navigationController?.pushViewController(main, animated: animated)
        }
    }
}
