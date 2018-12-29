//
//  PhieuChiViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/15/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class PhieuChiViewController: UIViewController {
    var listPhieuChi: [PhieuChi] = [PhieuChi]()
    
    @IBOutlet weak var tblPhieuChi: UITableView!
    @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var labelTongCong: UILabel!
    let manager = Alamofire.SessionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        viewBody.layer.borderWidth = 2.0
        viewBody.layer.borderColor = UIColor.init(netHex: 0x5D7AFF).cgColor
        tblPhieuChi.delegate = self
        tblPhieuChi.dataSource = self
        tblPhieuChi.allowsSelection = false
        loadPhieuChi()
  
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
    
    func reCaculatorAmountPhieuChi() {
        let tongtien: Double = self.listPhieuChi.reduce(0) { (obj1, obj2) -> Double in
            return (Double(obj1) + Double(obj2.Sotien)! )
        }
        self.labelTongCong.text = "\(tongtien)".toNumberString(decimal: false)
        self.constraintHeightViewBody.constant = CGFloat (200.0 +  70.0 * CGFloat(self.listPhieuChi.count ))
        self.tblPhieuChi.reloadData()
    }
    
    func loadPhieuChi()  {
        SVProgressHUD.show()
        manager.request("https://localhost:5001/PhieuChi/GetListPhieuChi", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listPhieuChi  = json.arrayValue.map({PhieuChi.init(json: $0)})
                self.listPhieuChi.forEach({ (phieuchi) in
                    if let phieuchiCopy = phieuchi.copy() as? PhieuChi {
                        Storage.shared.addOrUpdate([phieuchiCopy], type: PhieuChi.self)
                    }
                })
                self.reCaculatorAmountPhieuChi()
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
    }


    
    @IBAction func ThemMoiPhieuChi(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "BatDongSanPopOver", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "EditPhieuChiViewController") as! EditPhieuChiViewController
        currentViewController.onUpdatePhieuChi = { (phieuchiResponse) in
            self.listPhieuChi.append(phieuchiResponse)
            self.tblPhieuChi.reloadData()
            self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listPhieuChi.count + 60)
            self.reCaculatorAmountPhieuChi()
        }
        
        currentViewController.modalPresentationStyle = .overCurrentContext
        self.present(currentViewController, animated: true, completion: nil)
    }
    

}

extension PhieuChiViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPhieuChi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListPhieuChiTableViewCell.id, for: indexPath) as! ListPhieuChiTableViewCell
        cell.binding(phieuchi: self.listPhieuChi[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension PhieuChiViewController: eventProtocols {
    func eventEdit(_ index: Int) {
        let vc: EditPhieuChiViewController = UIStoryboard.init(name: "BatDongSanPopOver", bundle: nil).instantiateViewController(withIdentifier: "EditPhieuChiViewController") as! EditPhieuChiViewController
        vc.isCreateNew = false
        vc.onUpdatePhieuChi = { (phieuchiResponse) in
            if let index = self.listPhieuChi.firstIndex(where: { $0.IdPhieuChi == phieuchiResponse.IdPhieuChi}) {
                self.listPhieuChi[index] = phieuchiResponse
                self.tblPhieuChi.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listPhieuChi.count + 60)
                self.reCaculatorAmountPhieuChi()
            }
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.phieuchi = self.listPhieuChi[index]
        self.present(vc, animated: true, completion: nil)
    }
    
    func eventRemove(_ index: Int) {
        SVProgressHUD.show()
        let parameters = ["IdPhieuChi": self.listPhieuChi[index].IdPhieuChi ]
        manager.request("https://localhost:5001/PhieuChi/RemoveListPhieuChi", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()

            if let error = responseObject.error {
                Notice.make(type: .Error, content: error.localizedDescription).show()
            } else {
                Notice.make(type: .Success, content: "Xoá phiếu chi thành công !").show()
                let idPhieuChi = self.listPhieuChi[index].IdPhieuChi
                self.listPhieuChi.remove(at: index)
                Storage.shared.delete(PhieuChi.self, ids: [idPhieuChi], idPrefix: "IdPhieuChi")
                self.reCaculatorAmountPhieuChi()
            }
        }
    }
    
    
}

