//
//  HoaDonInforTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 12/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class HoaDonInforTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTenDichVu: UILabel!
    @IBOutlet weak var lbThanhTien: UILabel!
    @IBOutlet weak var lbDonGia: UILabel!
    @IBOutlet weak var lbSoMoi: UILabel!
    @IBOutlet weak var lbSoCu: UILabel!

    static let id = "HoaDonInforTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func binding(dichvu: DichVuDocument) {
        lbTenDichVu.text = dichvu.nameDichVu
        lbSoCu.text = dichvu.soCu
        lbSoMoi.text = dichvu.soMoi
        lbDonGia.text = dichvu.donGia.toNumberString(decimal: false)
        lbThanhTien.text = dichvu.thanhTien.toNumberString(decimal: false)
    }

}
