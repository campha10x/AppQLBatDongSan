//
//  HoaDonDirectionViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 9/30/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class HoaDonDirectionViewController: UIViewController {
    var segueIdentifier = "CreateBill"
    var currentViewController : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func segueIdentifierReceivedFromParent(_ identifier: String){
        self.segueIdentifier = identifier
        self.performSegue(withIdentifier: self.segueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueIdentifier {
            if currentViewController != nil {
                currentViewController?.removeFromParentViewController()
                currentViewController?.view.removeFromSuperview()
                currentViewController = nil
            }
            if segue.description is HoaDonViewController {
                
            }
            currentViewController = segue.destination
            self.addChildViewController(currentViewController!)
            currentViewController?.view.frame = CGRect(x: 0,y: 0, width: self.view.frame.width,height: self.view.frame.height)
            self.view.addSubview(currentViewController!.view)
            currentViewController?.didMove(toParentViewController: self)
        }
    }

}
