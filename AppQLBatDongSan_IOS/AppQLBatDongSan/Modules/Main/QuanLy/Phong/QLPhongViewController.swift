//
//  QLPhongViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/21/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire

class QLPhongViewController: UIViewController {
    
    var listPhong: [Phong] = [Phong]()
    let manager = Alamofire.SessionManager()
    
    @IBOutlet weak var tblPhong: UITableView!
    @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
    @IBOutlet weak var viewBody: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        viewBody.layer.borderWidth = 2.0
        viewBody.layer.borderColor = UIColor.init(netHex: 0x5D7AFF).cgColor
        tblPhong.delegate = self
        tblPhong.dataSource = self
        loadPhong()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func themMoiPhong(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditPhongViewController") as! AddAndEditPhongViewController
        currentViewController.isCreateNew = true
        currentViewController.done = { phongResponse in
            self.listPhong.append(phongResponse)
            self.tblPhong.reloadData()
            self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listPhong.count + 60)
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
    
    func loadPhong()  {
        SVProgressHUD.show()
        manager.request("https://localhost:5001/Phong/GetListPhong", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listPhong  = json.arrayValue.map({Phong.init(json: $0)})
                self.listPhong.forEach({ (phong) in
                    if let phongCopy = phong.copy() as? Phong {
                        Storage.shared.addOrUpdate([phongCopy], type: Phong.self)
                    }
                })
                self.tblPhong.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (200.0 +  70.0 * CGFloat(self.listPhong.count ))
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription ).show()
                }
                
            }
        }
    }
    
}

extension QLPhongViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listPhong.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QLPhongTableViewCell.id, for: indexPath) as! QLPhongTableViewCell
        cell.binding(phong: self.listPhong[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension QLPhongViewController: eventProtocols {
    func eventEdit(_ index: Int) {
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditPhongViewController") as! AddAndEditPhongViewController
        currentViewController.modalPresentationStyle = .overCurrentContext
        currentViewController.phong = self.listPhong[index].copy() as! Phong
        currentViewController.isCreateNew = false
        currentViewController.done = { phongResponse in
            if let index = self.listPhong.firstIndex(where: { $0.idPhong == phongResponse.idPhong}) {
                self.listPhong[index] = phongResponse
                self.tblPhong.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listPhong.count + 60)
            }
        }
        self.present(currentViewController, animated: true, completion: nil)
        
    }
    
    func eventRemove(_ index: Int) {
        let parameters = ["idPhong": self.listPhong[index].idPhong ]
        SVProgressHUD.show()
        manager.request("https://localhost:5001/Phong/RemoveListPhong", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                Notice.make(type: .Success, content: "Xoá phòng thành công !").show()
                Storage.shared.delete(NhaTro.self, ids: [self.listPhong[index].idPhong], idPrefix: "idPhong")
                self.listPhong.remove(at: index)
                self.tblPhong.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listPhong.count + 60)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
        
    }
    
    
}

