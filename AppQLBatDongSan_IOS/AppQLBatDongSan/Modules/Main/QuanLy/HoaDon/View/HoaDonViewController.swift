    //
    //  HoaDonViewController.swift
    //  AppQLBatDongSan
    //
    //  Created by User on 9/30/18.
    //  Copyright © 2018 User. All rights reserved.
    //
    
    import UIKit
    import SVProgressHUD
    import SwiftyJSON
    import Alamofire
    
    
    enum StateRoom: String {
        case DaThanhToan = "Đã thanh toán"
        case ChuaThanhToan = "Chưa thanh toán"
    }
    
    class HoaDonViewController: UIViewController {
        
        @IBOutlet weak var btnCreateNew: UIButton!
        @IBOutlet weak var viewHeader: UIView!
        @IBOutlet weak var tableViewHoaDon: UITableView!
        @IBOutlet weak var btnSearch: UIButton!
        
        @IBOutlet weak var cbbCanHo: MyCombobox!
        @IBOutlet weak var cbbThang: MyCombobox!
        @IBOutlet weak var cbbTrangThai: MyCombobox!
        @IBOutlet weak var textFieldSoPhieu: UITextField!
        
        @IBOutlet weak var viewBody: UIView!
        @IBOutlet weak var constraintHeightViewBody: NSLayoutConstraint!
        
        let manager = Alamofire.SessionManager()
        
        var stateRooms: [String] = [StateRoom.DaThanhToan.rawValue, StateRoom.ChuaThanhToan.rawValue]
        var months: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        
        var listSearchHoaDon: [HoaDon] = [HoaDon]()
        var listHoaDon: [HoaDon] = [HoaDon]()
        var listCanHo: [CanHo] = [CanHo]()
        var listPhieuThu: [PhieuThu] = [PhieuThu]()
        
        let heightTableHoaDon: CGFloat = 70
        var dispatch : DispatchGroup?
        
        var listHopDong: [HopDong] = []
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationController?.navigationBar.isHidden = true
            configService()
            customized()
            dispatch = DispatchGroup()
            loadCanHo()
            loadCanHo_DichVu()
            loadHoaDon()
            loadListPhieuThu()
            loadHopDong()
            loadDichvu()
            loadHopDong_DichVu()
            dispatch?.notify(queue: .main, execute: {
                if AppState.shared.typeLogin == TypeLogin.ChuCanho.rawValue {
                    
                } else {
                    self.btnCreateNew.isHidden = true
                    guard let khachHangObject = AppState.shared.khachHangObject else { return }
                    if let idCanHo = self.listHopDong.filter({$0.IdKhachHang == khachHangObject.idKhachHang}).first?.IdCanHo {
                        self.listHoaDon = self.listHoaDon.filter({ $0.IdCanHo == idCanHo})
                        self.listSearchHoaDon = self.listHoaDon
                    } else {
                        self.listSearchHoaDon = []
                    }
                }
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listSearchHoaDon.count + 60)
                self.tableViewHoaDon.reloadData()
            })
            textFieldSoPhieu.delegate = self
            tableViewHoaDon.dataSource = self
            tableViewHoaDon.delegate = self
            cbbTrangThai.setOptions(stateRooms, placeholder: nil, selectedIndex: nil)
            cbbTrangThai.delegate = self
            cbbThang.setOptions(months, placeholder: nil, selectedIndex: nil)
            cbbThang.delegate = self
            tableViewHoaDon.allowsSelection = false
        }
        
        func loadDichvu()  {
            SVProgressHUD.show()
            dispatch?.enter()
            manager.request("https://localhost:5001/DichVu/GetListDichVu", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                self.dispatch?.leave()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let listDichvu: [DichVu]  = json.arrayValue.map({DichVu.init(json: $0)})
                    listDichvu.forEach({ (dichvu) in
                        if let dichvuCopy = dichvu.copy() as? DichVu {
                            Storage.shared.addOrUpdate([dichvuCopy], type: DichVu.self)
                        }
                    })
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription ).show()
                    }
                    
                }
            }
        }
        
        func loadCanHo_DichVu()  {
            SVProgressHUD.show()
            dispatch?.enter()
            manager.request("https://localhost:5001/CanHo_DichVu/GetListCanHo_DichVu", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
                self.dispatch?.leave()
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    var listCanHo_DichVu: [CanHo_DichVu] = []
                    listCanHo_DichVu = json.arrayValue.map({CanHo_DichVu.init(json: $0)})
                    listCanHo_DichVu.forEach({ (canHo) in
                        if let canHoCopy = canHo.copy() as? CanHo_DichVu {
                            Storage.shared.addOrUpdate([canHoCopy], type: CanHo_DichVu.self)
                        }
                    })
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription ).show()
                    }
                    
                }
            }
        }
        func loadHopDong_DichVu()  {
            SVProgressHUD.show()
            dispatch?.enter()
            manager.request("https://localhost:5001/HopDong_DichVu/GetListHopDong_DichVu", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
                self.dispatch?.leave()
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    var listCanHo_DichVu: [HopDong_DichVu] = []
                    listCanHo_DichVu = json.arrayValue.map({HopDong_DichVu.init(json: $0)})
                    listCanHo_DichVu.forEach({ (canHo) in
                        if let canHoCopy = canHo.copy() as? HopDong_DichVu {
                            Storage.shared.addOrUpdate([canHoCopy], type: HopDong_DichVu.self)
                        }
                    })
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription ).show()
                    }
                    
                }
            }
        }
        
        func customized() {
            cbbCanHo.textColor = MyColor.veryblack
            cbbCanHo.dropdownBackgroundColor = MyColor.quiteLightcyan
            cbbCanHo.dropdownForcegroundColor = MyColor.white
            cbbThang.textColor = MyColor.veryblack
            cbbThang.dropdownBackgroundColor = MyColor.quiteLightcyan
            cbbThang.dropdownForcegroundColor = MyColor.white
            cbbTrangThai.textColor = MyColor.veryblack
            cbbTrangThai.dropdownBackgroundColor = MyColor.quiteLightcyan
            cbbTrangThai.dropdownForcegroundColor = MyColor.white
            
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
        
        
        func loadHopDong()  {
            dispatch?.enter()
            SVProgressHUD.show()
            manager.request("https://localhost:5001/HopDong/GetListHopDong", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                self.dispatch?.leave()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let listHopDong  = json.arrayValue.map({HopDong.init(json: $0)})
                    listHopDong.forEach({ (hopdong) in
                        if let hopdongCopy = hopdong.copy() as? HopDong {
                            Storage.shared.addOrUpdate([hopdongCopy], type: HopDong.self)
                        }
                    })
                    self.listHopDong = listHopDong
                    
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
        
        func loadListPhieuThu()  {
            dispatch?.enter()
            SVProgressHUD.show()
            manager.request("https://localhost:5001/PhieuThu/GetListPhieuThu", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                self.dispatch?.leave()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    self.listPhieuThu  = json.arrayValue.map({PhieuThu.init(json: $0)})
                    Storage.shared.addOrUpdate(self.listPhieuThu, type: PhieuThu.self)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription ).show()
                    }
                }
            }
        }
        
        func loadHoaDon() {
            dispatch?.enter()
            SVProgressHUD.show()
            manager.request("https://localhost:5001/HoaDon/GetListHoaDon", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                self.dispatch?.leave()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    self.listHoaDon  = json.arrayValue.map({HoaDon.init(json: $0)})
                    self.listSearchHoaDon = self.listHoaDon
                    self.listHoaDon.forEach({ (hoadon) in
                        if let hoadon = hoadon.copy() as? HoaDon {
                            Storage.shared.addOrUpdate([hoadon], type: HoaDon.self)
                        }
                    })
                    
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        }
        
        func loadCanHo() {
            dispatch?.enter()
            SVProgressHUD.show()
            manager.request("https://localhost:5001/CanHo/GetListCanHo", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                self.dispatch?.leave()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    self.listCanHo  = json.arrayValue.map({CanHo.init(json: $0)})
                    if AppState.shared.typeLogin == TypeLogin.NguoiThue.rawValue {
                        guard let khachHangObject = AppState.shared.khachHangObject else { return }
                        if let idCanHo = self.listCanHo.filter({$0.IdCanHo == khachHangObject.IdCanHo}).first?.IdCanHo {
                            self.listCanHo = self.listCanHo.filter({ $0.IdCanHo == idCanHo})
                        }
                    }
                    Storage.shared.addOrUpdate(self.listCanHo, type: CanHo.self)
                    self.cbbCanHo.setOptions(self.listCanHo.map({$0.maCanHo}), placeholder: nil, selectedIndex: nil)
                    self.cbbCanHo.delegate = self
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
            
        }
        
        
        @IBAction func eventChangeSoPhieu(_ sender: Any) {
            if let soPhieuText = self.textFieldSoPhieu.text?.trimmingCharacters(in: .whitespacesAndNewlines), !soPhieuText.isEmpty {
                self.listSearchHoaDon = self.listHoaDon.filter({ $0.soPhieu.lowercased().contains(soPhieuText.lowercased()) })
            } else {
                self.listSearchHoaDon = self.listHoaDon
            }
            self.tableViewHoaDon.reloadData()
        }
        
        @IBAction func eventCreateNewHoaDon(_ sender: Any) {
            let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
            let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditHoaDonViewController") as! AddAndEditHoaDonViewController
            currentViewController.done = { hoadonResponse in
                self.listHoaDon.append(hoadonResponse)
                self.listSearchHoaDon = self.listHoaDon
                self.tableViewHoaDon.reloadData()
                self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listSearchHoaDon.count + 60)
            }
            currentViewController.modalPresentationStyle = .overCurrentContext
            self.present(currentViewController, animated: true, completion: nil)
        }
        
        func returnMonth(ngayTao: String) -> Int {
            if let ngayTaoConvert = ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") {
                return Calendar.current.component(.month, from: ngayTaoConvert)
            } else {
                return 0
            }
            
        }
        
    }
    
    extension HoaDonViewController: MyComboboxDelegate {
        func mycombobox(_ cbb: MyCombobox, selectedAt index: Int) {
            if cbb == cbbCanHo {
                let IdCanHo = self.listCanHo[index].IdCanHo
                self.listSearchHoaDon = self.listHoaDon.filter({ $0.IdCanHo == IdCanHo })
                self.tableViewHoaDon.reloadData()
            } else if cbb == cbbThang {
                let thang = Int(self.months[index])
                self.listSearchHoaDon = self.listHoaDon.filter({ returnMonth(ngayTao: $0.ngayTao) == thang })
                self.tableViewHoaDon.reloadData()
            } else if cbb == cbbTrangThai {
                let stateRoom = self.stateRooms[index]
                if stateRoom == StateRoom.DaThanhToan.rawValue {
                    //                self.listSearchHoaDon = self.listHoaDon.filter({ (Double($0.soTien) ?? 0) - datra == 0 })
                    self.listSearchHoaDon = self.listHoaDon.filter({ (item) -> Bool in
                        let datra = listPhieuThu.filter({ $0.IdHoaDon == item.idHoaDon }).reduce(0, ( { $0 + (Double($1.SoTien) ?? 0) }))
                        return (Double(item.soTien) ?? 0 ) - datra == 0
                    })
                } else {
                    self.listSearchHoaDon = self.listHoaDon.filter({ (item) -> Bool in
                        let datra = listPhieuThu.filter({ $0.IdHoaDon == item.idHoaDon }).reduce(0, ( { $0 + (Double($1.SoTien) ?? 0) }))
                        return (Double(item.soTien) ?? 0 ) - datra != 0
                    })
                }
                self.tableViewHoaDon.reloadData()
            }
            
        }
    }
    
    extension HoaDonViewController: UITableViewDataSource, UITableViewDelegate {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.listSearchHoaDon.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuanLiTableViewCell", for: indexPath) as? QuanLiTableViewCell
            var datra: Double = 0
            let list = listPhieuThu.filter({ $0.IdHoaDon == self.listHoaDon[indexPath.row].idHoaDon })
            if list.count > 0 {
                datra = list.reduce(0.0, { $0 + (Double($1.SoTien) ?? 0) })
            }
            cell?.onChiTietHoaDon = { (_ index: Int) in
                self.eventEdit(index)
            }
            cell?.onMoney = { (_ index: Int) in
                let vc: PhieuThuViewController = UIStoryboard.init(name: "BatDongSanPopOver", bundle: nil).instantiateViewController(withIdentifier: "PhieuThuViewController") as! PhieuThuViewController
                vc.onUpdatePhieuThu = { (phieuthu) in
                    self.listPhieuThu.append(phieuthu)
                    self.tableViewHoaDon.reloadData()
                }
                vc.modalPresentationStyle = .overCurrentContext
                vc.hoadon = self.listHoaDon[index]
                vc.datra =  datra
                self.present(vc, animated: true, completion: nil)
                
            }
            cell?.eventClickShowHoaDon = { (_ index: Int) in
                self.eventClickShowHoaDon(index)
            }
            cell?.onRemove = { (_ index: Int) in
                self.removeHoaDon(index)
            }
            let maCanHo = self.listCanHo.filter({$0.IdCanHo == self.listSearchHoaDon[indexPath.row].IdCanHo } ).first?.maCanHo ?? "None"
            cell?.backgroundColor = (indexPath.row % 2 == 0 ? UIColor.gray : UIColor.white)
            cell?.bindding(index: indexPath.row, obj: listSearchHoaDon[indexPath.row], datra: datra, maCanHo: maCanHo)
            return cell!
        }
        
        func eventEdit(_ index: Int) {
            let storyboard = UIStoryboard.init(name: "AddBatDongSan", bundle: nil)
            let currentViewController = storyboard.instantiateViewController(withIdentifier: "AddAndEditHoaDonViewController") as! AddAndEditHoaDonViewController
            currentViewController.modalPresentationStyle = .overCurrentContext
            currentViewController.hoadon = self.listSearchHoaDon[index].copy() as! HoaDon
            currentViewController.isCreateNew = false
            currentViewController.done = { hoadonResponse in
                if let index = self.listHoaDon.firstIndex(where: { $0.idHoaDon == hoadonResponse.idHoaDon}) {
                    self.listHoaDon[index] = hoadonResponse
                    self.listSearchHoaDon = self.listHoaDon
                    self.tableViewHoaDon.reloadData()
                    self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listSearchHoaDon.count + 60)
                }
            }
            self.present(currentViewController, animated: true, completion: nil)
        }
        
        func eventClickShowHoaDon(_ index: Int) {
            if let vc = UIStoryboard.init(name: "DetailBatDongSan", bundle: nil).instantiateViewController(withIdentifier: "HoaDonInforViewConroller") as? HoaDonInforViewConroller {
                vc.hoaDonObject = self.listSearchHoaDon[index]
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        
        func removeHoaDon(_ index: Int)  {
            let idPhieuThu = self.listPhieuThu.first(where: { $0.IdHoaDon == self.listSearchHoaDon[index].idHoaDon})?.IdPhieuThu ?? ""
            let parameters = ["IdHoaDon": self.listSearchHoaDon[index].idHoaDon ]
            SVProgressHUD.show()
            manager.request("https://localhost:5001/HoaDon/RemoveListHoaDon", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parameters).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                } else {
                    Notice.make(type: .Success, content: "Xoá hoá đơn thành công !").show()
                    Storage.shared.delete(HoaDon.self, ids: [self.listSearchHoaDon[index].idHoaDon], idPrefix: "idHoaDon")
                    if let index = self.listHoaDon.index(where: { $0.idHoaDon == self.listSearchHoaDon[index].idHoaDon  } )
                    {
                        self.listHoaDon.remove(at: index)
                    }
                    self.listSearchHoaDon.remove(at: index)
                    let parametersPhieuThu = ["IdPhieuThu" : idPhieuThu]
                    SVProgressHUD.show()
                    self.manager.request("https://localhost:5001/PhieuThu/RemoveListPhieuThu", method: .post, parameters: nil, encoding: URLEncoding.default, headers: parametersPhieuThu).responseJSON  { (responseObject) in
                        SVProgressHUD.dismiss()
                        if let error = responseObject.error {
                            Notice.make(type: .Error, content: error.localizedDescription).show()
                        } else {
                            Storage.shared.delete(PhieuThu.self, ids: [idPhieuThu], idPrefix: "IdPhieuThu")
                            //                        self.listPhieuThu.removeAll(where: { $0.IdPhieuThu == idPhieuThu})
                            self.tableViewHoaDon.reloadData()
                        }
                    }
                    self.constraintHeightViewBody.constant = CGFloat (100 + 70 + 70 + 70 * self.listHoaDon.count + 60)
                }
            } 
            
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return heightTableHoaDon
        }
        func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    }
    
    extension HoaDonViewController: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            return true
        }
        
    }
