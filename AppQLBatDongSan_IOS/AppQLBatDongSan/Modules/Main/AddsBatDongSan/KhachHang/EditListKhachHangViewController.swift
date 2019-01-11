//
//  EditListKhachHangViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/18/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire
import SwiftyJSON

class EditListKhachHangViewController: UIViewController {
    
    var khachhang: KhachHang? = nil
    var listCanHo: [CanHo] = []
    
    @IBOutlet weak var groupGioiTinh: MyCheckboxGroup!
    @IBOutlet weak var tfHoten: MyTextField!
    @IBOutlet weak var btnNgaySinh: MyButtonCalendar!
    
    @IBOutlet weak var textViewQueQuan: UITextView!
    @IBOutlet weak var tfSodienthoai: MyTextField!
    @IBOutlet weak var tfEmail: MyTextField!
    @IBOutlet weak var tfCmnd: MyTextField!
    @IBOutlet weak var cbbCanHo: MyCombobox!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var btnNgayCap: MyButtonCalendar!
    @IBOutlet weak var tfNoiCap: MyTextField!
    
    @IBOutlet weak var tfMatKhau: MyTextField!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    var index: Int = -1
    var isCreateNew: Bool = true
    var done: ((_ khachHang: KhachHang)->())?
    let manager = Alamofire.SessionManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelHeaderTitle.text = isCreateNew ? "Thêm khách hàng" : "Sửa khách hàng"
        viewBody.layer.cornerRadius = MyUI.buttonCornerRadius
        binding()
        configService()
        cbbCanHo.textColor = MyColor.black
        cbbCanHo.dropdownBackgroundColor = MyColor.cyan
        cbbCanHo.dropdownBackgroundSelectedColor = MyColor.cyanHover
        cbbCanHo.dropdownForcegroundColor = .white
//        self.cbbCanHo.delegate = self
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
    
