//
//  QLDichVuViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire

class QLDichVuViewController: UIViewController {

    var listDichvu: [DichVu] = [DichVu]()
      let manager = Alamofire.SessionManager()
    
    @IBOutlet weak var tblDichvu: UITableView!
    @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
    @IBOutlet weak var viewBody: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        viewBody.layer.borderWidth = 2.0
        viewBody.layer.borderColor = UIColor.init(netHex: 0x5D7AFF).cgColor
        tblDichvu.delegate = self
        tblDichvu.dataSource = self
        loadDichvu()
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
    
    
    func loadDichvu()  {
        SVProgressHUD.show()
        manager.request("https://localhost:5001/DichVu/GetListDichVu", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listDichvu  = json.arrayValue.map({DichVu.init(json: $0)})
                self.listDichvu.forEach({ (dichvu) in
                    if let dichvuCopy = dichvu.copy() as? DichVu {
                        Storage.shared.addOrUpdate([dichvuCopy], type: DichVu.self)
                    }
                })
                self.tblDichvu.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (200.0 +  70.0 * CGFloat(self.listDichvu.count ))
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription ).show()
                }
                
            }
        }
    }

}

extension QLDichVuViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDichvu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QLDichVuTableViewCell.id, for: indexPath) as! QLDichVuTableViewCell
        cell.binding(dichvu: self.listDichvu[indexPath.row], index: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @IBAction func themMoiDichVu(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditDichVuViewController") as! AddAndEditDichVuViewController
        currentViewController.isCreateNew = true
        currentViewController.done = { dichvuResponse in
            self.listDichvu.append(dichvuResponse)
            self.tblDichvu.reloadData()
            self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listDichvu.count + 60)
        }
        currentViewController.modalPresentationStyle = .overCurrentContext
        self.present(currentViewController, animated: true, completion: nil)
    }
    
}
extension QLDichVuViewController: eventProtocols {
    func eventEdit(_ index: Int) {
        let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditDichVuViewController") as! AddAndEditDichVuViewController
        currentViewController.modalPresentationStyle = .overCurrentContext
        currentViewController.dichvu = self.listDichvu[index].copy() as! DichVu
        currentViewController.isCreateNew = false
        currentViewController.done = { dichvuResponse in
            if let index = self.listDichvu.firstIndex(where: { $0.idDichVu == dichvuResponse.idDichVu }) {
                self.listDichvu[index] = dichvuResponse
                self.tblDichvu.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listDichvu.count + 60)
            }
        }
        self.present(currentViewController, animated: true, completion: nil)
    }
    
    func eventRemove(_ index: Int) {
        let parameters = ["idDichVu": self.listDichvu[index].idDichVu ]
        SVProgressHUD.show()
        manager.request("https://localhost:5001/DichVu/RemoveListDichVu", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                Notice.make(type: .Success, content: "Xoá dịch vụ thành công !").show()
                Storage.shared.delete(DichVu.self, ids: [self.listDichvu[index].idDichVu], idPrefix: "idDichVu")
                self.listDichvu.remove(at: index)
                self.tblDichvu.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listDichvu.count + 60)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
        
    }
    
    
}

