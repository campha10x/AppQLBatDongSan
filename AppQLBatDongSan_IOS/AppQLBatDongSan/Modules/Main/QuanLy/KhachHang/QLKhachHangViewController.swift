//
//  QLKhachHangViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class QLKhachHangViewController: UIViewController {
    @IBOutlet weak var textfieldSoDienThoai: UITextField!
    
    @IBOutlet weak var tableViewKhachHang: UITableView!
    @IBOutlet weak var textfieldTenKH: UITextField!
    @IBOutlet weak var cbbPhong: MyCombobox!
    @IBOutlet weak var viewBody: UIView!
    @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnCreateNew: UIButton!
    var listKhachHang: [KhachHang] = []
    var listPhong: [Phong] = []
    var listSearchKhachHang: [KhachHang] = []
    let manager = Alamofire.SessionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customized()
        configService()
        loadKhachHang()
        listPhong = Storage.shared.getObjects(type: Phong.self) as! [Phong]
        self.cbbPhong.setOptions(self.listPhong.map({$0.tenPhong}), placeholder: nil, selectedIndex: nil)
        self.cbbPhong.delegate = self
        tableViewKhachHang.delegate = self
        tableViewKhachHang.dataSource = self
        self.listSearchKhachHang = self.listKhachHang
    }

    @IBAction func eventSearchSdt(_ sender: Any) {
        if let sdtText = self.textfieldSoDienThoai.text?.trimmingCharacters(in: .whitespacesAndNewlines), !sdtText.isEmpty {
            self.listSearchKhachHang = self.listKhachHang.filter({ $0.SDT == sdtText })
        } else {
            self.listSearchKhachHang = self.listKhachHang
        }
        self.tableViewKhachHang.reloadData()
    }
    
    @IBAction func eventClickCreateKhachHang(_ sender: Any) {
        let currentViewController: EditListKhachHangViewController = UIStoryboard.init(name: "BatDongSanPopOver", bundle: nil).instantiateViewController(withIdentifier: "EditListKhachHangViewController") as! EditListKhachHangViewController
        currentViewController.done = { khachhangResponse in
            self.listKhachHang.append(khachhangResponse)
            self.listSearchKhachHang = self.listKhachHang
            self.tableViewKhachHang.reloadData()
            self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listSearchKhachHang.count + 60)
        }
        currentViewController.modalPresentationStyle = .overCurrentContext
        self.present(currentViewController, animated: true, completion: nil)
    }
    
    @IBAction func eventSearchKhachHang(_ sender: Any) {
        if let khachHangText = self.textfieldTenKH.text?.trimmingCharacters(in: .whitespacesAndNewlines), !khachHangText.isEmpty {
            self.listSearchKhachHang = self.listKhachHang.filter({ $0.TenKH == khachHangText })
        } else {
            self.listSearchKhachHang = self.listKhachHang
        }
        self.tableViewKhachHang.reloadData()
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
    
    func loadKhachHang() {
            SVProgressHUD.show()
            manager.request("https://localhost:5001/KhachHang/GetListKhachHang", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    self.listKhachHang  = json.arrayValue.map({KhachHang.init(json: $0)})
                    self.listSearchKhachHang = self.listKhachHang
                    self.constraintHeightViewBody.constant = CGFloat (300 +  70.0 * CGFloat(self.listKhachHang.count ?? 0))
                    self.tableViewKhachHang.reloadData()
                    self.listKhachHang.forEach({ (khachhang) in
                        if let khachhangCopy = khachhang.copy() as? KhachHang {
                            Storage.shared.addOrUpdate([khachhangCopy], type: KhachHang.self)
                        }
                    })
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
    }
    
    func customized() {
        viewHeader.layer.borderColor = UIColor.lightGray.cgColor
        viewHeader.layer.borderWidth = 1.0
        btnCreateNew.layer.borderColor = UIColor.red.cgColor
        btnCreateNew.layer.cornerRadius = MyUI.buttonCornerRadius
        btnCreateNew.layer.borderWidth = 1.0
        btnCreateNew.clipsToBounds = true
        btnSearch.layer.cornerRadius = MyUI.buttonCornerRadius
        btnSearch.layer.borderWidth = 1.0
        viewBody.layer.borderWidth = 2.0
        viewBody.layer.borderColor = UIColor.init(netHex: 0x5D7AFF).cgColor
    }
    
}

extension QLKhachHangViewController: MyComboboxDelegate {
    func mycombobox(_ cbb: MyCombobox, selectedAt index: Int) {
        if cbb == cbbPhong {
            let idPhong = self.listPhong[index].idPhong
            self.listSearchKhachHang = self.listKhachHang.filter({ $0.IdPhong == idPhong })
            self.tableViewKhachHang.reloadData()
        }
        
    }
}

extension QLKhachHangViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listSearchKhachHang.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QLKhachHangTableViewCell.id, for: indexPath) as? QLKhachHangTableViewCell
        cell?.delegate = self
        cell?.binding(self.listSearchKhachHang[indexPath.row], indexPath.row)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
extension QLKhachHangViewController: QLKhachHangCellDelegates {
    func eventRemoveKhachHang(_ index: Int) {
        SVProgressHUD.show()
        let parameters = ["IdKhachHang": self.listSearchKhachHang[index].idKhachHang ]
        manager.request("https://localhost:5001/KhachHang/RemoveListKhachHang", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            do {
                Notice.make(type: .Success, content: "Xoá khách hàng thành công !").show()
                Storage.shared.delete(KhachHang.self, ids: [self.listSearchKhachHang[index].idKhachHang], idPrefix: "idKhachHang")
                if let index = self.listKhachHang.index(where: { $0.idKhachHang == self.listSearchKhachHang[index].idKhachHang  } )
                {
                    self.listKhachHang.remove(at: index)
                }
                self.listSearchKhachHang.remove(at: index)
                self.tableViewKhachHang.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listSearchKhachHang.count + 60)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
    }
    
    func eventEditKhachHang(_ index: Int) {
        let vc: EditListKhachHangViewController = UIStoryboard.init(name: "BatDongSanPopOver", bundle: nil).instantiateViewController(withIdentifier: "EditListKhachHangViewController") as! EditListKhachHangViewController
        
        vc.done = { khachHangResponse in
            if let index = self.listKhachHang.firstIndex(where: { $0.idKhachHang == khachHangResponse.idKhachHang}) {
                self.listKhachHang[index] = khachHangResponse
                self.listSearchKhachHang = self.listKhachHang
                self.tableViewKhachHang.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listSearchKhachHang.count + 60)
            }
        }
        vc.isCreateNew = false
        vc.modalPresentationStyle = .overCurrentContext
        vc.khachhang = self.listSearchKhachHang[index]
        vc.index = index
        self.present(vc, animated: true, completion: nil)
    }
}
