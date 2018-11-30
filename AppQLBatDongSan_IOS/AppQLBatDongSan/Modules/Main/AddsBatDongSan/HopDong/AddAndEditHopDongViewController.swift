//
//  AddListBatDongSanViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 11/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import SVProgressHUD
import SwiftyJSON

class AddAndEditHopDongViewController: UIViewController {
    @IBOutlet weak var cbbCanHo: MyCombobox!
    
    @IBOutlet weak var tfTenKH: MyTextField!

    @IBOutlet weak var cbbGioiTinh: MyCombobox!
    @IBOutlet weak var tfSDT: MyTextField!
    @IBOutlet weak var cbbDichVu: MyCombobox!
    
    @IBOutlet weak var tfGhiChu: UITextView!
    @IBOutlet weak var tfTienCoc: MyNumberField!
    @IBOutlet weak var btnNgayKTCalendar: MyButtonCalendar!
    @IBOutlet weak var btnNgayBatDauCalendar: MyButtonCalendar!
    @IBOutlet weak var tfEmailKH: MyTextField!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    var listCanHo: [CanHo] = []
    var listDichVu: [DichVu] = []
    var isCreateNew: Bool = true
    var hopdong: HopDong? = nil
    var listGioiTinh: [String] = ["Nam", "Nữ"]
    var done: ((_ hopdong: HopDong)->())?
    
