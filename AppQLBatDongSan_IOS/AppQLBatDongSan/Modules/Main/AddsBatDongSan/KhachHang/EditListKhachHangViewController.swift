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
    @IBOutlet weak var tfHoten: UITextField!
    @IBOutlet weak var btnNgaySinh: MyButtonCalendar!
    
    @IBOutlet weak var textViewQueQuan: UITextView!
    @IBOutlet weak var tfSodienthoai: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfCmnd: UITextField!
    @IBOutlet weak var cbbCanHo: MyCombobox!
    @IBOutlet weak var viewBody: UIView!
    
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
            groupGioiTinh.selecteAt(index: Int(khachhang?.GioiTinh ?? "0" )!)
            tfHoten.text = khachhang?.TenKH
            tfSodienthoai.text = khachhang?.SDT
            btnNgaySinh.date = khachhang?.NgaySinh.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            tfEmail.text = khachhang?.Email
            tfCmnd.text = khachhang?.CMND
            textViewQueQuan.text = khachhang?.Quequan
            if let index = self.listCanHo.index(where: { $0.IdCanHo == self.khachhang?.IdCanHo}) {
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.TenCanHo}), placeholder: nil, selectedIndex: index)
            } else {
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.TenCanHo}), placeholder: nil, selectedIndex: nil)
            }
        } else {
             self.cbbCanHo.setOptions(self.listCanHo.map({$0.TenCanHo}), placeholder: nil, selectedIndex: nil)
            btnNgaySinh.date = Date()
            groupGioiTinh.selecteAt(index: 0 )
        }
        btnNgaySinh.layer.borderColor = UIColor.gray.cgColor
        btnNgaySinh.layer.borderWidth = 1.0
        textViewQueQuan.layer.borderColor = UIColor.gray.cgColor
        textViewQueQuan.layer.borderWidth = 1.0
        textViewQueQuan.layer.cornerRadius = MyUI.buttonCornerRadius
    }
    
    @IBAction func eventDismissEditListKhachHangVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func eventClickSave(_ sender: Any) {

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
            
        ]
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/KhachHang/AddKhachHang", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
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
            self.manager.request("https://localhost:5001/khachhang/EditKhachHang", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
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
        btnNgaySinh.date = picker.date
    }
    
    @IBAction func eventClickCancel(_ sender: Any) {
        eventDismissEditListKhachHangVC(sender)
        
    }
    
}
