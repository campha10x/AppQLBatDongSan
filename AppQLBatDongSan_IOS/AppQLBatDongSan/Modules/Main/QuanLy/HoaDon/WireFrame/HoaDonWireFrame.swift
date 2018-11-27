//
//  HoaDonWireFrame.swift
//  AppQLBatDongSan
//
//  Created by User on 9/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit

class HoaDonWireFrame: HoaDonWireFrameProtocol {
    class func createHoaDon() -> HoaDonBaseViewController {
        let view = UIStoryboard.init(name: "QuanLy", bundle: nil).instantiateInitialViewController() as! HoaDonBaseViewController
        let presenter: HoaDonPresenterProtocol = HoaDonPresenter()
        let wireframe: HoaDonWireFrameProtocol = HoaDonWireFrame()
        let interactor: HoaDonInteractorProtocol = HoaDonInteractor()
        
        view.presenter = presenter
        presenter.view = view  
        presenter.wireframe = wireframe
        presenter.interacter = interactor
        interactor.presenter = presenter
        
        return view
    }
    func presentMainScreen(from view: LoginViewProtocol, animated: Bool) {
        
    }
}
