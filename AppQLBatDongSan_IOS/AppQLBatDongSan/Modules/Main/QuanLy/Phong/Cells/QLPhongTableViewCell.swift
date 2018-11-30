//
//  QLCanHoTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 10/27/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class QLCanHoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buttonRemove: UIButton!
    
    @IBOutlet weak var lblTenCanHo: UILabel!
    @IBOutlet weak var lblDonGia: UILabel!
    @IBOutlet weak var lblSoDien: UILabel!
    @IBOutlet weak var lblSoNuoc: UILabel!
    
    var delegate: eventProtocols?
    
    static let id = "QLCanHoTableViewCell"
    
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
    
    func binding(canHo: CanHo, index: Int )  {
        self.index = index
        lblTenCanHo.text = canHo.TenCanHo
        lblDonGia.text = canHo.DonGia.toNumberString(decimal: false)
        lblSoDien.text = canHo.SoDienCu
        lblSoNuoc.text = canHo.SoNuocCu
    }
    
}
