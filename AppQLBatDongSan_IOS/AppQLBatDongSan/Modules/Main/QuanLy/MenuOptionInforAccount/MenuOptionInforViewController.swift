//
//  MenuOptionInforViewController.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 11/25/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

protocol HeaderMainOptionDelegate: class {
    func eventClickShowInfor()
    func eventClickLogout()
}

class MenuOptionInforViewController: UIViewController {

    var delegate: HeaderMainOptionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func eventClickShowInfor(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        delegate?.eventClickShowInfor()
    }
    
    @IBAction func eventClickLogout(_ sender: Any) {
        AppState.shared.saveAccount(account: nil, typeLogin: nil)
        self.dismiss(animated: true, completion: nil)
        delegate?.eventClickLogout()
    }
    

}
