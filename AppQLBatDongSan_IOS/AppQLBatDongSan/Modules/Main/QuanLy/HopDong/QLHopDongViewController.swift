//
//  QLHopDongViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 11/3/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class QLHopDongViewController: UIViewController {
    
    @IBOutlet weak var tblHopDong: UITableView!
    @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
    @IBOutlet weak var viewBody: UIView!
    
    @IBOutlet weak var btnCreateNew: UIButton!
    var listHopDong: [HopDong] = [HopDong]()
    let manager = Alamofire.SessionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        viewBody.layer.borderWidth = 2.0
        viewBody.layer.borderColor = UIColor.init(netHex: 0x5D7AFF).cgColor
        tblHopDong.delegate = self
        tblHopDong.dataSource = self
        loadHopDong()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func themMoiHopDong(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddListBatDongSanViewController") as! AddAndEditHopDongViewController
        currentViewController.done = { hopdongResponse in
            self.listHopDong.append(hopdongResponse)
            self.tblHopDong.reloadData()
            self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listHopDong.count + 60)

        }
        currentViewController.modalPresentationStyle = .overCurrentContext
        self.present(currentViewController, animated: true, completion: nil)
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
    
    func loadHopDong()  {
        SVProgressHUD.show()
        manager.request("https://localhost:5001/HopDong/GetListHopDong", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listHopDong  = json.arrayValue.map({HopDong.init(json: $0)})
                
                if AppState.shared.typeLogin == TypeLogin.NguoiThue.rawValue {
                    guard let khachHangObject = AppState.shared.khachHangObject else { return }
                    if let idKhachHang = self.listHopDong.filter({$0.IdKhachHang == khachHangObject.idKhachHang}).first?.IdKhachHang {
                        self.listHopDong = self.listHopDong.filter({ $0.IdKhachHang == idKhachHang})
                    }
                    self.btnCreateNew.isHidden = true
                }
                
                self.listHopDong.forEach({ (hopdong) in
                    if let hopdongCopy = hopdong.copy() as? HopDong {
                        Storage.shared.addOrUpdate([hopdongCopy], type: HopDong.self)
                    }
                })
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listHopDong.count + 60)
                self.tblHopDong.reloadData()
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
    }

}

extension QLHopDongViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listHopDong.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QLHopDongTableViewCell.id, for: indexPath) as? QLHopDongTableViewCell
        cell?.delegate = self
        cell?.binding(hopdong: self.listHopDong[indexPath.row], index: indexPath.row)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension QLHopDongViewController: eventProtocols {
    func eventEdit(_ index: Int) {
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddListBatDongSanViewController") as! AddAndEditHopDongViewController
        currentViewController.modalPresentationStyle = .overCurrentContext
        currentViewController.hopdong = self.listHopDong[index].copy() as? HopDong
        currentViewController.isCreateNew = false
        currentViewController.done = { hopdongResponse in
            if let index = self.listHopDong.firstIndex(where: { $0.IdHopDong == hopdongResponse.IdHopDong}) {
                self.listHopDong[index] = hopdongResponse
                self.tblHopDong.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listHopDong.count + 60)
            }
        }
        self.present(currentViewController, animated: true, completion: nil)
    }
    
    func eventRemove(_ index: Int) {
        SVProgressHUD.show()
        let parameters = ["idHopDong": self.listHopDong[index].IdHopDong ]
        SVProgressHUD.show()
        manager.request("https://localhost:5001/HopDong/RemoveListHopDong", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                Notice.make(type: .Success, content: "Xoá hợp đồng thành công !").show()
                Storage.shared.delete(HopDong.self, ids: [self.listHopDong[index].IdHopDong], idPrefix: "IdHopDong")
                self.listHopDong.remove(at: index)
                self.tblHopDong.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listHopDong.count + 60)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
    }
    
    func eventShowHopDong(_ index: Int) {
        if let vc = UIStoryboard.init(name: "DetailBatDongSan", bundle: nil).instantiateViewController(withIdentifier: "HopDongInforViewController") as? HopDongInforViewController {
            vc.hopDongObject = self.listHopDong[index]
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}


