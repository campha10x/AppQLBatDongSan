//
//  AddAndEditPhongViewController.swift
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

class AddAndEditPhongViewController: UIViewController {
    
    @IBOutlet weak var tenPhongtft: MyTextField!
    @IBOutlet weak var giaPhongtft: MyNumberField!
    @IBOutlet weak var soDientft: MyNumberField!
    @IBOutlet weak var sotienNuoctft: MyNumberField!
    @IBOutlet weak var viewBody: UIView!
    
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    var isCreateNew: Bool = true
    var phong: Phong? = nil
    var done: ((_ phong: Phong)->())?
       let manager = Alamofire.SessionManager()
    
    override func viewDidLoad() {
        labelHeaderTitle.text = isCreateNew == true ? "Tạo phòng" : "Sửa phòng"
         configService()
        if !isCreateNew {
            tenPhongtft.text = phong?.tenPhong
            giaPhongtft.setValue(phong?.donGia)
            soDientft.setValue(phong?.soDien ?? "0")
            sotienNuoctft.setValue(phong?.soNuoc ?? "0")
        } else {
           
        }
        giaPhongtft.setAsNumericKeyboard(type: .money, autoSelectAll: false)
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
        let phong = Phong()

        phong.idPhong = isCreateNew ? "" : self.phong?.idPhong ?? ""
        phong.tenPhong = tenPhongtft.text!
        phong.donGia = giaPhongtft.getValueString()
        phong.soDien = soDientft.getValueString()
        phong.soNuoc = sotienNuoctft.getValueString()
        
        let parameters: [String: String] = [
            "idPhong" : phong.idPhong,
            "TenPhong" : phong.tenPhong ,
            "DonGia" : phong.donGia,
            "SoDien" : phong.soDien,
            "SoNuoc" : phong.soNuoc,
            "IdNhaTro" : "1"
        ]
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/Phong/AddPhong", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let phongResponse  = Phong.init(json: json)
                    if let phongCopy = phongResponse.copy() as? Phong{
                        Storage.shared.addOrUpdate([phongCopy], type: Phong.self)
                    }
                    Notice.make(type: .Success, content: "Thêm mới phòng thành công! ").show()
                    self.done?(phongResponse)
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/Phong/EditPhong", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let phongResponse  = Phong.init(json: json)
                    if let phongCopy = phongResponse.copy() as? Phong{
                        Storage.shared.addOrUpdate([phongCopy], type: Phong.self)
                    }
                    Notice.make(type: .Success, content: "Sửa mới phòng thành công! ").show()
                    self.done?(phongResponse)
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
