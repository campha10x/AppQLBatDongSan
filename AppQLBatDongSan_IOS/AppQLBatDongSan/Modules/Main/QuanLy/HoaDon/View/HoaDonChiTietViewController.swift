
//
//  HoaDonChiTietViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 10/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

enum action: String {
    case createNew = "createNew"
    case edit = "edit"
}
class HoaDonChiTietViewController: UIViewController {
    @IBOutlet weak var cbbPhong: MyCombobox!
    @IBOutlet weak var DateCalendarBtn: MyButtonCalendar!
    @IBOutlet weak var txtGhiChu: UITextField!
    
    @IBOutlet weak var tableViewHoaDonChiTiet: UITableView!
    let isCreateNew: action = .createNew
    
    var phong: Phong?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewHoaDonChiTiet.delegate = self
        tableViewHoaDonChiTiet.dataSource = self
    }

}
extension HoaDonChiTietViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
