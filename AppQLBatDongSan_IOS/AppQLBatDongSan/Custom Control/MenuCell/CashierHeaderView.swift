//
//  CashierHeaderView.swift
//  ConnectPOS
//
//  Created by HarryNg on 10/13/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit

class CashierHeaderView: UIView {
    @IBOutlet weak var lbNameCashier: UILabel!
    @IBOutlet weak var imgAvatarCashier: UIImageView!
   
    class func instanceFromNib() -> CashierHeaderView {
        return UINib(nibName: "CashierHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CashierHeaderView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addBorder(edges: [.bottom], color: UIColor(netHex: 0xe5e5e5))
        imgAvatarCashier.clipsToBounds = true
        imgAvatarCashier.layer.cornerRadius = imgAvatarCashier.bounds.height/2
        self.backgroundColor = UIColor(netHex: 0xF0F0F0)
    }
    
    func setDataCashier(nameImage image:String?, nameCashier name:String) -> Void {
        if let image = image {
             self.imgAvatarCashier.image = UIImage(named: image)
        }
        self.lbNameCashier.text = "Tên: " +  name.uppercased()
    }

}
