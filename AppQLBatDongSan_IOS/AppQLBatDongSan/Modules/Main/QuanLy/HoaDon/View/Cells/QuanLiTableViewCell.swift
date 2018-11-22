//
//  QuanLiTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 9/30/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class QuanLiTableViewCell: UITableViewCell {

    static let height = 70
    var index:Int?
    
    var onChiTietHoaDon: ((_ index: Int) -> ())?
    var onMoney: ((_ index: Int) -> ())?
    var onRemove: ((_ index: Int) -> ())?

    @IBOutlet weak var labelPhong: UILabel!
    @IBOutlet weak var labelSoPhieu: UILabel!
    @IBOutlet weak var labelNgayTao: UILabel!
    @IBOutlet weak var labelSoTien: UILabel!
    @IBOutlet weak var labelSoTienTra: UILabel!
    @IBOutlet weak var labelConlai: UILabel!
    
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonMoney: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        [buttonDelete, buttonEdit, buttonDelete, buttonMoney].forEach({ $0?.layer.borderColor = UIColor.lightGray.cgColor})
        
        [buttonDelete, buttonEdit, buttonDelete, buttonMoney].forEach({ $0?.layer.borderWidth = 1.0 })
        [buttonDelete, buttonEdit, buttonDelete, buttonMoney].forEach({ $0?.layer.cornerRadius = MyUI.buttonCornerRadius })
        buttonDelete.backgroundColor = UIColor.red
    }

    func bindding(index: Int, obj: HoaDon, datra: Int, tenphong: String) {
        self.index = index
        labelPhong.text = tenphong
        labelSoPhieu.text = obj.soPhieu
        labelNgayTao.text = obj.ngayTao.formatDate()
        labelSoTien.text = obj.soTien.toNumberString(decimal: false)
        labelSoTienTra.text = "\(datra)".toNumberString(decimal: false)
        let conlai = (Double(obj.soTien) ?? 0.0) - Double(datra)
        labelConlai.text = "\(conlai)".toNumberString(decimal: false)
        self.buttonMoney.isEnabled = conlai == 0 ? false : true
        self.buttonEdit.isEnabled = conlai == 0 ? false : true
        self.backgroundColor = conlai == 0 ?  UIColor.gray : UIColor.white
    }
    

    
    @IBAction func eventRemove(_ sender: Any) {
        onRemove?(self.index ?? 0)
    }
    
    
    @IBAction func eventEdit(_ sender: Any) {
        onChiTietHoaDon?(self.index ?? 0)
    }
    
    
    @IBAction func eventMoney(_ sender: Any) {
        onMoney?(self.index ?? 0 )
    }
    
}
