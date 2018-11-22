//
//  QLNhaTroTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 10/21/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class QLNhaTroTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buttonRemove: UIButton!
    @IBOutlet weak var labelTenNhaTro: UILabel!
    @IBOutlet weak var labelGhichu: UILabel!
    var delegate: eventProtocols?
    
    static let id = "QLNhaTroTableViewCell"
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
    
    func binding(nhatro: NhaTro, index: Int )  {
        self.index = index
        labelTenNhaTro.text = nhatro.tenNhaTro
        labelGhichu.text = nhatro.ghiChu
        buttonRemove.backgroundColor = UIColor.red
    }

}

