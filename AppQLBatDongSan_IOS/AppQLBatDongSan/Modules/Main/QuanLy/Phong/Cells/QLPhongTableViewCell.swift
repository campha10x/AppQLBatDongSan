//
//  QLPhongTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 10/27/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class QLPhongTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buttonRemove: UIButton!
    
    @IBOutlet weak var lblTenPhong: UILabel!
    @IBOutlet weak var lblDonGia: UILabel!
    @IBOutlet weak var lblSoDien: UILabel!
    @IBOutlet weak var lblSoNuoc: UILabel!
    
    var delegate: eventProtocols?
    
    static let id = "QLPhongTableViewCell"
    
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
    
    func binding(phong: Phong, index: Int )  {
        self.index = index
        lblTenPhong.text = phong.tenPhong
        lblDonGia.text = phong.donGia.toNumberString(decimal: false)
        lblSoDien.text = phong.soDien
        lblSoNuoc.text = phong.soNuoc
    }
    
}
