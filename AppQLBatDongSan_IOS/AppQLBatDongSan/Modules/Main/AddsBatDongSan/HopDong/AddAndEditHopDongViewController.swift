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
    
    @IBOutlet weak var cbbDichVu: MyCombobox!
    
    @IBOutlet weak var tfGhiChu: UITextView!
    @IBOutlet weak var tfTienCoc: MyNumberField!
    @IBOutlet weak var btnNgayKTCalendar: MyButtonCalendar!
    @IBOutlet weak var btnNgayBatDauCalendar: MyButtonCalendar!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    @IBOutlet weak var tfTenKhachHang: MyTextField!
    @IBOutlet weak var tfCMND: MyNumberField!
    @IBOutlet weak var btnNgayCap: MyButtonCalendar!
    @IBOutlet weak var tfNoiCap: MyTextField!
    @IBOutlet weak var tfSdt: MyNumberField!
    
    @IBOutlet weak var tfSoDien: MyNumberField!
    @IBOutlet weak var tfSoNuoc: MyNumberField!
    @IBOutlet weak var tfGiaNuoc: MyNumberField!
    @IBOutlet weak var tfGiaDien: MyNumberField!
    
    @IBOutlet weak var listSelectedDichVu: MyServiceGroupView!
    @IBOutlet weak var constraintHeightDichVu: NSLayoutConstraint!
    
    var listCanHo: [CanHo] = []
    var listKhachHang: [KhachHang] = []
    var isCreateNew: Bool = true
    var hopdong: HopDong? = nil
    var khachHang: KhachHang? = nil
    
    var idDidKhachHangInHopDong: Int? = nil
    var done: ((_ hopdong: HopDong)->())?
    
    let manager = Alamofire.SessionManager()
    
    var dicsDichVu: [Int: (text: String, number: Double)] = [:]
    var listDichVu_CanHo: [CanHo_DichVu] = []
     var listDichVu: [DichVu] = []
    var listDichVu_HopDong: [HopDong_DichVu] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        cbbCanHo.textColor = MyColor.black
        cbbCanHo.dropdownBackgroundColor = MyColor.cyan
        cbbCanHo.dropdownBackgroundSelectedColor = MyColor.cyanHover
        cbbCanHo.dropdownForcegroundColor = .white
        
        configService()
        listCanHo = Storage.shared.getObjects(type: CanHo.self) as! [CanHo]
        listKhachHang = Storage.shared.getObjects(type: KhachHang.self) as! [KhachHang]
        listDichVu_HopDong = Storage.shared.getObjects(type: HopDong_DichVu.self) as! [HopDong_DichVu]
        listDichVu_CanHo = Storage.shared.getObjects(type: CanHo_DichVu.self) as! [CanHo_DichVu]
        listDichVu = Storage.shared.getObjects(type: DichVu.self) as! [DichVu]
        customized()
        binding() 
        tfCMND.textfieldDelegate = self
    }
    
    func binding() {
        labelHeaderTitle.text = isCreateNew == true ? "Tạo hợp đồng" : "Sửa hợp đồng"
        let accounts = Storage.shared.getObjects(type: Account.self) as! [Account]
        tfTenChuHD.text = accounts.filter({ $0.email == AppState.shared.getAccount()}).first?.hoten ?? ""
        if !isCreateNew {
            tfTenChuHD.text = self.hopdong?.ChuHopDong
            if let index = self.listCanHo.index(where: { $0.IdCanHo == self.hopdong?.IdCanHo}) {
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.maCanHo}), placeholder: nil, selectedIndex: index)
            } else {
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.maCanHo}), placeholder: nil, selectedIndex: nil)
            }
            btnNgayBatDauCalendar.date = hopdong?.NgayBD.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            btnNgayKTCalendar.date = hopdong?.NgayKT.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            tfTienCoc.setValue(hopdong?.SoTienCoc)
            tfGhiChu.text = hopdong?.GhiChu
            khachHang = self.listKhachHang.filter({ $0.idKhachHang == hopdong?.IdKhachHang}).first
            tfTenKhachHang.text = khachHang?.TenKH ?? ""
            tfCMND.setValue(khachHang?.CMND ?? "")
            btnNgayCap.date = khachHang?.NgayCap.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            tfNoiCap.text = khachHang?.NoiCap ?? ""
            tfSdt.setValue(khachHang?.SDT)
            tfSoDien.setValue(hopdong?.SoDienBd)
            tfSoNuoc.setValue(hopdong?.SoNuocBd)
            tfGiaDien.setValue(hopdong?.TienDien)
            tfGiaNuoc.setValue(hopdong?.TienNuoc)
            
        } else {
            self.cbbCanHo.setOptions(self.listCanHo.map({$0.maCanHo}), placeholder: nil, selectedIndex: nil)
            btnNgayBatDauCalendar.date = Date()
            btnNgayKTCalendar.date = Date()
            btnNgayCap.date = Date()
            tfSdt.setValue(0.0)
            tfCMND.setValue(0.0)
            tfSoDien.setValue(0.0)
            tfSoNuoc.setValue(0.0)
            tfGiaDien.setValue(0.0)
            tfGiaNuoc.setValue(0.0)

        }
    }
    
    func customized() {
        btnNgayBatDauCalendar.layer.cornerRadius = 6.0
        btnNgayBatDauCalendar.layer.borderColor = UIColor.gray.cgColor
        btnNgayBatDauCalendar.layer.borderWidth = 1.0
        
        btnNgayKTCalendar.layer.cornerRadius = 6.0
        btnNgayKTCalendar.layer.borderColor = UIColor.gray.cgColor
        btnNgayKTCalendar.layer.borderWidth = 1.0
        
        btnNgayCap.layer.cornerRadius = 6.0
        btnNgayCap.layer.borderColor = UIColor.gray.cgColor
        btnNgayCap.layer.borderWidth = 1.0
        
        tfGhiChu.layer.cornerRadius = 6.0
        tfGhiChu.layer.borderColor = UIColor.gray.cgColor
        tfGhiChu.layer.borderWidth = 1.0
        
        self.cbbCanHo.delegate = self
        tfTienCoc?.setAsNumericKeyboard(type: .money, autoSelectAll: true)
        tfCMND.isRemoveComma = true
        tfSdt.isRemoveComma = true
        tfCMND?.setAsNumericKeyboard(type: .integer, autoSelectAll: true)
        tfSdt?.setAsNumericKeyboard(type: .integer, autoSelectAll: true)
        
        tfSoDien?.setAsNumericKeyboard(type: .integer, autoSelectAll: true)
        tfSoNuoc?.setAsNumericKeyboard(type: .integer, autoSelectAll: true)
        tfGiaDien.setAsNumericKeyboard(type: .money, autoSelectAll: true)
        tfGiaNuoc.setAsNumericKeyboard(type: .money, autoSelectAll: true)
        
        tfSoDien.isRemoveComma = true
        tfSoNuoc.isRemoveComma = true
        
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
    
    @IBAction func eventChooseDateNgayCap(_ sender: Any) {
        guard let btn = sender as? MyButtonCalendar else { return  }
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = btn.date
        picker.addTarget(self, action: #selector(pickerChangedDateNgayCap), for: .valueChanged)
        let controller = UIViewController()
        controller.view = picker
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: Global.screenSize.width/3, height: Global.screenSize.height/3)
        controller.popoverPresentationController?.sourceView = btn
        controller.popoverPresentationController?.sourceRect = btn.bounds
        controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        self.present(controller, animated: true, completion: nil)
        
    }
    
    @objc func pickerChangedDateNgayCap(picker: UIDatePicker) {
        btnNgayCap.date = picker.date
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
        let khachHangObject = KhachHang()
        guard tfTenKhachHang.text != "" && tfCMND.text != "" && tfNoiCap.text != ""  else {
            if tfTenKhachHang.text == "" {
                tfTenKhachHang.warning()
            }
            if tfCMND.text == "" {
                tfCMND.warning()
            }
            if tfNoiCap.text == "" {
                tfNoiCap.warning()
            }
            Notice.make(type: .Error, content: "Không được để rỗng hãy kiểm tra lại").show()
            return
            
        }
        
        if idDidKhachHangInHopDong == nil {
            if !isCreateNew {
                khachHangObject.NgaySinh = self.khachHang?.NgaySinh.formatDate(date: "MM/dd/yyyy HH:mm:ss", dateTo: "YYYY-MM-dd") ?? ""
                khachHangObject.GioiTinh = self.khachHang?.GioiTinh ?? ""
                khachHangObject.Email = self.khachHang?.Email ?? ""
                khachHangObject.Quequan = self.khachHang?.Quequan ?? ""
            } else {
                khachHangObject.NgaySinh = "\(Date())".formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd")
                khachHangObject.GioiTinh = "1"
                khachHangObject.Email = "None"
                khachHangObject.Quequan = "None"
            }
            
            
            khachHangObject.idKhachHang = isCreateNew ? "" : self.khachHang?.idKhachHang ?? ""
            khachHangObject.CMND = "\(Int(tfCMND.getValue()))"
            khachHangObject.NgayCap = "\(btnNgayCap.date)"
            khachHangObject.NoiCap = tfNoiCap.text ?? ""
            khachHangObject.SDT =  "\(Int(tfSdt.getValue()))"
            khachHangObject.TenKH = tfTenKhachHang.text ?? ""
            if let index = cbbCanHo.selectedIndex {
                khachHangObject.IdCanHo = self.listCanHo[index].IdCanHo
            }
            
            
            let parameters: [String: String] = [
                "IdKhachHang": khachHangObject.idKhachHang,
                "TenKH" : khachHangObject.TenKH,
                "IdCanHo" : khachHangObject.IdCanHo,
                "CMND" : khachHangObject.CMND ,
                "NgayCap" : khachHangObject.NgayCap.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
                "NoiCap" : khachHangObject.NoiCap,
                "SDT" : khachHangObject.SDT
            ]
            
            if isCreateNew {
                SVProgressHUD.show()
                self.manager.request("https://localhost:5001/KhachHang/AddKhachHang", method: .post, parameters: parameters, encoding: JSONEncoding.default ).responseJSON { (responseObject) in
                    SVProgressHUD.dismiss()
                    do {
                        let json: JSON = try JSON.init(data: responseObject.data! )
                        let khachHangResponse  = KhachHang.init(json: json)
                        if let khachhangCopy = khachHangResponse.copy() as? KhachHang{
                            Storage.shared.addOrUpdate([khachhangCopy], type: KhachHang.self)
                        }
                        self.requestHopDong(idKhachHang: khachHangResponse.idKhachHang)
                    } catch {
                        if let error = responseObject.error {
                            Notice.make(type: .Error, content: error.localizedDescription).show()
                        }
                    }
                }
            } else {
                SVProgressHUD.show()
                self.manager.request("https://localhost:5001/KhachHang/EditKhachHang_HopDong", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responseObject) in
                    SVProgressHUD.dismiss()
                    do {
                        let json: JSON = try JSON.init(data: responseObject.data! )
                        let khachhangResponse  = KhachHang.init(json: json)
                        if let khachhangCopy = khachhangResponse.copy() as? KhachHang{
                            Storage.shared.addOrUpdate([khachhangCopy], type: KhachHang.self)
                        }
                        self.requestHopDong(idKhachHang: khachhangResponse.idKhachHang)
                    } catch {
                        if let error = responseObject.error {
                            Notice.make(type: .Error, content: error.localizedDescription).show()
                        }
                    }
                }
            }
        } else {
            if let idDidKhachHangInHopDong = idDidKhachHangInHopDong {
                self.requestHopDong(idKhachHang: "\(idDidKhachHangInHopDong)")
            }
        }
    }
    
    
    func requestHopDong(idKhachHang: String){
        let hopdong = HopDong()
        guard tfTenChuHD.text != "" && tfTienCoc.text != ""  else {
            if tfTenChuHD.text == "" {
                tfTenChuHD.warning()
            }
            if tfTienCoc.text == "" {
                tfTienCoc.warning()
            }
            Notice.make(type: .Error, content: "Không được để rỗng hãy kiểm tra lại").show()
            return
            
        }
        hopdong.IdHopDong = isCreateNew ? "" : self.hopdong?.IdHopDong ?? ""
        hopdong.ChuHopDong = tfTenChuHD.text ?? ""
        hopdong.SoTienCoc = "\(tfTienCoc.getValue())"
        hopdong.NgayBD = "\(btnNgayBatDauCalendar.date)"
        hopdong.NgayKT = "\(btnNgayKTCalendar.date)"
        hopdong.GhiChu = tfGhiChu.text
        hopdong.IdKhachHang = idKhachHang
        hopdong.TienDien = "\(Int(tfGiaDien.getValue()))"
        hopdong.TienNuoc = "\(Int(tfGiaNuoc.getValue()))"
        hopdong.SoDienBd = "\(Int(tfSoDien.getValue()))"
        hopdong.SoNuocBd = "\(Int(tfSoNuoc.getValue()))"
        
        if let index = self.cbbCanHo.selectedIndex {
            hopdong.IdCanHo = self.listCanHo[index].IdCanHo
        }
        let parameters: [String: String] = [
            "IdHopDong" : hopdong.IdHopDong,
            "ChuHopDong" : hopdong.ChuHopDong,
            "IdCanHo" : hopdong.IdCanHo ,
            "SoTienCoc" : hopdong.SoTienCoc,
            "IdKhachHang": hopdong.IdKhachHang,
            "NgayBD" : hopdong.NgayBD.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "NgayKT" : hopdong.NgayKT.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "GhiChu" : hopdong.GhiChu,
            "TienDien" : hopdong.TienDien,
            "TienNuoc" : hopdong.TienNuoc,
            "SoDienBd" : hopdong.SoDienBd,
            "SoNuocBd" : hopdong.SoNuocBd
        ]
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/HopDong/AddHopDong", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let hopdongResponse  = HopDong.init(json: json)
                    if let hopdongCopy = hopdongResponse.copy() as? HopDong{
                        Storage.shared.addOrUpdate([hopdongCopy], type: HopDong.self)
                    }
                    Notice.make(type: .Success, content: "Thêm mới hợp đồng thành công! ").show()
                    self.done?(hopdongResponse)
                    self.requestHopDong(idHopDong: hopdongResponse.IdHopDong)
//                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/HopDong/EditHopDong", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let hopdongResponse  = HopDong.init(json: json)
                    if let hopdongCopy = hopdongResponse.copy() as? HopDong{
                        Storage.shared.addOrUpdate([hopdongCopy], type: HopDong.self)
                    }
                    Notice.make(type: .Success, content: "Sửa mới hợp đồng thành công! ").show()
                    self.done?(hopdongResponse)
//                    self.dismiss(animated: true, completion: nil)
                    self.requestHopDong(idHopDong: hopdongResponse.IdHopDong)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        }
    }
    
    func requestHopDong(idHopDong: String){
        
        let listHopDong_DichVu: [(idDichVu: String, amount: Double)] = self.listSelectedDichVu.getDichVuAmount()
        
        if listHopDong_DichVu.isEmpty {
            self.dismiss(animated: true, completion: nil)
            return
        }
        for index in 0..<listHopDong_DichVu.count {
            let parameters: [String: String] = [
                "IdHopDong" : idHopDong,
                "IdDichVu" : listHopDong_DichVu[index].idDichVu ,
                "DonGia" : "\(listHopDong_DichVu[index].amount)"
            ]
                self.manager.request("https://localhost:5001/HopDong_DichVu/AddOrUpdateHopDong_DichVu", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responseObject) in
                    SVProgressHUD.dismiss()
                    do {
                        let json: JSON = try JSON.init(data: responseObject.data! )
                        let hopdongResponse  = HopDong_DichVu.init(json: json)
                        if let hopdongCopy = hopdongResponse.copy() as? HopDong_DichVu{
                            Storage.shared.addOrUpdate([hopdongCopy], type: HopDong_DichVu.self)
                        }
                        if index == listHopDong_DichVu.count - 1 {
                            self.dismiss(animated: true, completion: nil)
                        }
                    } catch {
                        if let error = responseObject.error {
                            Notice.make(type: .Error, content: error.localizedDescription).show()
                        }
                    }
                }
        }
        
    }
    
    func tinhtoanDichVuCanHo(_ index: Int) {
        dicsDichVu = [:]
        let canHoSelected = self.listCanHo[index]

        
        let dichVu_CanHoSelected = listDichVu_CanHo.filter({ $0.IdCanHo == canHoSelected.IdCanHo }).first?.IdDichVu.components(separatedBy: ",")
        var listDichVuSelected: [DichVu] = []
        for item in dichVu_CanHoSelected ?? [] {
            if let indexSelected = self.listDichVu.firstIndex(where: { $0.idDichVu == item}) {
                listDichVuSelected.append(self.listDichVu[indexSelected])
            }
        }
        for index_Selected in 0..<listDichVuSelected.count {
            if let idDichVu = Int(listDichVuSelected[index_Selected].idDichVu) {
               dicsDichVu[idDichVu] = (text: listDichVuSelected[index_Selected].TenDichVu, number: 0)
                if !isCreateNew {
                    if let hopdong_DichvuObject = self.listDichVu_HopDong.filter({ $0.IdHopDong == self.hopdong?.IdHopDong && $0.IdDichVu == "\(idDichVu)" }).first {
                        dicsDichVu[idDichVu]?.number = Double(hopdong_DichvuObject.DonGia) ?? 0
                    }

                }
                
            }
        }
        constraintHeightDichVu.constant = CGFloat(dicsDichVu.count * 65)
        listSelectedDichVu.addOptions(dicsDichVu)
    }
}

extension AddAndEditHopDongViewController: MyComboboxDelegate {
    func mycombobox(_ cbb: MyCombobox, selectedAt index: Int) {
        if cbb == cbbCanHo {
            tinhtoanDichVuCanHo(index)
        }
    }
}
extension AddAndEditHopDongViewController: MyTexfieldDelegate {
    func myTextfieldDidEndEditing(_ textField: MyTextField) {
        if textField == tfCMND {
            if let khachHangObject = self.listKhachHang.filter({ $0.CMND == tfCMND.text }).first {
                tfTenKhachHang.text = khachHangObject.TenKH
                btnNgayCap.date = khachHangObject.NgayCap.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
                tfNoiCap.text = khachHangObject.NoiCap
                tfSdt.setValue(khachHangObject.SDT)
                tfSdt.text = khachHangObject.SDT
                idDidKhachHangInHopDong = Int(khachHangObject.idKhachHang)
            } else {
                idDidKhachHangInHopDong = nil
            }
        }
    }
}
