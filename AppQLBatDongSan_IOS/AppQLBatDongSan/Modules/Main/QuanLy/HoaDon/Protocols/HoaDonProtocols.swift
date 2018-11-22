//
//  HoaDonProtocols.swift
//  AppQLBatDongSan
//
//  Created by User on 9/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

protocol HoaDonViewProtocol: class {
    var presenter: HoaDonPresenterProtocol? {set get}
    
}

protocol HoaDonPresenterProtocol: class {
    var view: HoaDonViewProtocol? {set get}
    var interacter: HoaDonInteractorProtocol? {set get}
    var wireframe: HoaDonWireFrameProtocol? {set get}
    
}

protocol HoaDonInteractorProtocol: class {
    var presenter: HoaDonPresenterProtocol? {set get}
    
}


protocol HoaDonWireFrameProtocol {
//    func presentMainScreen(from view: LoginViewProtocol, animated: Bool)
}
