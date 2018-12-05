//
//  DoanhThuTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 11/27/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class DoanhThuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbMoney: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    static let id = "DoanhThuTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func binding(date: String, money: String, rowLast: Bool = false) {
        if rowLast {
            self.lbDate.text = date
            self.lbDate.font = UIFont.boldSystemFont(ofSize: 15)
        } else {
            self.lbDate.text = date + "/ \(Date().year)"
        }
        self.lbMoney.text = money.toNumberString(decimal: false)
    }

}
