//
//  MainBaseViewController.swift
//  ConnectPOS
//
//  Created by Black on 10/20/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol MainBaseViewControllerDelegate {
    func mainBaseOpenMenu(type: MainMenuType)
    func mainBaseShowLeftMenu()
}

class MainBaseViewController: UIViewController {
    var baseDelegate: MainBaseViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func showPopover(id: String, inStoryboard: String) -> UIViewController {
        let popup = UIStoryboard(name: inStoryboard, bundle: nil).instantiateViewController(withIdentifier: id)
        popup.modalPresentationStyle = .overCurrentContext
        self.present(popup, animated: true, completion: nil)
        return popup
    }
    
    func showMenuSetting() -> Void {
        baseDelegate?.mainBaseShowLeftMenu()
    }
    
    func clear() {
        // for override
    }
    
    
}


