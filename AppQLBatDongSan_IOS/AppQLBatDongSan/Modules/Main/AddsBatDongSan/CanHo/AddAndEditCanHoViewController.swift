//
//  AddAndEditCanHoViewController.swift
//  AppQLBatDongSan
//
//  Created by NNX on 11/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class AddAndEditCanHoViewController: UIViewController {
    
    @IBOutlet weak var tenCanHotft: MyTextField!
    @IBOutlet weak var giaCanHotft: MyNumberField!
    @IBOutlet weak var soDientft: MyNumberField!
    @IBOutlet weak var sotienNuoctft: MyNumberField!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var DiaChiTextView: UITextView!
    
    @IBOutlet weak var cbbDichVu: MyCombobox!
    @IBOutlet weak var DienTichtf: MyNumberField!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    var isCreateNew: Bool = true
    var canHo: CanHo? = nil
    var done: ((_ CanHo: CanHo)->())?
    let manager = Alamofire.SessionManager()
    var listDichVu: [DichVu] = []
    var listDichVu_Canho: [CanHo_DichVu] = []
    
    override func viewDidLoad() {
        labelHeaderTitle.text = isCreateNew == true ? "Tạo Căn hộ" : "Sửa Căn hộ"
        listDichVu = Storage.shared.getObjects(type: DichVu.self) as! [DichVu]
        listDichVu_Canho = Storage.shared.getObjects(type: CanHo_DichVu.self) as! [CanHo_DichVu]
        cbbDichVu.isMultipleSelection = true
         configService()
        if !isCreateNew {
            tenCanHotft.text = canHo?.TenCanHo
            giaCanHotft.setValue(canHo?.DonGia)
            soDientft.setValue(canHo?.SoDienCu ?? "0")
            sotienNuoctft.setValue(canHo?.SoNuocCu ?? "0")
            DienTichtf.setValue(canHo?.DienTich ?? "0")
            DiaChiTextView.text = canHo?.DiaChi
            let getDichVu_CanHo: [String] = listDichVu_Canho.filter({$0.IdCanHo == canHo?.IdCanHo}).first?.IdDichVu.components(separatedBy: ",") ?? []
            let selectedListDichVu: [DichVu] = listDichVu.filter { (dichvu) -> Bool in
                return getDichVu_CanHo.filter({$0 == dichvu.idDichVu }).first != nil
            }
            var selectedIndex: [Int] = []
            for item in selectedListDichVu{
                if let index = self.listDichVu.firstIndex(where: { $0.idDichVu == item.idDichVu}) {
                    selectedIndex.append(index)
                }
            }
             cbbDichVu.setOptions(self.listDichVu.map({$0.TenDichVu}), placeholder: nil, selectedIndex: nil)
           cbbDichVu.selectedIndexs = selectedIndex
        } else {
            soDientft.setValue("0")
            sotienNuoctft.setValue("0")
            DienTichtf.setValue("0")
            cbbDichVu.setOptions(self.listDichVu.map({$0.TenDichVu}), placeholder: nil, selectedIndex: nil)
        }
        DiaChiTextView.layer.borderColor = UIColor.gray.cgColor
        DiaChiTextView.layer.borderWidth = 1.0
        DienTichtf.setAsNumericKeyboard(type: .integer, autoSelectAll: false)
        giaCanHotft.setAsNumericKeyboard(type: .money, autoSelectAll: false)
        soDientft.setAsNumericKeyboard(type: .money, autoSelectAll: false)
        sotienNuoctft.setAsNumericKeyboard(type: .money, autoSelectAll: false)
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
        let canHo = CanHo()

        canHo.IdCanHo = isCreateNew ? "" : self.canHo?.IdCanHo ?? ""
        canHo.TenCanHo = tenCanHotft.text!
        canHo.DonGia = giaCanHotft.getValueString()
        canHo.SoDienCu = soDientft.getValueString()
        canHo.SoNuocCu = sotienNuoctft.getValueString()
        canHo.DienTich = DienTichtf.getValueString()
        canHo.DiaChi = DiaChiTextView.text
        let parameters: [String: String] = [
            "IdCanHo" : canHo.IdCanHo,
            "TenCanHo" : canHo.TenCanHo ,
            "DonGia" : canHo.DonGia,
            "SoDienCu" : canHo.SoDienCu,
            "SoNuocCu" : canHo.SoNuocCu,
            "DienTich" : canHo.DienTich,
            "DiaChi" : canHo.DiaChi
        ]
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/CanHo/AddCanHo", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let canHoResponse  = CanHo.init(json: json)
                    if let canHoCopy = canHoResponse.copy() as? CanHo{
                        Storage.shared.addOrUpdate([canHoCopy], type: CanHo.self)
                    }
                    Notice.make(type: .Success, content: "Thêm mới căn hộ thành công! ").show()
                    self.requestDichVu_CanHo()
                    self.done?(canHoResponse)
//                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/CanHo/EditCanHo", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let canHoResponse  = CanHo.init(json: json)
                    if let canHoCopy = canHoResponse.copy() as? CanHo{
                        Storage.shared.addOrUpdate([canHoCopy], type: CanHo.self)
                    }
                     self.requestDichVu_CanHo()
                    Notice.make(type: .Success, content: "Sửa mới căn hộ thành công! ").show()
                    self.done?(canHoResponse)
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        }
    }
    
    func requestDichVu_CanHo() {
        var getListidDichVu: [String] = []
        if let selectedIndex = cbbDichVu.selectedIndexs
        {
            for index in selectedIndex {
                getListidDichVu.append(self.listDichVu[index].idDichVu)
            }
        }

        let listIdDichvu = getListidDichVu.reduce("") { (str1, str2) -> String in
            return str1 == "" ? (str1 + str2) : (str1 + "," + str2)
        }
        let parameters: [String: String] = [
            "IdDichVu" : listIdDichvu,
            "IdCanHo" : canHo?.IdCanHo ?? ""
        ]
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/CanHo_DichVu/AddOrUpDateListCanHo_DichVu", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let canHoResponse  = CanHo_DichVu.init(json: json)
                    if let canHoCopy = canHoResponse.copy() as? CanHo_DichVu{
                        Storage.shared.addOrUpdate([canHoCopy], type: CanHo_DichVu.self)
                    }
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
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
