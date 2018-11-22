//
//  QLDonViTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 10/27/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class QLDonViTableViewCell: UITableViewCell {

    var delegate: eventProtocols?
    
    @IBOutlet weak var labelGhiChu: UILabel!
    @IBOutlet weak var labelTenDonvi: UILabel!
    
    static let id = "QLDonViTableViewCell"
    var index: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func eventEdit(_ sender: Any) {
        delegate?.eventEdit(self.index)
    }
    
    @IBAction func eventRemove(_ sender: Any) {
        delegate?.eventRemove(self.index)
    }
    
    func binding(donvi: DonVi, index: Int )  {
        self.index = index
        labelTenDonvi.text = donvi.TenDonVi
        labelGhiChu.text = donvi.GhiChu
    }

}
