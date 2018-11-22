//
//  AddAndEditDichVuViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 11/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class AddAndEditDichVuViewController: UIViewController {

    @IBOutlet weak var tfTenDV: MyTextField!
    @IBOutlet weak var tfDonGia: MyNumberField!
    @IBOutlet weak var cbbDonVi: MyCombobox!
    @IBOutlet weak var checboxMacDinh: MyCheckbox!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    @IBOutlet weak var viewBody: UIView!
    
      let manager = Alamofire.SessionManager()
    var isCreateNew: Bool = true
    var dichvu: DichVu? = nil
    var done: ((_ dichvu: DichVu)->())?
    
    var listDonVi: [DonVi] = []
    
    override func viewDidLoad() {
        configService()
        labelHeaderTitle.text = isCreateNew == true ? "Tạo dịch vụ" : "Sửa dịch vụ"
        listDonVi = Storage.shared.getObjects(type: DonVi.self) as! [DonVi]
        if !isCreateNew {
            tfTenDV.text = dichvu?.TenDichVu
            tfDonGia.setValue(dichvu?.DonGia ?? "0")
            if let index = listDonVi.index(where: {$0.idDonVi == self.dichvu?.idDonvi}) {
                cbbDonVi.setOptions(listDonVi.map({$0.TenDonVi}), placeholder: nil, selectedIndex: index)
            } else {
                cbbDonVi.setOptions(listDonVi.map({$0.TenDonVi}), placeholder: nil, selectedIndex: nil)
            }
            checboxMacDinh.isSelected = dichvu?.MacDinh == "1" ? true : false
        } else {
            checboxMacDinh.isSelected = true
            cbbDonVi.setOptions(listDonVi.map({$0.TenDonVi}), placeholder: nil, selectedIndex: nil)
        }
        tfDonGia.setAsNumericKeyboard(type: .money, autoSelectAll: false)
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
    
    @IBAction func tao(_ sender: Any) {
        let dichvu = DichVu()
        dichvu.idDichVu = isCreateNew ? "\(dichvu.IncrementaID())" : self.dichvu?.idDichVu ?? ""
        dichvu.TenDichVu = tfTenDV.text!
        if let selectedIndex = self.cbbDonVi.selectedIndex {
            dichvu.idDonvi = listDonVi[selectedIndex].idDonVi
        } else {
            dichvu.idDonvi = ""
        }
        dichvu.DonGia = tfDonGia.getValueString()
        dichvu.MacDinh = checboxMacDinh.isSelected == true ? "1" : "0"
        Storage.shared.addOrUpdate([dichvu], type: DichVu.self)
        
        let parameters: [String: String] = [
            "idDichVu" : dichvu.idDichVu,
            "TenDichVu" : dichvu.TenDichVu ,
            "DonGia" : dichvu.DonGia,
            "idDonvi" : dichvu.idDonvi,
            "MacDinh" : dichvu.MacDinh
        ]
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/DichVu/AddDichVu", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let dichvuResponse  = DichVu.init(json: json)
                    if let dichvuCopy = dichvuResponse.copy() as? DichVu{
                        Storage.shared.addOrUpdate([dichvuCopy], type: DichVu.self)
                    }
                    Notice.make(type: .Success, content: "Thêm mới dịch vụ thành công! ").show()
                    self.done?(dichvuResponse)
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/DichVu/EditDichVu", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let dichvuResponse  = DichVu.init(json: json)
                    if let dichvuCopy = dichvuResponse.copy() as? DichVu{
                        Storage.shared.addOrUpdate([dichvuCopy], type: DichVu.self)
                    }
                    Notice.make(type: .Success, content: "Sửa mới dịch vụ thành công! ").show()
                    self.done?(dichvuResponse)
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        }
    }
    
    @IBAction func huy(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchOutSide(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
