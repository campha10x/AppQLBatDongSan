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
    
    @IBOutlet weak var tfTieuDe: MyTextField!
    @IBOutlet weak var tfDiaChi: MyTextField!
    @IBOutlet weak var tfGiaPhong: MyNumberField!
    @IBOutlet weak var tfDienTich: MyNumberField!
    
    @IBOutlet weak var tvThongtinMota: UITextView!
    @IBOutlet weak var tfAnhCanHo: MyTextField!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    var isCreateNew: Bool = true
    var canHo: CanHo? = nil
    var done: ((_ CanHo: CanHo)->())?
    let manager = Alamofire.SessionManager()
    var listDichVu: [DichVu] = []
    var listDichVu_Canho: [CanHo_DichVu] = []
    
    override func viewDidLoad() {
        labelHeaderTitle.text = isCreateNew == true ? "Tạo Căn hộ" : "Sửa Căn hộ"
         configService()
        if !isCreateNew {
            tfTieuDe.text = self.canHo?.TieuDe
            tfDiaChi.text = self.canHo?.DiaChi
            let giaphong = Double(self.canHo?.DonGia ?? "") ?? 0
            let dientich = (Double(self.canHo?.DienTich ?? "") ?? 0 )
            tfGiaPhong.setValue(giaphong)
            tfDienTich.setValue(dientich)
            tvThongtinMota.text = self.canHo?.MoTa
            tfAnhCanHo.text = self.canHo?.AnhCanHo
        } else {
            tfGiaPhong.setValue("0")
            tfDienTich.setValue("0")
        }

        tfDienTich.setAsNumericKeyboard(type: .integer, autoSelectAll: false)
        tfGiaPhong.setAsNumericKeyboard(type: .money, autoSelectAll: false)
        
        tvThongtinMota.layer.cornerRadius = 6.0
        tvThongtinMota.layer.borderWidth = 2.0
        tvThongtinMota.layer.borderColor = MyColor.lightGray.cgColor
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
        canHo.NgayTao = isCreateNew ? Date().toString(format: "yyyy-MM-dd") ?? "" : canHo.NgayTao.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd")
        canHo.DonGia =  "\(Int(tfGiaPhong.getValue()))"
        canHo.DienTich = "\(Int(tfDienTich.getValue()))"
        canHo.DiaChi = tfDiaChi.text ?? ""
        canHo.MoTa = tvThongtinMota.text ?? ""
        canHo.AnhCanHo = tfAnhCanHo.text ?? ""
        canHo.TieuDe = tfTieuDe.text ?? ""
        let parameters: [String: String] = [
            "IdCanHo" : canHo.IdCanHo,
            "DonGia" : canHo.DonGia,
            "DienTich" : canHo.DienTich,
            "DiaChi" : canHo.DiaChi,
            "TieuDe" : canHo.TieuDe,
            "MoTa" : canHo.MoTa,
            "AnhCanHo" : canHo.AnhCanHo,
            "NgayTao": canHo.NgayTao
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
//                    self.requestDichVu_CanHo()
                    self.done?(canHoResponse)
                    self.dismiss(animated: true, completion: nil)
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
//                     self.requestDichVu_CanHo()
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
    
//    func requestDichVu_CanHo() {
//        var getListidDichVu: [String] = []
//        if let selectedIndex = cbbDichVu.selectedIndexs
//        {
//            for index in selectedIndex {
//                getListidDichVu.append(self.listDichVu[index].idDichVu)
//            }
//        }
//
//        let listIdDichvu = getListidDichVu.reduce("") { (str1, str2) -> String in
//            return str1 == "" ? (str1 + str2) : (str1 + "," + str2)
//        }
//        let parameters: [String: String] = [
//            "IdDichVu" : listIdDichvu,
//            "IdCanHo" : canHo?.IdCanHo ?? ""
//        ]
//            SVProgressHUD.show()
//            self.manager.request("https://localhost:5001/CanHo_DichVu/AddOrUpDateListCanHo_DichVu", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
//                SVProgressHUD.dismiss()
//                do {
//                    let json: JSON = try JSON.init(data: responseObject.data! )
//                    let canHoResponse  = CanHo_DichVu.init(json: json)
//                    if let canHoCopy = canHoResponse.copy() as? CanHo_DichVu{
//                        Storage.shared.addOrUpdate([canHoCopy], type: CanHo_DichVu.self)
//                    }
//                    self.dismiss(animated: true, completion: nil)
//                } catch {
//                    if let error = responseObject.error {
//                        Notice.make(type: .Error, content: error.localizedDescription).show()
//                    }
//                }
//            }
//    }
    
    @IBAction func huy(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchOutSide(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
