//
//  HeaderMainViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

class HeaderMainViewController: UIViewController {
    
    @IBOutlet weak var cbbNhaTro: MyCombobox!
    
    var listNhaTro: [NhaTro] = []
    
    override func viewDidLoad() {
//        loadNhaTro()
       listNhaTro = Storage.shared.getObjects(type: NhaTro.self) as! [NhaTro]
        self.cbbNhaTro.setOptions(self.listNhaTro.map({ $0.tenNhaTro }), placeholder: nil, selectedIndex: 0)
    }
    
    func loadNhaTro()  {
        SVProgressHUD.show()
        QLBatDongSanService.shared.getListNhaTro { (json, error) in
            if let json = json {
                self.listNhaTro  = json.arrayValue.map({NhaTro.init(json: $0)})
                Storage.shared.addOrUpdate(self.listNhaTro, type: NhaTro.self)
                self.cbbNhaTro.setOptions(self.listNhaTro.map({ $0.tenNhaTro }), placeholder: nil, selectedIndex: 0)
            } else if let error = error {
                Notice.make(type: .Error, content: error.localizedDescription).show()
            }
            SVProgressHUD.dismiss()
        }
    }
    
}
