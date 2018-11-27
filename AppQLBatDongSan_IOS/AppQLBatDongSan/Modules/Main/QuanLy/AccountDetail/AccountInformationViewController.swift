//
//  AccountInformationViewController.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 11/25/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class AccountInformationViewController: UIViewController {

    @IBOutlet weak var btnCheckboxGioiTinhNam: MyCheckbox!
    @IBOutlet weak var tfHoten: MyTextField!
    @IBOutlet weak var btnCheckboxGioiTinhNu: MyCheckbox!
    @IBOutlet weak var btnCalendarNamSinh: MyButtonCalendar!
    @IBOutlet weak var textviewDiaChi: UITextView!
    @IBOutlet weak var tfSDT: UITextField!
    
    var group: [MyCheckbox]?
    var account: Account? = nil
    let manager = Alamofire.SessionManager()
    var dismissViewController: (()->())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
       let listAccount =  Storage.shared.getObjects(type: Account.self) as! [Account]
        self.account = listAccount.filter({ $0.email == AppState.shared.getAccount() }).first
        btnCheckboxGioiTinhNam.tag = 1
        btnCheckboxGioiTinhNu.tag = 2
        group = [btnCheckboxGioiTinhNam, btnCheckboxGioiTinhNu]
        tfHoten.text = account?.hoten
        if account?.gioitinh == "1" {
            btnCheckboxGioiTinhNam.isSelected = true
        } else {
            btnCheckboxGioiTinhNu.isSelected = true
        }
        tfSDT.text = account?.sdt
        textviewDiaChi.text = account?.diaChi
        btnCalendarNamSinh.date = account?.namSinh.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
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
    
    @IBAction func actionChooseOption(_ sender: Any) {
        if let btn = sender as? MyCheckbox {
            group?.forEach({$0.isSelected = false})
            btn.isSelected = true
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
        btnCalendarNamSinh.date = picker.date
    }
    
    @IBAction func eventClickHuy(_ sender: Any) {
        dismissViewController?()
        
    }
    
    @IBAction func eventClickSave(_ sender: Any) {
        let account = Account()
        
        account.IdAccount = self.account?.IdAccount ?? ""
        account.hoten = tfHoten.text!
        account.gioitinh = btnCheckboxGioiTinhNam.isSelected ? "1" : "0"
        account.namSinh = "\(btnCalendarNamSinh.date)"
        account.sdt = tfSDT.text!
        account.diaChi = textviewDiaChi.text
        let parameters: [String: String] = [
            "IdAccount" : account.IdAccount,
            "HoTen" : account.hoten ,
            "GioiTinh" : account.gioitinh,
            "NamSinh" : account.namSinh.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "SDT" : account.sdt,
            "DiaChi" : account.diaChi
        ]
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/Account/EditAccount", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let accountResponse  = Account.init(json: json)
                    if let accountCopy = accountResponse.copy() as? Account{
                        Storage.shared.addOrUpdate([accountCopy], type: Account.self)
                    }
                    Notice.make(type: .Success, content: "Sửa mới tài khoản thành công! ").show()
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
    }

}
