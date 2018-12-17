//
//  HoaDonViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 9/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

enum MainMenuType: String {
    case segueHoadon = "segueHoadon"
    case seguePhieuthu = "seguePhieuthu"
    case seguePhieuchi = "seguePhieuchi"
    case segueKhachhang = "segueKhachhang"
    case segueHopdong = "segueHopdong"
    case segueLogout = "segueLogout"
    case segueDoanhthu = "segueDoanhthu"
    case seguePhong = "seguePhong"
    case segueDichvu = "segueDichvu"
    case segueTongQuan = "segueTongQuan"
    case segueAccountInfor = "segueAccountInfor"
}

class HoaDonBaseViewController: UIViewController {
    var hoadonDirectionViewController: QLBatDongSanViewController?
    var headerViewController: HeaderMainViewController?
    
    var presenter: HoaDonPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func eventClickMenuOption(_ sender: Any) {
        let storyboard = UIStoryboard(name: "BatDongSanPopOver", bundle: nil)
        if let menu = storyboard.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController {
            menu.delegate = self
            self.view.addSubview(menu.view)
            self.addChildViewController(menu)
            menu.show()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is UINavigationController {
            let destViewController = segue.destination as! UINavigationController
            hoadonDirectionViewController = destViewController.topViewController as? QLBatDongSanViewController
        } else if segue.destination is HeaderMainViewController {
            headerViewController = segue.destination as? HeaderMainViewController
            headerViewController?.delegate = self
        }

    }
    
}

extension HoaDonBaseViewController: MainMenuDelegate {
    func mainMenuOpen(type: MainMenuType){
        if type == .segueLogout {
            Storage.shared.removeAll()
            AppState.shared.saveAccount(account: nil, typeLogin: nil)
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            hoadonDirectionViewController?.segueIdentifierReceivedFromParent(type.rawValue)
        }
    }
}

extension HoaDonBaseViewController: HoaDonViewProtocol {
    
}

extension HoaDonBaseViewController: HeaderMainOptionDelegate {
    func eventClickShowInfor() {
         self.mainMenuOpen(type: .segueAccountInfor)
    }
    
    func eventClickLogout() {
       
    }
    
    
}

