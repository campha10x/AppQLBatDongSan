//
//  PhieuThuViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/10/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class ListPhieuThuViewController: UIViewController {

    @IBOutlet weak var tblPhieuThu: UITableView!
    @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var labelTongCong: UILabel!
    
    var listPhieuThu: [PhieuThu] = []
    let manager = Alamofire.SessionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        loadPhieuThu()
        viewBody.layer.borderWidth = 2.0
        viewBody.layer.borderColor = UIColor.init(netHex: 0x5D7AFF).cgColor
        tblPhieuThu.delegate = self
        tblPhieuThu.dataSource = self
        tblPhieuThu.allowsSelection = false
    }
    
    func loadPhieuThu() {
        SVProgressHUD.show()
        manager.request("https://localhost:5001/PhieuThu/GetListPhieuThu", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listPhieuThu  = json.arrayValue.map({PhieuThu.init(json: $0)})
                self.listPhieuThu.forEach({ (phieuthu) in
                    if let phieuthuCopy = phieuthu.copy() as? PhieuThu {
                        Storage.shared.addOrUpdate([phieuthuCopy], type: PhieuThu.self)
                    }
                })
                self.reCaculatorAmountPhieuThu()
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
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
    
    func reCaculatorAmountPhieuThu() {
        let tongtien: Double = self.listPhieuThu.reduce(0) { (obj1, obj2) -> Double in
            return (Double(obj1) + Double(obj2.SoTien)! )
        }
        self.labelTongCong.text = "\(tongtien)".toNumberString(decimal: false)
        self.tblPhieuThu.reloadData()
        self.constraintHeightViewBody.constant = CGFloat (200.0 +  70.0 * CGFloat(self.listPhieuThu.count ?? 0))
    }
    
    func removePhieuThu(_ index: Int)  {
        SVProgressHUD.show()
        let parameters = ["IdPhieuThu": self.listPhieuThu[index].IdPhieuThu ]
        
        manager.request("https://localhost:5001/PhieuThu/RemoveListPhieuThu", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            if let error = responseObject.error {
                Notice.make(type: .Error, content: error.localizedDescription).show()
            } else {
                Notice.make(type: .Success, content: "Xoá phiếu thu thành công !").show()
                let idPhieuThu = self.listPhieuThu[index].IdPhieuThu
                self.listPhieuThu.remove(at: index)
                Storage.shared.delete(PhieuThu.self, ids: [idPhieuThu], idPrefix: "IdPhieuThu")
                self.reCaculatorAmountPhieuThu()
            }
        }
    }
    
}

extension ListPhieuThuViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPhieuThu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListPhieuThuTableViewCell.id, for: indexPath) as! ListPhieuThuTableViewCell
        cell.binding(phieuthu: listPhieuThu[indexPath.row], index: indexPath.row)
        cell.onRemovePhieuThu = { index in
            self.removePhieuThu(index)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
