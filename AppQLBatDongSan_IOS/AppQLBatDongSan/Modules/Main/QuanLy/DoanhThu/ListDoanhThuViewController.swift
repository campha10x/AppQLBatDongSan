//
//  DoanhThuViewController.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 11/27/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class DoanhThu {
    var thoigian: String = ""
    var sotien: String = ""
}

class ListDoanhThuViewController: UIViewController {
    @IBOutlet weak var btnCalendarFrom: MyButtonCalendar!
    @IBOutlet weak var btnCalenderTo: MyButtonCalendar!
    @IBOutlet weak var tblViewThongKe: UITableView!
    
    var listDoanhThu: [DoanhThu] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        btnCalendarFrom.date  = formatter.date(from: "2017/01/01") ?? Date()
        btnCalenderTo.date = Date()
       
    }
    
    @IBAction func eventChooseDate(_ sender: Any) {
        guard let btn = sender as? MyButtonCalendar else { return  }
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = btn.date
        picker.addTarget(self, action: #selector(pickerChangedDate), for: .valueChanged)
        let controller = UIViewController()
        controller.view = picker
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: Global.screenSize.width/3, height: Global.screenSize.height/3)
        controller.popoverPresentationController?.sourceView = btn
        controller.popoverPresentationController?.sourceRect = btn.bounds
        controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func pickerChangedDate(picker: UIDatePicker) {
        if picker == btnCalendarFrom {
            btnCalendarFrom.date = picker.date
        } else {
            btnCalenderTo.date = picker.date
        }
    }
    
        

    @IBAction func eventClickThongKe(_ sender: Any) {
        
        
    }
    

}

