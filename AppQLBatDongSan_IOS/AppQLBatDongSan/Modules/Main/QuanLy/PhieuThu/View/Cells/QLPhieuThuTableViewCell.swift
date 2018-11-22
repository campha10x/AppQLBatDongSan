//
//  QLPhieuThuTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 10/10/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class ListPhieuThuTableViewCell: UITableViewCell {
    
    static let id = "ListPhieuThuTableViewCell"
    
    @IBOutlet weak var labelGhiChu: UILabel!
    @IBOutlet weak var labelNgay: UILabel!
    @IBOutlet weak var labelSoTien: UILabel!
    @IBOutlet weak var labelMaHoaDon: UILabel!
    @IBOutlet weak var labelTenPhong: UILabel!
    @IBOutlet weak var buttonRemove: UIButton!
    var index:Int = 0
    var onRemovePhieuThu: ((_ index: Int)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func eventRemovePhieuThu(_ sender: Any) {
        onRemovePhieuThu?(index)
    }

    func binding(phieuthu: PhieuThu, index: Int )  {
        self.index = index
        let listPhong = Storage.shared.getObjects(type: Phong.self) as? [Phong]
        labelTenPhong.text = listPhong?.filter({ $0.idPhong == phieuthu.IdPhong }).first?.tenPhong
        labelMaHoaDon.text = phieuthu.IdHoaDon
        labelSoTien.text = phieuthu.SoTien.toNumberString(decimal: false)
        labelNgay.text = phieuthu.Ngay.formatDate()
        labelGhiChu.text = phieuthu.GhiChu
        buttonRemove.backgroundColor = UIColor.red
    }

}
