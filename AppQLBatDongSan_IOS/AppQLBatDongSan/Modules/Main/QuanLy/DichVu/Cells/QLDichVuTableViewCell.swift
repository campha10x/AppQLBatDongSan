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
    @IBOutlet weak var lblDongia: UILabel!
    @IBOutlet weak var lblDonvi: UILabel!
    
    
        
    
    static let id = "QLDichVuTableViewCell"
    var index: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        lblDongia.text = dichvu.DonGia.toNumberString(decimal: false)
        lblDonvi.text = dichvu.DonVi
    }

}
