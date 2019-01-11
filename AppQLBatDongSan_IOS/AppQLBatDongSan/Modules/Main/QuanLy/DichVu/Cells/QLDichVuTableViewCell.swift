//
//  QLDichVuTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 10/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class QLDichVuTableViewCell: UITableViewCell {

    var delegate: eventProtocols?
    
    @IBOutlet weak var lblTenDichVu: UILabel!
    @IBOutlet weak var lblDonvi: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    
        
    
    static let id = "QLDichVuTableViewCell"
    var index: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnDelete?.layer.borderColor = UIColor.lightGray.cgColor
        btnDelete?.layer.borderWidth = 1.0
        btnDelete?.layer.cornerRadius = MyUI.buttonCornerRadius
        btnDelete?.backgroundColor =  UIColor.red
    }
    
    @IBAction func eventEdit(_ sender: Any) {
        delegate?.eventEdit(self.index)
    }
    
    @IBAction func eventRemove(_ sender: Any) {
        delegate?.eventRemove(self.index)
    }
    
    func binding(dichvu: DichVu, index: Int )  {
        self.index = index
        lblTenDichVu.text = dichvu.TenDichVu
        lblDonvi.text = dichvu.DonVi
    }

}
