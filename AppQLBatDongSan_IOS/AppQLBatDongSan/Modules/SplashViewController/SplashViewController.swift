//
//  SplashViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 9/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import RealmSwift
class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }

    func load() {
        let nav = self.navigationController
         let loginVC = LoginWireFrame.createLogin()
        nav?.pushViewController(loginVC, animated: false)
        nav?.viewControllers.removeAll()
        nav?.viewControllers = [ loginVC]
//        if AppState.shared.account != nil {
            let main = HoaDonWireFrame.createHoaDon()
           nav?.pushViewController(main, animated: false)
//        }
    }

}
