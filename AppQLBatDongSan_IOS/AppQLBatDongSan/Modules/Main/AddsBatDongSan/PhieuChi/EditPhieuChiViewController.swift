
//
//  EditPhieuChiViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class EditPhieuChiViewController: UIViewController {
    @IBOutlet weak var cbbNgay: MyButtonCalendar!
    
    @IBOutlet weak var cbbCanHo: MyCombobox!
    
    @IBOutlet weak var textfieldSotien: MyNumberField!
    
    @IBOutlet weak var textViewDiengiai: UITextView!
    
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var btnLuu: UIButton!
    @IBOutlet weak var labelHeader: UILabel!
    
    
    var onUpdatePhieuChi: ((PhieuChi)->())?
    var phieuchi: PhieuChi?
    var canHo: CanHo?
    var isCreateNew: Bool = true
    var listCanHo: [CanHo] = []
     let manager = Alamofire.SessionManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        customized()
        labelHeader.text = isCreateNew ? "Thêm phiêu chi" : "Sửa phiếu chi"
        if !isCreateNew {
            cbbNgay.date = phieuchi?.Ngay.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            let listCanHo = Storage.shared.getObjects(type: CanHo.self) as? [CanHo]
            textfieldSotien.text = phieuchi?.Sotien.toNumberString(decimal: false)
            textViewDiengiai.text = phieuchi?.DienGiai
            
            if let index = self.listCanHo.index(where: { $0.IdCanHo == self.phieuchi?.IdCanHo}) {
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.maCanHo}), placeholder: nil, selectedIndex: index)
            }

        } else {
            self.cbbCanHo.setOptions(self.listCanHo.map({$0.maCanHo}), placeholder: nil, selectedIndex: nil)
            cbbNgay.date = Date()
            
        }
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
    
    func customized() {
        viewBody.layer.cornerRadius = MyUI.buttonCornerRadius
        listCanHo = Storage.shared.getObjects(type: CanHo.self) as! [CanHo]
        textfieldSotien?.setAsNumericKeyboard(type: .money, autoSelectAll: true)
        btnLuu.layer.cornerRadius = MyUI.buttonCornerRadius
        textViewDiengiai.layer.borderColor = UIColor.gray.cgColor
        textViewDiengiai.layer.borderWidth = 1.0
        textViewDiengiai.layer.cornerRadius = MyUI.buttonCornerRadius
        cbbNgay.layer.borderColor = UIColor.gray.cgColor
        cbbNgay.layer.borderWidth = 1.0
    }
    
    @IBAction func eventSavePhieuChi(_ sender: Any) {
        let phieuchi = PhieuChi()
        guard textfieldSotien.text != ""  else {
            if textfieldSotien.text == "" {
                textfieldSotien.warning()
            }
            Notice.make(type: .Error, content: "Không được để rỗng hãy kiểm tra lại").show()
            return
        }
        
        phieuchi.IdPhieuChi = isCreateNew ? "" : self.phieuchi?.IdPhieuChi ?? ""
        phieuchi.Sotien = "\(textfieldSotien.getValueString())"
        phieuchi.DienGiai = textViewDiengiai.text ?? ""
        phieuchi.Ngay = "\(cbbNgay.date)"
        
        if let index = cbbCanHo.selectedIndex{
            phieuchi.IdCanHo = "\(listCanHo[index].IdCanHo)"
        } else {
            cbbCanHo.warning()
            Notice.make(type: .Error, content: "Chưa chọn phòng, làm ơn hãy chọn ").show()
            return
        }
        let parameters: [String: String] = [
            "IdCanHo" : phieuchi.IdCanHo,
            "IdPhieuChi" : phieuchi.IdPhieuChi ,
            "SoTien" : phieuchi.Sotien,
            "Ngay" : phieuchi.Ngay.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "DienGiai": phieuchi.DienGiai
        ]
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/PhieuChi/AddPhieuChi", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let phieuChiResponse  = PhieuChi.init(json: json)
                    if let phieuChiCopy = phieuChiResponse.copy() as? PhieuChi{
                        Storage.shared.addOrUpdate([phieuChiCopy], type: PhieuChi.self)
                    }
                    Notice.make(type: .Success, content: "Thêm phiếu chi thành công !").show()
                    self.onUpdatePhieuChi?(phieuChiResponse)
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/PhieuChi/EditPhieuChi", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let phieuChiResponse  = PhieuChi.init(json: json)
                    if let phieuChiCopy = phieuChiResponse.copy() as? PhieuChi{
                        Storage.shared.addOrUpdate([phieuChiCopy], type: PhieuChi.self)
                    }
                        Notice.make(type: .Success, content: "Sửa phiếu chi thành công !").show()
                    self.onUpdatePhieuChi?(phieuChiResponse)
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
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
