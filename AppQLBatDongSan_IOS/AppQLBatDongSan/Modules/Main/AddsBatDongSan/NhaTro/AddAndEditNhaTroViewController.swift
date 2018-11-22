//
//  AddAndEditNhaTroViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 11/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class AddAndEditNhaTroViewController: UIViewController {

    @IBOutlet weak var tvGhiChu: UITextView!
    @IBOutlet weak var tfTenNhaTro: MyTextField!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    var isCreateNew: Bool = true
    var nhatro: NhaTro? = nil
    var done: ((_ nhatro: NhaTro)->())?
    let manager = Alamofire.SessionManager()
    
    override func viewDidLoad() {

        configService()
        labelHeaderTitle.text = isCreateNew == true ? "Tạo nhà trọ" : "Sửa nhà trọ"
        if !isCreateNew {
            tvGhiChu.text = nhatro?.ghiChu
            tfTenNhaTro.text = nhatro?.tenNhaTro
        } else {
            
        }
        tvGhiChu.layer.cornerRadius = 4.0
        tvGhiChu.layer.borderColor = UIColor.lightGray.cgColor
        tvGhiChu.layer.borderWidth = 1.0
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
        let nhatro = NhaTro()
        
        nhatro.idNhaTro = isCreateNew ? "" : self.nhatro?.idNhaTro ?? ""
        nhatro.tenNhaTro = tfTenNhaTro.text!
        nhatro.ghiChu = tvGhiChu.text!
        
        let parameters: [String: String] = [
            "idNhaTro" : nhatro.idNhaTro,
            "TenNhaTro" : nhatro.tenNhaTro ,
            "GhiChu" : nhatro.ghiChu
        ]
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/NhaTro/AddNhaTro", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let nhatroResponse  = NhaTro.init(json: json)
                    if let nhatroCopy = nhatroResponse.copy() as? NhaTro{
                        Storage.shared.addOrUpdate([nhatroCopy], type: NhaTro.self)
                    }
                    Notice.make(type: .Success, content: "Thêm mới nhà trọ thành công! ").show()
                    self.done?(nhatroResponse)
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/NhaTro/EditNhaTro", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let nhatroResponse  = NhaTro.init(json: json)
                    if let nhatroCopy = nhatroResponse.copy() as? NhaTro{
                        Storage.shared.addOrUpdate([nhatroCopy], type: NhaTro.self)
                    }
                    Notice.make(type: .Success, content: "Sửa mới nhà trọ thành công! ").show()
                    self.done?(nhatroResponse)
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
