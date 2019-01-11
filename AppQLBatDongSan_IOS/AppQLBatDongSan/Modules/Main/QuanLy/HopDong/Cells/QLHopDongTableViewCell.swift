//
//  QLHopDongTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 11/3/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class QLHopDongTableViewCell: UITableViewCell {

    var delegate: eventProtocols?
    
    @IBOutlet weak var lblMaHopDong: UILabel!
    @IBOutlet weak var lblChuHopDong: UILabel!
    @IBOutlet weak var lblCanHo: UILabel!
    @IBOutlet weak var lblNgayBatDau: UILabel!
    @IBOutlet weak var lblSoTienCoc: UILabel!
    @IBOutlet weak var lblNgayKetThuc: UILabel!
    @IBOutlet weak var lblTrangThaiHD: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    
    static let id = "QLHopDongTableViewCell"
    var index: Int = -1
    
    var listCanHo: [CanHo] = Storage.shared.getObjects(type: CanHo.self) as! [CanHo]
    override func awakeFromNib() {
        super.awakeFromNib()
        btnDelete?.layer.borderColor = UIColor.lightGray.cgColor
        btnDelete?.layer.borderWidth = 1.0
        btnDelete?.layer.cornerRadius = MyUI.buttonCornerRadius
        btnDelete?.backgroundColor = UIColor.red
        
        if AppState.shared.typeLogin == TypeLogin.NguoiThue.rawValue {
           btnDelete.isHidden = true
            btnEdit.isHidden = true
        }
    }
    
    @IBAction func eventEdit(_ sender: Any) {
        delegate?.eventEdit(self.index)
    }
    
    @IBAction func eventRemove(_ sender: Any) {
        delegate?.eventRemove(self.index)
    }
    
    func binding(hopdong: HopDong, index: Int )  {
        self.index = index
        let canHo = listCanHo.filter({$0.IdCanHo == hopdong.IdCanHo }).first
        lblMaHopDong.text = hopdong.maHopDong
        let listAccount = Storage.shared.getObjects(type: Account.self) as! [Account]
        if let hoten = listAccount.filter({ $0.IdAccount == hopdong.IdChuCanHo}).first?.hoten {
            lblChuHopDong.text = hoten
        } else {
            lblChuHopDong.text = "None"
        }
        lblCanHo.text = canHo?.maCanHo
        lblSoTienCoc.text = hopdong.SoTienCoc.toNumberString(decimal: false)
        lblNgayBatDau.text = hopdong.NgayBD.formatDate()
        lblNgayKetThuc.text = hopdong.NgayKT.formatDate()

        if !hopdong.active {
            lblTrangThaiHD.text = "Hết thời hạn"
            lblTrangThaiHD.textColor = UIColor.red
        }else {
            lblTrangThaiHD.text = "Còn thời hạn"
            lblTrangThaiHD.textColor = UIColor.black
        }
    }

   
    
    @IBAction func eventClickShowHopDong(_ sender: Any) {
        if let delegate = self.delegate {
            delegate.eventShowHopDong?(self.index)
        }

    }
    

}