      let manager = Alamofire.SessionManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        listCanHo = Storage.shared.getObjects(type: CanHo.self) as! [CanHo]
        listDichVu = Storage.shared.getObjects(type: DichVu.self) as! [DichVu]
//        cbbDichVu.setOptions(self.listDichVu.map({ $0.TenDichVu}), placeholder: nil, selectedIndex: nil)
//        cbbDichVu.isMultipleSelection = true
//        cbbDichVu.delegate = self
        customized()
        binding() 
      
    }
    
    func binding() {
        labelHeaderTitle.text = isCreateNew == true ? "Tạo hợp đồng" : "Sửa hợp đồng"
        if !isCreateNew {
            tfTenKH.text = self.hopdong?.ChuHopDong
            if let index = self.listCanHo.index(where: { $0.IdCanHo == self.hopdong?.IdCanHo}) {
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.TenCanHo}), placeholder: nil, selectedIndex: index)
            }
            let gioitinh = self.hopdong?.GioiTinh == "1" ? "Nam" : "Nữ"
            if let index = self.listGioiTinh.index(where: { $0 == gioitinh}) {
                self.cbbGioiTinh.setOptions(self.listGioiTinh.map({$0}), placeholder: nil, selectedIndex: index)
            }
            tfSDT.text = hopdong?.SDTKhachHang
            tfEmailKH.text = hopdong?.emailKhachHang
            btnNgayBatDauCalendar.date = hopdong?.NgayBD.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            btnNgayKTCalendar.date = hopdong?.NgayKT.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            tfTienCoc.setValue(hopdong?.SoTienCoc)
            tfGhiChu.text = hopdong?.GhiChu
        } else {
            self.cbbCanHo.setOptions(self.listCanHo.map({$0.TenCanHo}), placeholder: nil, selectedIndex: nil)
            self.cbbGioiTinh.setOptions(listGioiTinh, placeholder: nil, selectedIndex: 0)
            btnNgayBatDauCalendar.date = Date()
            btnNgayKTCalendar.date = Date()
        }
    }
    
    func customized() {
        btnNgayBatDauCalendar.layer.cornerRadius = 6.0
        btnNgayBatDauCalendar.layer.borderColor = UIColor.gray.cgColor
        btnNgayBatDauCalendar.layer.borderWidth = 1.0
        
        btnNgayKTCalendar.layer.cornerRadius = 6.0
        btnNgayKTCalendar.layer.borderColor = UIColor.gray.cgColor
        btnNgayKTCalendar.layer.borderWidth = 1.0
        
        tfGhiChu.layer.cornerRadius = 6.0
        tfGhiChu.layer.borderColor = UIColor.gray.cgColor
        tfGhiChu.layer.borderWidth = 1.0
        
        self.cbbCanHo.delegate = self
        tfTienCoc?.setAsNumericKeyboard(type: .money, autoSelectAll: true)
          viewBody.layer.cornerRadius = 6.0
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
    
    @IBAction func eventChooseDateNgayBd(_ sender: Any) {
        guard let btn = sender as? MyButtonCalendar else { return  }
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = btn.date
        picker.addTarget(self, action: #selector(pickerChangedDateNgayBd), for: .valueChanged)
        let controller = UIViewController()
        controller.view = picker
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: Global.screenSize.width/3, height: Global.screenSize.height/3)
        controller.popoverPresentationController?.sourceView = btn
        controller.popoverPresentationController?.sourceRect = btn.bounds
        controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @IBAction func eventChooseDateNgayKt(_ sender: Any) {
        guard let btn = sender as? MyButtonCalendar else { return  }
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = btn.date
        picker.addTarget(self, action: #selector(pickerChangedDateNgayKt), for: .valueChanged)
        let controller = UIViewController()
        controller.view = picker
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: Global.screenSize.width/3, height: Global.screenSize.height/3)
        controller.popoverPresentationController?.sourceView = btn
        controller.popoverPresentationController?.sourceRect = btn.bounds
        controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @objc func pickerChangedDateNgayBd(picker: UIDatePicker) {
        btnNgayBatDauCalendar.date = picker.date
    }
    
    @objc func pickerChangedDateNgayKt(picker: UIDatePicker) {
        btnNgayKTCalendar.date = picker.date
    }
    
    @IBAction func eventClickOutSide(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eventClickHuyKH(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func eventClickTaoKH(_ sender: Any) {
        let hopdong = HopDong()
        guard tfTenKH.text != "" && tfTienCoc.text != "" && tfEmailKH.text != "" && tfSDT.text != "" else {
            if tfTenKH.text == "" {
                tfTenKH.warning()
            }
            if tfTienCoc.text == "" {
                tfTienCoc.warning()
            }
            if tfEmailKH.text == "" {
                tfEmailKH.warning()
            }
            if tfSDT.text == "" {
                tfSDT.warning()
            }
            Notice.make(type: .Error, content: "Không được để rỗng hãy kiểm tra lại").show()
            return
            
        }
        hopdong.idHopDong = isCreateNew ? "" : self.hopdong?.idHopDong ?? ""
        hopdong.ChuHopDong = tfTenKH.text ?? ""
        hopdong.SoTienCoc = "\(tfTienCoc.getValue())"
        hopdong.NgayBD = "\(btnNgayBatDauCalendar.date)"
        hopdong.NgayKT = "\(btnNgayKTCalendar.date)"
        hopdong.GhiChu = tfGhiChu.text
        hopdong.GioiTinh = self.listGioiTinh[cbbGioiTinh.selectedIndex ?? 0 ] == "Nam" ? "1" : "0"
        hopdong.SDTKhachHang = tfSDT.text ?? ""
        hopdong.emailKhachHang = tfEmailKH.text ?? ""
        if let index = cbbCanHo.selectedIndex{
            hopdong.IdCanHo = "\(listCanHo[index].IdCanHo)"
        } else {
            cbbCanHo.warning()
            Notice.make(type: .Error, content: "Chưa chọn Căn hộ, làm ơn hãy chọn ").show()
            return
        }
        let parameters: [String: String] = [
            "idHopDong" : hopdong.idHopDong,
            "ChuHopDong" : hopdong.ChuHopDong,
            "idCanHo" : hopdong.IdCanHo ,
            "SoTienCoc" : hopdong.SoTienCoc,
            "NgayBD" : hopdong.NgayBD.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "NgayKT" : hopdong.NgayKT.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "GhiChu" : hopdong.GhiChu,
            "GioiTinh" : hopdong.GioiTinh,
            "SDTKhachHang" : hopdong.SDTKhachHang,
            "EmailKhachHang" : hopdong.emailKhachHang,
        ]
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/HopDong/AddHopDong", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let hopdongResponse  = HopDong.init(json: json)
                    if let hopdongCopy = hopdongResponse.copy() as? HopDong{
                        Storage.shared.addOrUpdate([hopdongCopy], type: HopDong.self)
                    }
                    Notice.make(type: .Success, content: "Thêm mới hoá đơn thành công! ").show()
                    self.done?(hopdongResponse)
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/HopDong/EditHopDong", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let hopdongResponse  = HopDong.init(json: json)
                    if let hopdongCopy = hopdongResponse.copy() as? HopDong{
                        Storage.shared.addOrUpdate([hopdongCopy], type: HopDong.self)
                    }
                    Notice.make(type: .Success, content: "Sửa mới hoá đơn thành công! ").show()
                    self.done?(hopdongResponse)
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        }
    }
}

extension AddAndEditHopDongViewController: MyComboboxDelegate {
    
}
