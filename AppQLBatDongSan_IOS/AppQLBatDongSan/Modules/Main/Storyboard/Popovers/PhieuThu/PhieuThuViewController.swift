//
//  PhieuThuViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/7/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class PhieuThuViewController: UIViewController {

    @IBOutlet weak var imageStar: UIImageView!
    
    @IBOutlet weak var cbbNgay: MyButtonCalendar!
    
    @IBOutlet weak var textfieldPhong: UITextField!
    
    @IBOutlet weak var textfieldMaHoaDon: UITextField!
    
    @IBOutlet weak var textfieldSotien: MyNumberField!
    
    @IBOutlet weak var textViewGhiChu: UITextView!
    @IBOutlet weak var viewBody: UIView!
    
    @IBOutlet weak var labelHeaderTitle: UILabel!
    @IBOutlet weak var btnLuu: UIButton!
    
    var hoadon: HoaDon?
    var datra: Int?
    var listPhong: [Phong] = []
    var onUpdatePhieuThu: ((PhieuThu)->())?
    let manager = Alamofire.SessionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        customized()
        if let hoadon = hoadon {
            let conlai = (Double(hoadon.soTien)?.toInt()!)! - datra!
            textfieldMaHoaDon.text = "\(String(describing: hoadon.idHoaDon)) - \(hoadon.ngayTao.formatDate()) - \(conlai)"
//            textfieldSotien.text = "\(conlai)".toNumberString(decimal: false)
            
            textfieldSotien.setValue("\(Double(conlai))")
        }

    }
    
    func customized() {
        viewBody.layer.cornerRadius = MyUI.buttonCornerRadius
        btnLuu.layer.cornerRadius = MyUI.buttonCornerRadius
        textViewGhiChu.layer.borderColor = UIColor.gray.cgColor
        textViewGhiChu.layer.borderWidth = 1.0
        textViewGhiChu.layer.cornerRadius = MyUI.buttonCornerRadius
        cbbNgay.date = Date()
        cbbNgay.layer.borderColor = UIColor.gray.cgColor
        cbbNgay.layer.borderWidth = 1.0
        listPhong = Storage.shared.getObjects(type: Phong.self) as! [Phong]
        textfieldPhong.text = listPhong.filter({ $0.idPhong == hoadon?.idPhong}).first?.tenPhong ?? ""
        textfieldPhong.isEnabled = false
        textfieldSotien.setAsNumericKeyboard(type: .money, autoSelectAll: false)
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
    
    @IBAction func eventSavePhieuThu(_ sender: Any) {
        let parameters: [String: String] = [
            "IdPhong" : self.hoadon?.idPhong ?? "",
            "IdHoaDon" : self.hoadon?.idHoaDon ?? "",
            "SoTien" : textfieldSotien.getValueString(),
            "Ngay" : "\(cbbNgay.date)".formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "GhiChu": self.textViewGhiChu.text
        ]
        
        SVProgressHUD.show()
        self.manager.request("https://localhost:5001/PhieuThu/AddPhieuThu", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                let phieuthuResponse  = PhieuThu.init(json: json)
                if let phieuthuCopy = phieuthuResponse.copy() as? PhieuThu{
                    Storage.shared.addOrUpdate([phieuthuCopy], type: HoaDon.self)
                }
                Notice.make(type: .Success, content: "Thêm mới phiếu thu thành công! ").show()
                self.onUpdatePhieuThu?(phieuthuResponse)
                self.dismiss(animated: true, completion: nil)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
    }
    
    @IBAction func eventHuyPhieuThu(_ sender: Any) {
        buttonOutside(sender)
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
        cbbNgay.date = picker.date
    }
    
    @IBAction func buttonOutside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
