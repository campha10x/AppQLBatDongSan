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

    @IBOutlet weak var cbbPhong: MyCombobox!
    @IBOutlet weak var tfSoPhieu: MyTextField!
    @IBOutlet weak var tfSotien: MyNumberField!
    @IBOutlet weak var btnNgayTao: MyButtonCalendar!
    @IBOutlet weak var btnTao: MySolidButton!
    @IBOutlet weak var viewBody: UIView!
    
    var listPhong: [Phong] = []
    var isCreateNew: Bool = true
    var hoadon: HoaDon? = nil
    var done: ((_ hoadon: HoaDon)->())?
    let manager = Alamofire.SessionManager()
    
    @IBOutlet weak var labelHeaderTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        customized()
        configService()
        if !isCreateNew {
            tfSoPhieu.text = self.hoadon?.soPhieu
            if let index = self.listPhong.index(where: { $0.idPhong == self.hoadon?.idPhong}) {
                self.cbbPhong.setOptions(self.listPhong.map({$0.tenPhong}), placeholder: nil, selectedIndex: index)
            }
            btnNgayTao.date = hoadon?.ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            tfSotien.setValue(hoadon?.soTien)
            btnTao.setTitle("Sửa hoá đơn", for: .normal)
        } else {
            tfSoPhieu.text = "SPHD-\(randomNumber(inRange: 100...50000))"
            self.cbbPhong.setOptions(self.listPhong.map({$0.tenPhong}), placeholder: nil, selectedIndex: nil)
            btnNgayTao.date = Date()
            btnTao.setTitle("Tạo hoá đơn", for: .normal)
        }
        tfSoPhieu.isEnabled = false
         viewBody.layer.cornerRadius = 6.0
    }
    
    func customized()  {
        listPhong = Storage.shared.getObjects(type: Phong.self) as! [Phong]
        self.cbbPhong.delegate = self
        tfSotien?.setAsNumericKeyboard(type: .money, autoSelectAll: true)
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
        if let index = cbbPhong.selectedIndex{
            hoadon.idPhong = "\(listPhong[index].idPhong)"
        } else {
            cbbPhong.warning()
            Notice.make(type: .Error, content: "Chưa chọn phòng, làm ơn hãy chọn ").show()
            return
        }
        
        let parameters: [String: String] = [
            "IdHoaDon" : hoadon.idHoaDon,
            "IdPhong" : hoadon.idPhong ,
            "SoPhieu" : hoadon.soPhieu,
            "NgayTao" : hoadon.ngayTao.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "SoTien" : hoadon.soTien
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
                    self.done?(hoadonResponse)
                    self.dismiss(animated: true, completion: nil)
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
                    self.done?(hoadonResponse)
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

extension AddAndEditHoaDonViewController :MyComboboxDelegate{
    
}
