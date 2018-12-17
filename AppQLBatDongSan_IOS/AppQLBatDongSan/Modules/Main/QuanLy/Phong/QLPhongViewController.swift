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

class QLCanHoViewControlvar: UIViewController {
    
    var listCanHo: [CanHo] = [CanHo]()
    let manager = Alamofire.SessionManager()
    var eventChoThue: (()->())?
    
    @IBOutlet weak var tblCanHo: UITableView!
    @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
    @IBOutlet weak var viewBody: UIView!
    
    @IBOutlet weak var btnCreateNew: UIButton!
    var listHopDong: [HopDong] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
        listHopDong = Storage.shared.getObjects(type: HopDong.self) as! [HopDong]
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
            self.constraintHeightViewBody.constant = CGFloat ( 70 + 200 * self.listCanHo.count + 50)
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
                
                if AppState.shared.typeLogin == TypeLogin.NguoiThue.rawValue {
                    guard let khachHangObject = AppState.shared.khachHangObject else { return }
                    if let idCanHo = self.listCanHo.filter({$0.IdCanHo == khachHangObject.IdCanHo}).first?.IdCanHo {
                        self.listCanHo = self.listCanHo.filter({ $0.IdCanHo != idCanHo})
                    }
                    self.btnCreateNew.isHidden = true
                }
                
                self.listCanHo.forEach({ (canHo) in
                    if let canHoCopy = canHo.copy() as? CanHo {
                        Storage.shared.addOrUpdate([canHoCopy], type: CanHo.self)
                    }
                })
                self.tblCanHo.reloadData()
                self.constraintHeightViewBody.constant = CGFloat ( 70 + 200 * self.listCanHo.count + 50)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription ).show()
                }
                
            }
        }
    }
    
}

extension QLCanHoViewControlvar: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCanHo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QLCanHoTableViewCell.id, for: indexPath) as! QLCanHoTableViewCell
        let hopdongObjects = listHopDong.filter({$0.IdCanHo == self.listCanHo[indexPath.row].IdCanHo })
        var isChoThue = true
        
        for item in hopdongObjects {
            if Calendar.current.compare(item.NgayKT.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date(), to: Date(), toGranularity: .day) == .orderedDescending {
                isChoThue = false
                break
            }
        }
        
        cell.binding(canHo: self.listCanHo[indexPath.row], index: indexPath.row, isChoThue: isChoThue)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.white
        }
        let storyboard = UIStoryboard.init(name: "DetailBatDongSan", bundle: nil)
        let currentViewController = storyboard.instantiateViewController(withIdentifier: "CanHoInforViewController") as! CanHoInforViewController
        currentViewController.canHoObject = self.listCanHo[indexPath.row].copy() as? CanHo
        self.present(currentViewController, animated: true, completion: nil)
    }
    
    
}
extension QLCanHoViewControlvar: eventProtocols {
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
                self.constraintHeightViewBody.constant = CGFloat ( 70 + 200 * self.listCanHo.count + 50)
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
                self.constraintHeightViewBody.constant = CGFloat ( 70 + 200 * self.listCanHo.count + 50)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
    }
    
    func eventClickChoThue(_ index: Int) {
        eventChoThue?()
    }
    
    
}

