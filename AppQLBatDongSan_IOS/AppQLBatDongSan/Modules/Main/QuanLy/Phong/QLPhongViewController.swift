//
//  QLCanHoViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/21/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire

class QLCanHoViewController: UIViewController {
    
    var listCanHo: [CanHo] = [CanHo]()
    let manager = Alamofire.SessionManager()
    
    @IBOutlet weak var tblCanHo: UITableView!
    @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
    @IBOutlet weak var viewBody: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        viewBody.layer.borderWidth = 2.0
        viewBody.layer.borderColor = UIColor.init(netHex: 0x5D7AFF).cgColor
        tblCanHo.delegate = self
        tblCanHo.dataSource = self
        loadCanHo()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func themMoiCanHo(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditCanHoViewController") as! AddAndEditCanHoViewController
        currentViewController.isCreateNew = true
        currentViewController.done = { CanHoResponse in
            self.listCanHo.append(CanHoResponse)
            self.tblCanHo.reloadData()
            self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listCanHo.count + 60)
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
    
    func loadCanHo()  {
        SVProgressHUD.show()
        manager.request("https://localhost:5001/CanHo/GetListCanHo", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listCanHo  = json.arrayValue.map({CanHo.init(json: $0)})
                self.listCanHo.forEach({ (canHo) in
                    if let canHoCopy = canHo.copy() as? CanHo {
                        Storage.shared.addOrUpdate([canHoCopy], type: CanHo.self)
                    }
                })
                self.tblCanHo.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (200.0 +  70.0 * CGFloat(self.listCanHo.count ))
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription ).show()
                }
                
            }
        }
    }
    
}

extension QLCanHoViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCanHo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QLCanHoTableViewCell.id, for: indexPath) as! QLCanHoTableViewCell
        cell.binding(canHo: self.listCanHo[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension QLCanHoViewController: eventProtocols {
    func eventEdit(_ index: Int) {
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditCanHoViewController") as! AddAndEditCanHoViewController
        currentViewController.modalPresentationStyle = .overCurrentContext
        currentViewController.canHo = self.listCanHo[index].copy() as! CanHo
        currentViewController.isCreateNew = false
        currentViewController.done = { canHoResponse in
            if let index = self.listCanHo.firstIndex(where: { $0.IdCanHo == canHoResponse.IdCanHo}) {
                self.listCanHo[index] = canHoResponse
                self.tblCanHo.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listCanHo.count + 60)
            }
        }
        self.present(currentViewController, animated: true, completion: nil)
        
    }
    
    func eventRemove(_ index: Int) {
        let parameters = ["IdCanHo": self.listCanHo[index].IdCanHo ]
        SVProgressHUD.show()
        manager.request("https://localhost:5001/CanHo/RemoveListCanHo", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                Notice.make(type: .Success, content: "Xoá căn hộ thành công !").show()
                Storage.shared.delete(CanHo.self, ids: [self.listCanHo[index].IdCanHo], idPrefix: "IdCanHo")
                self.listCanHo.remove(at: index)
                self.tblCanHo.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listCanHo.count + 60)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
        
    }
    
    
}

