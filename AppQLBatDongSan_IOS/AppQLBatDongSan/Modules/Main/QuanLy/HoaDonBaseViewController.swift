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
    case segueNhatro = "segueNhatro"
    case seguePhong = "seguePhong"
    case segueDonvi = "segueDonvi"
    case segueDichvu = "segueDichvu"
    case segueTongQuan = "segueTongQuan"
}

class HoaDonBaseViewController: UIViewController {
    var hoadonDirectionViewController: QLBatDongSanViewController?
    
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
        }
    }
    
}

extension HoaDonBaseViewController: MainMenuDelegate {
    func mainMenuOpen(type: MainMenuType){
        if type == .segueLogout {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            hoadonDirectionViewController?.segueIdentifierReceivedFromParent(type.rawValue)
        }
    }
    
}



extension HoaDonBaseViewController: HoaDonViewProtocol {
    
}
