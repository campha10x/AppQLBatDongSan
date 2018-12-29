//
//  OptionMenuViewController.swift
//  ConnectPOS
//
//  Created by HarryNg on 10/13/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit



protocol MainMenuDelegate {
    func mainMenuOpen(type: MainMenuType)
}

class MainMenuViewController: UIViewController {
    static let menuWidth : CGFloat = 320
    
    @IBOutlet weak var btnBackground: UIButton!
    @IBOutlet weak var tbOption: UITableView!
    @IBOutlet weak var constraintMenuLeading: NSLayoutConstraint!
    @IBOutlet weak var btnLogout: MySolidButton!
    
    var delegate : MainMenuDelegate?
    
    
    let arrayMenus: [String] = []
    var accountObject: Account? = nil
    var khachHangObject: KhachHang? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if AppState.shared.typeLogin == TypeLogin.ChuCanho.rawValue {
            let listAccounts = Storage.shared.getObjects(type: Account.self) as! [Account]
            accountObject = listAccounts.filter({$0.email == AppState.shared.getAccount()}).first?.copy() as? Account
        } else {
            let listKhachHang = Storage.shared.getObjects(type: KhachHang.self) as! [KhachHang]
            khachHangObject = listKhachHang.filter({$0.Email == AppState.shared.getAccount()}).first?.copy() as? KhachHang
        }

        btnLogout.backgroundColor = UIColor.init(netHex: 0xF46463)
        self.setUpXIB()
    }
    
    func setUpXIB() -> Void {
        // Table
        let nibOptionTableViewCell = UINib(nibName: "OptionTableViewCell", bundle: nil)
        self.tbOption.register(nibOptionTableViewCell, forCellReuseIdentifier: "OptionTableViewCell")
        self.tbOption.delegate = self
        self.tbOption.dataSource = self
        tbOption.allowsMultipleSelection = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func eventClickDismissOption(_ sender: Any) {
        hide()
    }
    
    @IBAction func eventClickLogout(_ sender: Any) {
//        guard Global.appDelegate.hasInternet else { return }
        delegate?.mainMenuOpen(type: .segueLogout)
    }
    
    func show(selectedAt: Int? = nil) {
        showMenu(true)
        if let index = selectedAt {
            tbOption.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .none)
        }
    }
    
    func hide() {
        showMenu(false)
    }
    
    private func showMenu(_ show: Bool) {
        constraintMenuLeading.constant = show ? -MainMenuViewController.menuWidth : 0
        self.view.layoutIfNeeded()
        self.view.isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.constraintMenuLeading.constant = show ? 0 : -MainMenuViewController.menuWidth
            self.btnBackground.alpha = show ? 0.3 : 0
            self.view.layoutIfNeeded()
        }, completion: {finish in
            self.btnBackground.isEnabled = true
            if !show {
                self.view.isHidden = true
            }
        })
    }
}

//MARK: TableviewDelegate and DataSource

extension MainMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if AppState.shared.typeLogin == TypeLogin.ChuCanho.rawValue {
            return 9
        } else {
            return 3
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell", for: indexPath) as! OptionTableViewCell
        if AppState.shared.typeLogin == TypeLogin.ChuCanho.rawValue {
            if indexPath.row == 0 {
                cell.setDataForOption(nameImage: "worldwide", titleOption: "Tổng quan")
            } else if indexPath.row == 1 {
                cell.setDataForOption(nameImage: "bills", titleOption: "Hoá đơn")
            }
            else if indexPath.row == 2 {
                cell.setDataForOption(nameImage: "money-bag", titleOption: "Phiếu Thu")
            }
            else if indexPath.row == 3 {
                cell.setDataForOption(nameImage: "money-bag", titleOption: "Phiếu chi")
            }
            else if indexPath.row == 4 {
                cell.setDataForOption(nameImage: "customer", titleOption: "Khách hàng")
            }
            else if indexPath.row == 5 {
                cell.setDataForOption(nameImage: "report", titleOption: "Hợp đồng")
            }else if indexPath.row == 6 {
                cell.setDataForOption(nameImage: "fireplace", titleOption: "Căn hộ")
            }else if indexPath.row == 7 {
                cell.setDataForOption(nameImage: "customer-support", titleOption: "Dịch vụ")
            }else if indexPath.row == 8 {
                cell.setDataForOption(nameImage: "graph", titleOption: "Thống kê")
            }
        } else {
            if indexPath.row == 0 {
                cell.setDataForOption(nameImage: "bills", titleOption: "Hoá đơn")
            }else if indexPath.row == 1 {
                cell.setDataForOption(nameImage: "report", titleOption: "Hợp đồng")
            }else if indexPath.row == 2 {
                cell.setDataForOption(nameImage: "fireplace", titleOption: "Căn hộ")
            }
        }
       
                
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if AppState.shared.typeLogin == TypeLogin.ChuCanho.rawValue {
            if indexPath.row == 0 {
                delegate?.mainMenuOpen(type: .segueTongQuan)
            } else if indexPath.row == 1 {
                delegate?.mainMenuOpen(type: .segueHoadon)
            }else if indexPath.row == 2 {
                delegate?.mainMenuOpen(type: .seguePhieuthu)
            } else if indexPath.row == 3 {
                delegate?.mainMenuOpen(type: .seguePhieuchi)
            } else if indexPath.row == 4 {
                delegate?.mainMenuOpen(type: .segueKhachhang)
            } else if indexPath.row == 5 {
                delegate?.mainMenuOpen(type: .segueHopdong)
            }
            else if indexPath.row == 6 {
                delegate?.mainMenuOpen(type: .seguePhong)
            }else if indexPath.row == 7 {
                delegate?.mainMenuOpen(type: .segueDichvu)
            }else if indexPath.row == 8 {
                delegate?.mainMenuOpen(type: .segueDoanhthu)
            }
        } else {
            if indexPath.row == 0 {
                delegate?.mainMenuOpen(type: .segueHoadon)
            }else if indexPath.row == 1 {
                delegate?.mainMenuOpen(type: .segueHopdong)
            }else if indexPath.row == 2 {
                delegate?.mainMenuOpen(type: .seguePhong)
            }
        }
        
        self.hide()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let height = self.tableView(tableView, heightForHeaderInSection: section)
        let header =  CashierHeaderView.instanceFromNib()
        header.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height - 30)
        if AppState.shared.typeLogin == TypeLogin.ChuCanho.rawValue {
            header.setDataCashier(nameImage: nil, nameCashier: accountObject?.hoten ?? "")
        } else {
            header.setDataCashier(nameImage: nil, nameCashier: khachHangObject?.TenKH ?? "")
        }

        let headerBound = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: height))
        headerBound.backgroundColor = .clear
        headerBound.addSubview(header)
        return headerBound
    }
    
    
}

