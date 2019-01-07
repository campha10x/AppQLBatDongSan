//
//  DoanhThuViewController.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 11/27/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire
import Charts

class DoanhThu {
    var thoigian: String = ""
    var sotien: String = ""
}

extension BarChartView {
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        let chartData = BarChartData(dataSet: chartDataSet)
        chartData.setValueFont(UIFont.systemFont(ofSize: 15))
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        
        self.data = chartData
    }
}

class ListDoanhThuViewController: UIViewController {
    @IBOutlet weak var btnCalendarFrom: MyButtonCalendar!
    @IBOutlet weak var btnCalenderTo: MyButtonCalendar!
    @IBOutlet weak var tblViewThongKe: UITableView!
    
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var chartViewThongKe: BarChartView!
    var listDoanhThu: [DoanhThu] = []
    
    var listPhieuThu: [PhieuThu] = [PhieuThu]()
    var listPhieuChi: [PhieuChi] = [PhieuChi]()
     let manager = Alamofire.SessionManager()
    var dispatch : DispatchGroup?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch = DispatchGroup()
        configService()
        loadPhieuChi()
        loadPhieuThu()
        dispatch?.notify(queue: .main, execute: {
            self.caculatorDoanhThu()
            self.setChart()
            self.viewFooter.frame = CGRect.init(x: 0, y: 13 * 50, width: self.tblViewThongKe.frame.width, height: 700)
            self.tblViewThongKe.tableFooterView = self.viewFooter
        })

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        btnCalendarFrom.date  = formatter.date(from: "\(Date().year)/01/01") ?? Date()
        btnCalenderTo.date = Date()
       
        btnCalendarFrom.layer.borderColor = UIColor.gray.cgColor
        btnCalendarFrom.layer.borderWidth = 1.0
        
        btnCalenderTo.layer.borderColor = UIColor.gray.cgColor
        btnCalenderTo.layer.borderWidth = 1.0
        tblViewThongKe.dataSource = self
        tblViewThongKe.delegate = self
        

    }
    
    
    func setChart(){
        chartViewThongKe.rightAxis.enabled = false
        chartViewThongKe.legend.font = .systemFont(ofSize: 15)
        chartViewThongKe.xAxis.labelFont = .systemFont(ofSize: 15)
         chartViewThongKe.leftAxis.labelFont = .systemFont(ofSize: 15)
        var convertNumberMonth: [String] = []
        var unitsSold: [Double] = []
        for item in listDoanhThu {
            convertNumberMonth.append(item.thoigian)
            unitsSold.append((Double(item.sotien) ?? 0))
        }
        chartViewThongKe.setBarChartData(xValues: convertNumberMonth, yValues: unitsSold , label: "Doanh thu")
        chartViewThongKe.isUserInteractionEnabled = false
    }
    
    func caculatorDoanhThu() {
        guard let value = Calendar.current.dateComponents([.month], from: btnCalendarFrom.date, to: btnCalenderTo.date).month else { return }
        var dateCalendar = btnCalendarFrom.date
        for _ in 0...value {
            let month = Calendar.current.component(.month, from: dateCalendar)
            let year = Calendar.current.component(.year, from: dateCalendar)
            
            let getListPhieuThu = listPhieuThu.filter({ return (returnMonth(ngayTao: $0.Ngay) == month && year == returnYear(ngayTao: $0.Ngay)) })
            let totalPhieuThu = getListPhieuThu.reduce(0.0, { $0 + (Double($1.SoTien) ?? 0.0) })
            let getListPhieuChi = listPhieuChi.filter({ return (returnMonth(ngayTao: $0.Ngay) == month && year == returnYear(ngayTao: $0.Ngay)) })
            let totalPhieuChi = getListPhieuChi.reduce(0.0, { $0 + (Double($1.Sotien) ?? 0.0) })

            let doanhThu = DoanhThu()
            doanhThu.sotien = "\(totalPhieuThu - totalPhieuChi)"
            doanhThu.thoigian = "\(month) / \(year)"
            self.listDoanhThu.append(doanhThu)
            dateCalendar = Calendar.current.date(byAdding: .month, value: 1 , to: dateCalendar) ?? Date()

        }
        tblViewThongKe.reloadData()
    }
    
    func returnMonth(ngayTao: String) -> Int {
        if let ngayTaoConvert = ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") {
            return Calendar.current.component(.month, from: ngayTaoConvert)
        } else {
            return 0
        }

    }
    
    func returnYear(ngayTao: String) -> Int {
        if let ngayTaoConvert = ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") {
            return Calendar.current.component(.year, from: ngayTaoConvert)
        } else {
            return 0
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
    
    
    func loadPhieuThu() {
        dispatch?.enter()
        SVProgressHUD.show()
        manager.request("https://localhost:5001/PhieuThu/GetListPhieuThu", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            self.dispatch?.leave()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listPhieuThu  = json.arrayValue.map({PhieuThu.init(json: $0)})
                self.listPhieuThu.forEach({ (phieuthu) in
                    if let phieuthuCopy = phieuthu.copy() as? PhieuThu {
                        Storage.shared.addOrUpdate([phieuthuCopy], type: PhieuThu.self)
                    }
                })
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
        
    }
    
    
    func loadPhieuChi() {
        dispatch?.enter()
        SVProgressHUD.show()
        manager.request("https://localhost:5001/PhieuChi/GetListPhieuChi", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            self.dispatch?.leave()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listPhieuChi  = json.arrayValue.map({PhieuChi.init(json: $0)})
                self.listPhieuChi.forEach({ (phieuchi) in
                    if let phieuchiCopy = phieuchi.copy() as? PhieuChi {
                        Storage.shared.addOrUpdate([phieuchiCopy], type: PhieuChi.self)
                    }
                })
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
        
    }
    
    
    @IBAction func eventChooseDate(_ sender: Any) {
        guard let btn = sender as? MyButtonCalendar else { return  }
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.date = btn.date
        if btn == btnCalendarFrom {
            picker.addTarget(self, action: #selector(pickerChangedDateFrom), for: .valueChanged)
        } else {
            picker.addTarget(self, action: #selector(pickerChangedDateTo), for: .valueChanged)
        }

        let controller = UIViewController()
        controller.view = picker
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: Global.screenSize.width/3, height: Global.screenSize.height/3)
        controller.popoverPresentationController?.sourceView = btn
        controller.popoverPresentationController?.sourceRect = btn.bounds
        controller.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func pickerChangedDateFrom(picker: UIDatePicker) {
        btnCalendarFrom.date = picker.date
    }
    
    @objc func pickerChangedDateTo(picker: UIDatePicker) {
        btnCalenderTo.date = picker.date
    }
        

    @IBAction func eventClickThongKe(_ sender: Any) {
        self.listDoanhThu.removeAll()
        caculatorDoanhThu()
        self.setChart()
    }
    

}

extension ListDoanhThuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listDoanhThu.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoanhThuTableViewCell", for: indexPath) as! DoanhThuTableViewCell
        if indexPath.row == listDoanhThu.count {
            let sum = self.listDoanhThu.reduce(0.0, { $0 + (Double($1.sotien) ?? 0) })
            cell.binding(date: "Tổng cộng", money: "\(sum)",rowLast: true)
        }else {
            cell.binding(date: self.listDoanhThu[indexPath.row].thoigian, money: self.listDoanhThu[indexPath.row].sotien)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
