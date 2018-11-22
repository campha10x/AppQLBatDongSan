//
//  QLNhaTroViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/21/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import SVProgressHUD
import SwiftyJSON
import Alamofire

class QLNhaTroViewController: UIViewController {

    var listNhaTro: [NhaTro] = [NhaTro]()
    let manager = Alamofire.SessionManager()
    
    
    @IBOutlet weak var tblNhaTro: UITableView!
    @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
    @IBOutlet weak var viewBody: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBody.layer.borderWidth = 2.0
        viewBody.layer.borderColor = UIColor.init(netHex: 0x5D7AFF).cgColor
        tblNhaTro.delegate = self
        tblNhaTro.dataSource = self
        configService()
        loadNhatro()
        // Do any additional setup after loading the view.
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
    
    @IBAction func themMoiNhaTro(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditNhaTroViewController") as! AddAndEditNhaTroViewController
        currentViewController.isCreateNew = true
        currentViewController.done = { nhatroResponse in
            self.listNhaTro.append(nhatroResponse)
            self.tblNhaTro.reloadData()
            self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listNhaTro.count + 60)
        }
        currentViewController.modalPresentationStyle = .overCurrentContext
        self.present(currentViewController, animated: true, completion: nil)
    }
    
    func loadNhatro()  {
        SVProgressHUD.show()
        manager.request("https://localhost:5001/NhaTro/GetListNhaTro", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listNhaTro  = json.arrayValue.map({NhaTro.init(json: $0)})
                self.listNhaTro.forEach({ (nhatro) in
                    if let nhatroCopy = nhatro.copy() as? NhaTro {
                        Storage.shared.addOrUpdate([nhatroCopy], type: NhaTro.self)
                    }
                })
                self.tblNhaTro.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (200.0 +  70.0 * CGFloat(self.listNhaTro.count ))
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
    }

}

extension QLNhaTroViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNhaTro.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QLNhaTroTableViewCell.id, for: indexPath) as! QLNhaTroTableViewCell
        cell.binding(nhatro: self.listNhaTro[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension QLNhaTroViewController: eventProtocols {
    func eventEdit(_ index: Int) {
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditNhaTroViewController") as! AddAndEditNhaTroViewController
        currentViewController.modalPresentationStyle = .overCurrentContext
        currentViewController.nhatro = self.listNhaTro[index].copy() as! NhaTro
        currentViewController.isCreateNew = false
        currentViewController.done = { nhatroResponse in
            if let index = self.listNhaTro.firstIndex(where: { $0.idNhaTro == nhatroResponse.idNhaTro}) {
                self.listNhaTro[index] = nhatroResponse
                self.tblNhaTro.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listNhaTro.count + 60)
            }
        }
        self.present(currentViewController, animated: true, completion: nil)
        
    }
    
    func eventRemove(_ index: Int) {
        let parameters = ["idNhaTro": self.listNhaTro[index].idNhaTro ]
        SVProgressHUD.show()
        manager.request("https://localhost:5001/NhaTro/RemoveListNhaTro", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                Notice.make(type: .Success, content: "Xoá nhà trọ thành công !").show()
                Storage.shared.delete(NhaTro.self, ids: [self.listNhaTro[index].idNhaTro], idPrefix: "idNhaTro")
                self.listNhaTro.remove(at: index)
                self.tblNhaTro.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listNhaTro.count + 60)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
        
    }
    
    
}

