//
//  QLDonViViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/27/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SVProgressHUD
import SwiftyJSON

class QLDonViViewController: UIViewController {

    var listDonvi: [DonVi] = [DonVi]()
    let manager = Alamofire.SessionManager()
    
    @IBOutlet weak var tblDonVi: UITableView!
    @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
    @IBOutlet weak var viewBody: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        viewBody.layer.borderWidth = 2.0
        viewBody.layer.borderColor = UIColor.init(netHex: 0x5D7AFF).cgColor
        tblDonVi.delegate = self
        tblDonVi.dataSource = self
        loadDonvi()
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
    
    func loadDonvi()  {
        SVProgressHUD.show()
        manager.request("https://localhost:5001/DonVi/GetListDonVi", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listDonvi  = json.arrayValue.map({DonVi.init(json: $0)})
                self.listDonvi.forEach({ (donvi) in
                    if let donviCopy = donvi.copy() as? Phong {
                        Storage.shared.addOrUpdate([donviCopy], type: DonVi.self)
                    }
                })
                self.tblDonVi.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (200.0 +  70.0 * CGFloat(self.listDonvi.count ))
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription ).show()
                }
                
            }
        }
    }
    
}

extension QLDonViViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDonvi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QLDonViTableViewCell.id, for: indexPath) as! QLDonViTableViewCell
        cell.binding(donvi: self.listDonvi[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension QLDonViViewController: eventProtocols {
    func eventEdit(_ index: Int) {
//                let vc: EditPhieuChiViewController = UIStoryboard.init(name: "BatDongSanPopOver", bundle: nil).instantiateViewController(withIdentifier: "EditPhieuChiViewController") as! EditPhieuChiViewController
//                vc.onUpdatePhieuChi = { (phieuchi) in
//                    self.listPhieuChi.append(phieuchi)
//                    self.tblPhieuChi.reloadData()
//                }
//                vc.modalPresentationStyle = .overCurrentContext
//                vc.phieuchi = self.listPhieuChi[index]
//                self.present(vc, animated: true, completion: nil)
    }
    
    func eventRemove(_ index: Int) {
        let parameters = ["idDonVi": self.listDonvi[index].idDonVi ]
        SVProgressHUD.show()
        manager.request("https://localhost:5001/DonVi/RemoveListDonVi", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                Notice.make(type: .Success, content: "Xoá đơn vị thành công !").show()
                Storage.shared.delete(NhaTro.self, ids: [self.listDonvi[index].idDonVi], idPrefix: "idDonVi")
                self.listDonvi.remove(at: index)
                self.tblDonVi.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listDonvi.count + 60)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
    }
    
    
}
