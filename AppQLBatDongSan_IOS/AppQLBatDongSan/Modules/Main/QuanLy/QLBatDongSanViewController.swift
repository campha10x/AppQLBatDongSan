//
//  QLBatDongSanViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/14/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class QLBatDongSanViewController: UIViewController {

    fileprivate var segueIdentifier : String = "segueTongQuan"
    
    private (set) var currentViewController : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if AppState.shared.typeLogin == TypeLogin.ChuCanho.rawValue {
            segueIdentifier = "segueTongQuan"
        } else {
            segueIdentifier = "segueHoadon"
        }
        segueIdentifierReceivedFromParent(self.segueIdentifier)
        // Do any additional setup after loading the view.
    }
    
    func segueIdentifierReceivedFromParent(_ identifier: String){
        self.segueIdentifier = identifier
        self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if currentViewController != nil{
                currentViewController?.removeFromParentViewController()
                currentViewController?.view.removeFromSuperview()
                currentViewController = nil
            }
        }
        if segue.destination is AccountInformationViewController {
            let currentViewController = segue.destination as? AccountInformationViewController
            currentViewController?.dismissViewController = {
                self.segueIdentifierReceivedFromParent(MainMenuType.segueTongQuan.rawValue)
            }
        }
        
        if segue.destination is QLCanHoViewControlvar {
            let currentViewController = segue.destination as? QLCanHoViewControlvar
            currentViewController?.eventChoThue = {
                self.segueIdentifierReceivedFromParent(MainMenuType.segueHopdong.rawValue)
            }
        }
        currentViewController = segue.destination
        self.addChildViewController(currentViewController!)
        currentViewController?.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview((currentViewController?.view)!)
        currentViewController?.didMove(toParentViewController: self)
    }

}
