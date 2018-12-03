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
    
    @IBOutlet weak var tfTenChuHD: MyTextField!

    @IBOutlet weak var cbbTenKH: MyCombobox!
    @IBOutlet weak var cbbDichVu: MyCombobox!
    
    @IBOutlet weak var tfGhiChu: UITextView!
    @IBOutlet weak var tfTienCoc: MyNumberField!
    @IBOutlet weak var btnNgayKTCalendar: MyButtonCalendar!
    @IBOutlet weak var btnNgayBatDauCalendar: MyButtonCalendar!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    var listCanHo: [CanHo] = []
    var listDichVu: [DichVu] = []
    var listKhachHang: [KhachHang] = []
    
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
        listKhachHang = Storage.shared.getObjects(type: KhachHang.self) as! [KhachHang]
//        cbbDichVu.setOptions(self.listDichVu.map({ $0.TenDichVu}), placeholder: nil, selectedIndex: nil)
//        cbbDichVu.isMultipleSelection = true
//        cbbDichVu.delegate = self
        customized()
        binding() 
      
    }
    
    func binding() {
        labelHeaderTitle.text = isCreateNew == true ? "Tạo hợp đồng" : "Sửa hợp đồng"
        let accounts = Storage.shared.getObjects(type: Account.self) as! [Account]
        tfTenChuHD.text = accounts.filter({ $0.email == AppState.shared.getAccount()}).first?.hoten ?? ""
        if !isCreateNew {
            tfTenChuHD.text = self.hopdong?.ChuHopDong
            if let index = self.listCanHo.index(where: { $0.IdCanHo == self.hopdong?.IdCanHo}) {
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.TenCanHo}), placeholder: nil, selectedIndex: index)
            } else {
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.TenCanHo}), placeholder: nil, selectedIndex: nil)
            }
            if let index = self.listKhachHang.index(where: { $0.idKhachHang
                == self.hopdong?.IdKhachHang}) {
                self.cbbTenKH.setOptions(self.listKhachHang.map({$0.TenKH}), placeholder: nil, selectedIndex: index)
            } else {
                 self.cbbTenKH.setOptions(self.listKhachHang.map({$0.TenKH}), placeholder: nil, selectedIndex: nil)
            }
            btnNgayBatDauCalendar.date = hopdong?.NgayBD.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            btnNgayKTCalendar.date = hopdong?.NgayKT.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            tfTienCoc.setValue(hopdong?.SoTienCoc)
            tfGhiChu.text = hopdong?.GhiChu
        } else {
            self.cbbCanHo.setOptions(self.listCanHo.map({$0.TenCanHo}), placeholder: nil, selectedIndex: nil)
            self.cbbTenKH.setOptions(self.listKhachHang.map({$0.TenKH}), placeholder: nil, selectedIndex: nil)
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
        tfTenChuHD.isEnabled = false
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
        guard tfTenChuHD.text != "" && tfTienCoc.text != "" && cbbTenKH.selectedIndex != nil  else {
            if tfTenChuHD.text == "" {
                tfTenChuHD.warning()
            }
            if tfTienCoc.text == "" {
                tfTienCoc.warning()
            }
            if cbbTenKH.selectedIndex == nil {
                cbbTenKH.warning()
            }
            cbbTenKH.warning()
            Notice.make(type: .Error, content: "Không được để rỗng hãy kiểm tra lại").show()
            return
            
        }
        hopdong.idHopDong = isCreateNew ? "" : self.hopdong?.idHopDong ?? ""
        hopdong.ChuHopDong = tfTenChuHD.text ?? ""
        hopdong.SoTienCoc = "\(tfTienCoc.getValue())"
        hopdong.NgayBD = "\(btnNgayBatDauCalendar.date)"
        hopdong.NgayKT = "\(btnNgayKTCalendar.date)"
        hopdong.GhiChu = tfGhiChu.text
        
        if let index = cbbTenKH.selectedIndex{
            hopdong.IdKhachHang = "\(listKhachHang[index].idKhachHang)"
        }
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
            "IdKhachHang" : hopdong.IdKhachHang
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
