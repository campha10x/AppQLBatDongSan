//
//  ListPhieuChiTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 10/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

protocol eventProtocols {
    func eventEdit(_ index: Int)
    func eventRemove(_ index: Int)
}


class ListPhieuChiTableViewCell: UITableViewCell {
    @IBOutlet weak var labelCanHo: UILabel!
    @IBOutlet weak var labelDienGiai: UILabel!
    @IBOutlet weak var labelNgay: UILabel!
    @IBOutlet weak var labelSoTien: UILabel!
    
    @IBOutlet weak var buttonRemove: UIButton!
    var delegate: eventProtocols?
    
    static let id = "ListPhieuChiTableViewCell"
    var index: Int = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func eventEditPhieuChi(_ sender: Any) {
        delegate?.eventEdit(self.index)
    }
    
    @IBAction func eventRemovePhieuChi(_ sender: Any) {
          delegate?.eventRemove(self.index)
    }
    
    func binding(phieuchi: PhieuChi, index: Int )  {
        self.index = index
        let listCanHo = Storage.shared.getObjects(type: CanHo.self) as? [CanHo]
        labelCanHo.text = listCanHo?.filter({ $0.IdCanHo == phieuchi.IdCanHo }).first?.TenCanHo
        labelSoTien.text = phieuchi.Sotien.toNumberString(decimal: false)
        labelNgay.text = phieuchi.Ngay.formatDate()
        labelDienGiai.text = phieuchi.DienGiai
        buttonRemove.backgroundColor = UIColor.red
    }
}
