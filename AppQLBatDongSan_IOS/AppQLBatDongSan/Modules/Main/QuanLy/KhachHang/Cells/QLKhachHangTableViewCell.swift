//
//  QLKhachHangTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 10/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

protocol QLKhachHangCellDelegates {
    func eventRemoveKhachHang(_ index: Int)
    func eventEditKhachHang(_ index: Int)
}
class QLKhachHangTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTenKhachHang: UILabel!
    @IBOutlet weak var lbTenPhong: UILabel!
    @IBOutlet weak var lbNamSinh: UILabel!
    @IBOutlet weak var lbQuequan: UILabel!
    @IBOutlet weak var lbCMND: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbSDT: UILabel!
    var index: Int = -1
    var delegate: QLKhachHangCellDelegates?
    
    static let id = "QLKhachHangTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func eventRemoveKhachHang(_ sender: Any) {
        delegate?.eventRemoveKhachHang(self.index)
    }
    
    @IBAction func eventEditKhachHang(_ sender: Any) {
        delegate?.eventEditKhachHang(self.index)
    }
    
    func binding(_ khachhang: KhachHang, _ index: Int)  {
        lbTenKhachHang.text = khachhang.TenKH
        let listPhong = Storage.shared.getObjects(type: Phong.self) as? [Phong]
        let phong: Phong? = listPhong?.filter({ $0.idPhong == khachhang.IdPhong }).first
        self.index = index
        lbTenPhong.text = phong?.tenPhong ?? ""
        lbNamSinh.text = khachhang.NgaySinh.formatDate()
        lbSDT.text = khachhang.SDT
        lbEmail.text = khachhang.Email
        lbCMND.text = khachhang.CMND
        lbQuequan.text = khachhang.Quequan
        
    }
}
