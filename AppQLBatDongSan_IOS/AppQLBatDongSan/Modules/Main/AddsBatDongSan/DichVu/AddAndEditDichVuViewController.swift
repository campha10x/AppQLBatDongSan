//
//  AddAndEditDichVuViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 11/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class AddAndEditDichVuViewController: UIViewController {

    @IBOutlet weak var tfTenDV: MyTextField!
    @IBOutlet weak var tfDonGia: MyNumberField!
    @IBOutlet weak var cbbDonVi: MyCombobox!
    @IBOutlet weak var checboxMacDinh: MyCheckbox!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    @IBOutlet weak var viewBody: UIView!
    var isCreateNew: Bool = true
    var dichvu: DichVu? = nil
    var done: (()->())?
    
    var listDonVi: [DonVi] = []
    
    override func viewDidLoad() {
        labelHeaderTitle.text = isCreateNew == true ? "Tạo dịch vụ" : "Sửa dịch vụ"
        listDonVi = Storage.shared.getObjects(type: DonVi.self) as! [DonVi]
        if !isCreateNew {
            tfTenDV.text = dichvu?.TenDichVu
            tfDonGia.setValue(dichvu?.DonGia ?? "0")
            if let index = listDonVi.index(where: {$0.idDonVi == self.dichvu?.idDonvi}) {
                cbbDonVi.setOptions(listDonVi.map({$0.TenDonVi}), placeholder: nil, selectedIndex: index)
            } else {
                cbbDonVi.setOptions(listDonVi.map({$0.TenDonVi}), placeholder: nil, selectedIndex: nil)
            }
            checboxMacDinh.isSelected = dichvu?.MacDinh == "1" ? true : false
        } else {
            checboxMacDinh.isSelected = true
            cbbDonVi.setOptions(listDonVi.map({$0.TenDonVi}), placeholder: nil, selectedIndex: nil)
        }
        tfDonGia.setAsNumericKeyboard(type: .money, autoSelectAll: false)
         viewBody.layer.cornerRadius = 6.0
    }
    
    @IBAction func tao(_ sender: Any) {
        let dichvu = DichVu()
        dichvu.idDichVu = isCreateNew ? "\(dichvu.IncrementaID())" : self.dichvu?.idDichVu ?? ""
        dichvu.TenDichVu = tfTenDV.text!
        if let selectedIndex = self.cbbDonVi.selectedIndex {
            dichvu.idDonvi = listDonVi[selectedIndex].idDonVi
        } else {
            dichvu.idDonvi = ""
        }
        dichvu.DonGia = tfDonGia.getValueString()
        dichvu.MacDinh = checboxMacDinh.isSelected == true ? "1" : "0"
        Storage.shared.addOrUpdate([dichvu], type: DichVu.self)
        if isCreateNew {
            Notice.make(type: .Success, content: "Thêm mới dịch vụ thành công! ").show()
        } else {
            Notice.make(type: .Success, content: "Sửa dịch vụ thành công! ").show()
        }
        done?()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func huy(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchOutSide(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
