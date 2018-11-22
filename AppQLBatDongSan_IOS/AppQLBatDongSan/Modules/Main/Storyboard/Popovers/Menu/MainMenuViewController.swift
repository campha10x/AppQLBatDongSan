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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionTableViewCell", for: indexPath) as! OptionTableViewCell
        if indexPath.row == 0 {
            cell.setDataForOption(nameImage: "icon-sell.png", titleOption: "Tổng quan")
        } else if indexPath.row == 1 {
            cell.setDataForOption(nameImage: "icon-sell.png", titleOption: "Hoá đơn")
        }
        else if indexPath.row == 2 {
            cell.setDataForOption(nameImage: "icon-shift.png", titleOption: "Phiếu Thu")
        }
        else if indexPath.row == 3 {
            cell.setDataForOption(nameImage: "icon-shift.png", titleOption: "Phiếu chi")
        }
        else if indexPath.row == 4 {
            cell.setDataForOption(nameImage: "icon-order-list.png", titleOption: "Khách hàng")
        }
        else if indexPath.row == 5 {
            cell.setDataForOption(nameImage: "icon-setting.png", titleOption: "Hợp đồng")
        }
//        else if indexPath.row == 6 {
//            cell.setDataForOption(nameImage: "icon-setting.png", titleOption: "Thống kê")
//        }
        else if indexPath.row == 6 {
            cell.setDataForOption(nameImage: "icon-setting.png", titleOption: "Nhà trọ")
        }else if indexPath.row == 7 {
            cell.setDataForOption(nameImage: "icon-setting.png", titleOption: "Phòng")
        }else if indexPath.row == 8 {
            cell.setDataForOption(nameImage: "icon-setting.png", titleOption: "Đơn vị")
        }else if indexPath.row == 9 {
            cell.setDataForOption(nameImage: "icon-setting.png", titleOption: "Dịch vụ")
        }
                
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            delegate?.mainMenuOpen(type: .segueTongQuan)
            self.hide()
        } else if indexPath.row == 1 {
            delegate?.mainMenuOpen(type: .segueHoadon)
            self.hide()
        }else if indexPath.row == 2 {
            delegate?.mainMenuOpen(type: .seguePhieuthu)
            self.hide()
        } else if indexPath.row == 3 {
            delegate?.mainMenuOpen(type: .seguePhieuchi)
            self.hide()
        } else if indexPath.row == 4 {
            delegate?.mainMenuOpen(type: .segueKhachhang)
            self.hide()
        } else if indexPath.row == 5 {
            delegate?.mainMenuOpen(type: .segueHopdong)
            self.hide()
        }
//        else if indexPath.row == 6 {
//            delegate?.mainMenuOpen(type: .segueDoanhthu)
//            self.hide()
//        }
        else if indexPath.row == 6 {
            delegate?.mainMenuOpen(type: .segueNhatro)
            self.hide()
        }
        else if indexPath.row == 7 {
            delegate?.mainMenuOpen(type: .seguePhong)
            self.hide()
        }else if indexPath.row == 8 {
            delegate?.mainMenuOpen(type: .segueDonvi)
            self.hide()
        }else if indexPath.row == 9 {
            delegate?.mainMenuOpen(type: .segueDichvu)
            self.hide()
        }
        
    }
    
}

