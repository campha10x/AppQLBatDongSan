//
//  AddAndEditHoaDonViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 11/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class AddAndEditHoaDonViewController: UIViewController {

    @IBOutlet weak var cbbCanHo: MyCombobox!
    @IBOutlet weak var tfSoPhieu: MyTextField!
    @IBOutlet weak var tfSotien: MyNumberField!
    @IBOutlet weak var btnNgayTao: MyButtonCalendar!
    @IBOutlet weak var btnTao: MySolidButton!
    @IBOutlet weak var viewBody: UIView!
    
    @IBOutlet weak var tfSoDienMoi: MyNumberField!
    @IBOutlet weak var tfSoNuocMoi: MyNumberField!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    var listCanHo: [CanHo] = []
    var isCreateNew: Bool = true
    var hoadon: HoaDon? = nil
    var done: ((_ hoadon: HoaDon)->())?
    let manager = Alamofire.SessionManager()
    var soTien: Double = 0.0
    
    var selectedDichVu: [DichVu] = []
    var indexCanHo = -1
    
    var listDichVu: [DichVu] = []
    var listDichVu_CanHo: [CanHo_DichVu] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        listDichVu = Storage.shared.getObjects(type: DichVu.self) as! [DichVu]
        listDichVu_CanHo = Storage.shared.getObjects(type: CanHo_DichVu.self) as! [CanHo_DichVu]
        customized()
        configService()
        if !isCreateNew {
            tfSoPhieu.text = self.hoadon?.soPhieu
            if let index = self.listCanHo.index(where: { $0.IdCanHo == self.hoadon?.IdCanHo}) {
                tfSoDienMoi.text = self.hoadon?.soDienMoi
                tfSoNuocMoi.text = self.hoadon?.soNuocMoi
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.TenCanHo}), placeholder: nil, selectedIndex: index)
            }
            btnNgayTao.date = hoadon?.ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            tfSotien.setValue(hoadon?.soTien)
            tfSoDienMoi.setValue(hoadon?.soDienMoi)
            tfSoNuocMoi.setValue(hoadon?.soNuocMoi)
            btnTao.setTitle("Sửa hoá đơn", for: .normal)
        } else {
            tfSoDienMoi.setValue(0.0)
            tfSoNuocMoi.setValue(0.0)
            tfSoPhieu.text = "SPHD-\(randomNumber(inRange: 100...50000))"
            self.cbbCanHo.setOptions(self.listCanHo.map({$0.TenCanHo}), placeholder: nil, selectedIndex: nil)
            btnNgayTao.date = Date()
            btnTao.setTitle("Tạo hoá đơn", for: .normal)
        }
        tfSoDienMoi.delegate = self
        tfSoNuocMoi.delegate = self
        tfSotien.isEnabled = false
        tfSoPhieu.isEnabled = false
         viewBody.layer.cornerRadius = 6.0
    }
    
    func customized()  {
        listCanHo = Storage.shared.getObjects(type: CanHo.self) as! [CanHo]
        self.cbbCanHo.delegate = self
        tfSotien?.setAsNumericKeyboard(type: .money, autoSelectAll: true)
        tfSoDienMoi.setAsNumericKeyboard(type: .integer, autoSelectAll: true)
        tfSoNuocMoi.setAsNumericKeyboard(type: .integer, autoSelectAll: true)
        labelHeaderTitle.text = isCreateNew == true ? "Tạo hoá đơn" : "Sửa hoá đơn"
        
        btnNgayTao.layer.cornerRadius = 6.0
        btnNgayTao.layer.borderColor = UIColor.gray.cgColor
        btnNgayTao.layer.borderWidth = 1.0
        tfSoPhieu.isEnabled = false
    }
    
    func configService() {
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: (challenge.protectionSpace.serverTrust ?? nil)!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = self.manager.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            
            return (disposition, credential)
        }
    }
    
    public func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
        let length = Int64(range.upperBound - range.lowerBound + 1)
        let value = Int64(arc4random()) % length + Int64(range.lowerBound)
        return T(value)
    }
    
    @IBAction func eventClickOutSide(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eventChooseDate(_ sender: Any) {
        guard let btn = sender as? MyButtonCalendar else { return  }
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = btn.date
        picker.addTarget(self, action: #selector(pickerChangedDate), for: .valueChanged)
        let controller = UIViewController()
        controller.view = picker
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: Global.screenSize.width/3, height: Global.screenSize.height/3)
        controller.popoverPresentationController?.sourceView = btn
        controller.popoverPresentationController?.sourceRect = btn.bounds
        controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @objc func pickerChangedDate(picker: UIDatePicker) {
        btnNgayTao.date = picker.date
    }
    
    @IBAction func eventClickHuyHD(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eventClickTaoHD(_ sender: Any) {
        if let soDienCu: Double = Double(self.listCanHo[indexCanHo].SoDienCu), let SoNuocCu: Double = Double(self.listCanHo[indexCanHo].SoNuocCu) {
            if soDienCu > tfSoDienMoi.getValue() {
                tfSoDienMoi.warning()
                Notice.make(type: .Error, content: "Số điện mới phải lớn hơn số điện cũ của căn hộ đó ").show()
                return
            } else if SoNuocCu > tfSoNuocMoi.getValue() {
                tfSoNuocMoi.warning()
                Notice.make(type: .Error, content: "Số nước mới phải lớn hơn số nước cũ của căn hộ đó ").show()
                return
            }
            tfSoDienMoi.borderColor = UIColor.gray.withAlphaComponent(0.8)
            tfSoNuocMoi.borderColor = UIColor.gray.withAlphaComponent(0.8)
        }
        
        let hoadon = HoaDon()
        guard tfSotien.text != ""  else {
            if tfSotien.text == "" {
                tfSotien.warning()
            }
            Notice.make(type: .Error, content: "Không được để rỗng hãy kiểm tra lại").show()
            return
        }
        
        hoadon.idHoaDon = isCreateNew ? "" : self.hoadon?.idHoaDon ?? ""
        hoadon.soTien = "\(tfSotien.getValueString())"
        hoadon.soPhieu = tfSoPhieu.text ?? ""
        hoadon.ngayTao = "\(btnNgayTao.date)"
        hoadon.soDienMoi = tfSoDienMoi.getValueString()
        hoadon.soNuocMoi = tfSoNuocMoi.getValueString()
        if let index = cbbCanHo.selectedIndex{
            hoadon.IdCanHo = "\(listCanHo[index].IdCanHo)"
        } else {
            cbbCanHo.warning()
            Notice.make(type: .Error, content: "Chưa chọn phòng, làm ơn hãy chọn ").show()
            return
        }
        
        let parameters: [String: String] = [
            "IdHoaDon" : hoadon.idHoaDon,
            "IdCanHo" : hoadon.IdCanHo ,
            "SoPhieu" : hoadon.soPhieu,
            "NgayTao" : hoadon.ngayTao.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "SoTien" : hoadon.soTien,
            "SoDienMoi" : hoadon.soDienMoi,
            "SoNuocMoi" : hoadon.soNuocMoi
        ]
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/HoaDon/AddListHoaDon", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let hoadonResponse  = HoaDon.init(json: json)
                    if let hoadonCopy = hoadonResponse.copy() as? HoaDon{
                        Storage.shared.addOrUpdate([hoadonCopy], type: HoaDon.self)
                    }
                    Notice.make(type: .Success, content: "Thêm mới hoá đơn thành công! ").show()
                    self.updateSoDienSoNuocCanHo(IdCanHo: hoadonResponse.IdCanHo)
                    self.done?(hoadonResponse)
                    
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/HoaDon/EditListHoaDon", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let hoadonResponse  = HoaDon.init(json: json)
                    if let hoadonCopy = hoadonResponse.copy() as? HoaDon{
                        Storage.shared.addOrUpdate([hoadonCopy], type: HoaDon.self)
                    }
                    Notice.make(type: .Success, content: "Sửa mới hoá đơn thành công! ").show()
                    self.updateSoDienSoNuocCanHo(IdCanHo: hoadonResponse.IdCanHo)
                    self.done?(hoadonResponse)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        }
    }
    
    func updateSoDienSoNuocCanHo(IdCanHo: String)  {
        let parameters: [String: String] = [
                        "IdCanHo" : IdCanHo,
                         "SoDienCu" : "\(tfSoDienMoi.getValue())",
                         "SoNuocCu": "\(tfSoNuocMoi.getValue())"
                        ]
        
        SVProgressHUD.show()
        self.manager.request("https://localhost:5001/HoaDon/UpDateSoDienNuocCanHo", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                if let canhoObjects: CanHo = self.listCanHo.filter({$0.IdCanHo == IdCanHo}).first?.copy() as! CanHo{
                    canhoObjects.SoDienCu  = self.tfSoDienMoi.getValueString()
                    canhoObjects.SoNuocCu = self.tfSoNuocMoi.getValueString()
                    Storage.shared.addOrUpdate([canhoObjects], type: CanHo.self)
                }
                self.dismiss(animated: true, completion: nil)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
        
    }
    
    func recaculatorSoTien () {
        soTien = 0
        if indexCanHo >= 0 {
            soTien += Double(self.listCanHo[indexCanHo].DonGia) ?? 0
            
            let selectedDichVu  = listDichVu_CanHo.filter({ $0.IdCanHo == self.listCanHo[indexCanHo].IdCanHo }).first?.IdDichVu.split(separator: ",")
            let caculatorDichVu = self.listDichVu.filter { (item) -> Bool in
                return selectedDichVu?.filter({ $0 == item.idDichVu}).first != nil
            }
            soTien += caculatorDichVu.reduce(0.0, { $0 + (Double($1.DonGia) ?? 0) })
            if let soDienCu: Double = Double(self.listCanHo[indexCanHo].SoDienCu), let SoNuocCu: Double = Double(self.listCanHo[indexCanHo].SoNuocCu) {
                soTien += (( tfSoDienMoi.getValue() - soDienCu) * 3500 + (tfSoNuocMoi.getValue() - SoNuocCu ) * 20000)
                tfSotien.setValue(soTien)
            }
        } else {
            Notice.make(type: .Error, content: "Bạn phải nhập căn hộ mới tính tiền được").show()
        }

    }

}

extension AddAndEditHoaDonViewController :MyComboboxDelegate{
    func mycombobox(_ cbb: MyCombobox, selectedAt index: Int) {
        if index < self.listCanHo.count {
            self.indexCanHo = index
            recaculatorSoTien()
        }
    }
}


extension AddAndEditHoaDonViewController :UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        recaculatorSoTien()
    }
}