    func binding() {
        listCanHo = Storage.shared.getObjects(type: CanHo.self) as! [CanHo]
         groupGioiTinh.addTitleAndOptions("Gioi Tinh", options: [0: "Nữ ",1: "Nam"],isRadioBox: true)
        if !isCreateNew {
            groupGioiTinh.selecteAt(index: (Int(khachhang?.GioiTinh ?? "0") ?? 0 ))
            tfHoten.text = khachhang?.TenKH
            tfSodienthoai.text = khachhang?.SDT
            btnNgaySinh.date = khachhang?.NgaySinh.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            tfEmail.text = khachhang?.Email
            tfCmnd.text = khachhang?.CMND
            textViewQueQuan.text = khachhang?.Quequan
            if let index = self.listCanHo.index(where: { $0.IdCanHo == self.khachhang?.IdCanHo}) {
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.maCanHo}), placeholder: nil, selectedIndex: index)
            } else {
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.maCanHo}), placeholder: nil, selectedIndex: nil)
            }
             btnNgayCap.date = khachhang?.NgayCap.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            tfNoiCap.text = khachhang?.NoiCap
            tfMatKhau.text = khachhang?.Password
        } else {
             self.cbbCanHo.setOptions(self.listCanHo.map({$0.maCanHo}), placeholder: nil, selectedIndex: nil)
            btnNgaySinh.date = Date()
            groupGioiTinh.selecteAt(index: 0 )
        }
        btnNgaySinh.layer.borderColor = UIColor.gray.cgColor
        btnNgaySinh.layer.borderWidth = 1.0
        btnNgayCap.layer.borderColor = UIColor.gray.cgColor
        btnNgayCap.layer.borderWidth = 1.0
        
        textViewQueQuan.layer.borderColor = UIColor.gray.cgColor
        textViewQueQuan.layer.borderWidth = 1.0
        textViewQueQuan.layer.cornerRadius = MyUI.buttonCornerRadius
    }
    
    @IBAction func eventDismissEditListKhachHangVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eventClickSave(_ sender: Any) {
        guard let hoten = tfHoten.text, let sdt = tfSodienthoai.text, let email = tfEmail.text, let cmnd = tfCmnd.text, let noicap =  tfNoiCap.text, let quequan = textViewQueQuan.text, let matkhau = tfMatKhau.text, !hoten.isEmpty, !sdt.isEmpty, !email.isEmpty, !cmnd.isEmpty, !noicap.isEmpty, !matkhau.isEmpty else {
            if tfHoten.text?.isEmpty ?? true  {
                tfHoten.warning()
            }
            if tfSodienthoai.text?.isEmpty ?? true {
                tfSodienthoai.warning()
            }
            if tfEmail.text?.isEmpty ?? true {
                tfEmail.warning()
            }
            if tfCmnd.text?.isEmpty  ?? true {
                tfCmnd.warning()
            }
            if tfNoiCap.text?.isEmpty ?? true {
                tfNoiCap.warning()
            }
            if tfMatKhau.text?.isEmpty  ?? true {
                tfMatKhau.warning()
            }
            return
            
        }

        
        let khachangNew = KhachHang()
        if let index = cbbCanHo.selectedIndex{
            khachangNew.IdCanHo = "\(self.listCanHo[index].IdCanHo)"
        } else {
            cbbCanHo.warning()
            Notice.make(type: .Error, content: "Chưa chọn phòng, làm ơn hãy chọn ").show()
            return
        }
        khachangNew.idKhachHang = isCreateNew ? "" : self.khachhang?.idKhachHang ?? ""
        khachangNew.TenKH = tfHoten.text ?? ""
        khachangNew.SDT = tfSodienthoai.text ?? ""
        khachangNew.Email = tfEmail.text ?? ""
        khachangNew.CMND = tfCmnd.text ?? ""
        khachangNew.NgaySinh = "\(btnNgaySinh.date)"
        khachangNew.Quequan = textViewQueQuan.text
        khachangNew.NgayCap = "\(btnNgayCap.date)"
        khachangNew.NoiCap = tfNoiCap.text ?? ""
         khachangNew.Password = tfMatKhau.text ?? ""
        if let id = groupGioiTinh.selectedId {
            khachangNew.GioiTinh = "\(id)"
        }
        let parameters: [String: String] = [
            "IdKhachHang" : khachangNew.idKhachHang,
            "TenKH" : khachangNew.TenKH,
            "IdCanHo" : khachangNew.IdCanHo ,
            "NgaySinh" : khachangNew.NgaySinh.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "GioiTinh" : khachangNew.GioiTinh,
            "SDT" : khachangNew.SDT,
            "Email" : khachangNew.Email,
            "CMND" : khachangNew.CMND,
            "Quequan" : khachangNew.Quequan,
            "NgayCap": khachangNew.NgayCap.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "NoiCap" : khachangNew.NoiCap,
            "Password" : khachangNew.Password
        ]
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/KhachHang/AddKhachHang", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let khachhangResponse  = KhachHang.init(json: json)
                    if let khachhangCopy = khachhangResponse.copy() as? KhachHang{
                        Storage.shared.addOrUpdate([khachhangCopy], type: KhachHang.self)
                    }
                    Notice.make(type: .Success, content: "Thêm mới khách hàng thành công! ").show()
                    self.done?(khachhangResponse)
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/khachhang/EditKhachHang", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let khachhangResponse  = KhachHang.init(json: json)
                    if let khachhangCopy = khachhangResponse.copy() as? KhachHang{
                        Storage.shared.addOrUpdate([khachhangCopy], type: KhachHang.self)
                    }
                    Notice.make(type: .Success, content: "Sửa mới khách hàng thành công! ").show()
                    self.done?(khachhangResponse)
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        }
    }
    
    @IBAction func eventChooseDateNgaySinh(_ sender: Any) {
        guard let btn = sender as? MyButtonCalendar else { return  }
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = btn.date
        picker.addTarget(self, action: #selector(pickerChangedDateNgaySinh), for: .valueChanged)
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
    
    @objc func pickerChangedDateNgaySinh(picker: UIDatePicker) {
        btnNgaySinh.date = picker.date
    }
    
    @IBAction func eventClickCancel(_ sender: Any) {
        eventDismissEditListKhachHangVC(sender)
        
    }
    
}
