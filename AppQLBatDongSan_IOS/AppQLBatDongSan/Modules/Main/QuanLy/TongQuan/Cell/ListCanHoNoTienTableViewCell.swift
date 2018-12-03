//
//  ListCanHoNoTienTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 12/3/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class ListCanHoNoTienTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbSoTienNo: UILabel!
    @IBOutlet weak var lbNameCanHo: UILabel!
    static let id = "ListCanHoNoTienTableViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func binding(soTien: String, tenCanho: String)
    {
        self.lbSoTienNo.text = soTien.toNumberString()
        self.lbNameCanHo.text = tenCanho
    }
}
