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

    func binding(CTHD: ChiTietHoaDon) {
        lbTenDichVu.text = CTHD.TenDichVu
        lbSoCu.text = CTHD.SoCu
        lbSoMoi.text = CTHD.SoMoi
        lbDonGia.text = CTHD.DonGia.toNumberString(decimal: false)
        lbThanhTien.text = "\(CTHD.thanhTien)".toNumberString(decimal: false)
    }

}
