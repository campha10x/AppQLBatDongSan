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
    
    static let id = "QLHopDongTableViewCell"
    var index: Int = -1
    
    var listCanHo: [CanHo] = Storage.shared.getObjects(type: CanHo.self) as! [CanHo]
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func eventEdit(_ sender: Any) {
        delegate?.eventEdit(self.index)
    }
    
    @IBAction func eventRemove(_ sender: Any) {
        delegate?.eventRemove(self.index)
    }
    
    func binding(hopdong: HopDong, index: Int )  {
        self.index = index
        let tenCanHo = listCanHo.filter({$0.IdCanHo == hopdong.IdCanHo }).first?.TenCanHo ?? "None"
        lblMaHopDong.text = hopdong.idHopDong
        lblChuHopDong.text = hopdong.ChuHopDong
        lblCanHo.text = tenCanHo
        lblSoTienCoc.text = hopdong.SoTienCoc.toNumberString(decimal: false)
        lblNgayBatDau.text = hopdong.NgayBD.formatDate()
        lblNgayKetThuc.text = hopdong.NgayKT.formatDate()
    }



}
