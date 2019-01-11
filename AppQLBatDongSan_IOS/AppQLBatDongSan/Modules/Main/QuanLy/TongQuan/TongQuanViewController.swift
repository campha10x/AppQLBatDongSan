//
//  TongQuanViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 11/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit
import Charts
import Alamofire
import SwiftyJSON
import SVProgressHUD

class CanHoNoTien {
    var maCanHo: String = ""
    var soTienNo: String = ""
    
    init(maCanHo: String, soTienNo: String) {
        self.maCanHo = maCanHo
        self.soTienNo = soTienNo
    }
    
}

class TongQuanViewController: UIViewController {
    @IBOutlet weak var chartViewCanHo: PieChartView!
    @IBOutlet weak var barChartViewThongKe: BarChartView!
    @IBOutlet weak var tableViewStateCanHo: UITableView!
    @IBOutlet weak var tableViewCanHoNoTien: UITableView!
    
    var listCanHo: [CanHo] = []
    var listHopDong: [HopDong] = []
    
    var slCanHoDaThue: Int = 0
    var slCanHoConLai: Int = 0
    
    var listCanHoTrong: [CanHo] = []
    
    let manager = SessionManager()
    
    let stateCanHo: [String] = ["Căn hộ đã thuê", "Căn hộ chưa thuê"]
    var dispatch: DispatchGroup?
    var listHoaDon: [HoaDon] = []
    var listPhieuThu: [PhieuThu] = []
    
    var listCanHoNoTien: [CanHoNoTien] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Storage.shared.delete(DichVu.self)
        dispatch = DispatchGroup()
        configService()
        loadCanHo()
        loadHopDong_DichVu()
        loadHopDong()
        loadChiTietHoaDon()
        loadHoaDon()
        loadListPhieuThu()
        loadPhieuChi()
        loadKhachHang()
        loadDichvu()
        loadCanHo_DichVu()
        loadListAccounts()
        dispatch?.notify(queue: .main, execute: {
            self.config()
        })
        tableViewCanHoNoTien.dataSource = self
        tableViewCanHoNoTien.separatorStyle = .none
        tableViewStateCanHo.dataSource = self
        tableViewStateCanHo.separatorStyle = .none
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    
    func loadPhieuChi()  {
        SVProgressHUD.show()
        dispatch?.enter()
        manager.request("https://localhost:5001/PhieuChi/GetListPhieuChi", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            self.dispatch?.leave()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                let listPhieuChi: [PhieuChi]  = json.arrayValue.map({PhieuChi.init(json: $0)})
                listPhieuChi.forEach({ (phieuchi) in
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
    
    func loadKhachHang() {
        SVProgressHUD.show()
        dispatch?.enter()
        manager.request("https://localhost:5001/KhachHang/GetListKhachHang", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            self.dispatch?.leave()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                let listKhachHang: [KhachHang]  = json.arrayValue.map({KhachHang.init(json: $0)})
                listKhachHang.forEach({ (khachhang) in
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
    
    func loadHoaDon() {
        dispatch?.enter()
        SVProgressHUD.show()
        manager.request("https://localhost:5001/HoaDon/GetListHoaDon", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            SVProgressHUD.dismiss()
            self.dispatch?.leave()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listHoaDon  = json.arrayValue.map({HoaDon.init(json: $0)})
                Storage.shared.addOrUpdate(self.listHoaDon, type: HoaDon.self)
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
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
    
    func setUpChart_ThongKe() {
        
        barChartViewThongKe.chartDescription?.enabled =  false
        
        barChartViewThongKe.pinchZoomEnabled = false
        barChartViewThongKe.drawBarShadowEnabled = false
        
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1), font: .systemFont(ofSize: 12), textColor: .white, insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = barChartViewThongKe
        marker.minimumSize = CGSize(width: 80, height: 40)
        barChartViewThongKe.marker = marker
        
        let l = barChartViewThongKe.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = true
        l.font = .systemFont(ofSize: 8, weight: .light)
        l.yOffset = 10
        l.xOffset = 10
        l.yEntrySpace = 0
        //        chartView.legend = l
        
        let xAxis = barChartViewThongKe.xAxis
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.granularity = 1
        xAxis.centerAxisLabelsEnabled = true
        xAxis.valueFormatter = IntAxisValueFormatter()
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let leftAxis = barChartViewThongKe.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        leftAxis.valueFormatter = LargeValueFormatter()
        leftAxis.spaceTop = 0.35
        leftAxis.axisMinimum = 0
        
        barChartViewThongKe.rightAxis.enabled = false

    }
    
    
    func setDataCountThongKe(_ count: Int, range: UInt32) {
        let groupSpace = 0.08
        let barSpace = 0.03
        let barWidth = 0.2
        // (0.2 + 0.03) * 4 + 0.08 = 1.00 -> interval per "group"
        
        let randomMultiplier = range * 100000
        let groupCount = count + 1
        let startYear = 1980
        let endYear = startYear + groupCount
        
        let block: (Int) -> BarChartDataEntry = { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(i), y: Double(arc4random_uniform(randomMultiplier)))
        }
        let yVals1 = (startYear ..< endYear).map(block)
        let yVals2 = (startYear ..< endYear).map(block)
        
        let set1 = BarChartDataSet(values: yVals1, label: "Tiền thu")
        set1.setColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))
        
        let set2 = BarChartDataSet(values: yVals2, label: "Tiền chi")
        set2.setColor(UIColor(red: 164/255, green: 228/255, blue: 251/255, alpha: 1))
        
        let data = BarChartData(dataSets: [set1, set2])
        data.setValueFont(.systemFont(ofSize: 13, weight: .light))
        data.setValueFormatter(LargeValueFormatter())
        
        // specify the width each bar should have
        data.barWidth = barWidth
        
        // restrict the x-axis range
        barChartViewThongKe.xAxis.axisMinimum = Double(startYear)
        
        // groupWidthWithGroupSpace(...) is a helper that calculates the width each group needs based on the provided parameters
        barChartViewThongKe.xAxis.axisMaximum = Double(startYear) + data.groupWidth(groupSpace: groupSpace, barSpace: barSpace) * Double(groupCount)
        
        data.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
        
        barChartViewThongKe.data = data
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
        dispatch?.enter()
        manager.request("https://localhost:5001/CanHo/GetListCanHo", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            self.dispatch?.leave()
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listCanHo  = json.arrayValue.map({CanHo.init(json: $0)})
                self.listCanHo.forEach({ (canHo) in
                    if let canHoCopy = canHo.copy() as? CanHo {
                        Storage.shared.addOrUpdate([canHoCopy], type: CanHo.self)
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
    
    func loadHopDong()  {
        SVProgressHUD.show()
        dispatch?.enter()
        manager.request("https://localhost:5001/HopDong/GetListHopDong", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            self.dispatch?.leave()
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                self.listHopDong  = json.arrayValue.map({HopDong.init(json: $0)})
                self.listHopDong.forEach({ (hopdong) in
                    if let hopdongCopy = hopdong.copy() as? HopDong {
                        Storage.shared.addOrUpdate([hopdongCopy], type: HopDong.self)
                    }
                })
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
    }
    
    func loadChiTietHoaDon()  {
        SVProgressHUD.show()
        dispatch?.enter()
        manager.request("https://localhost:5001/ChiTietHoaDon/GetListChiTietHoaDon", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            self.dispatch?.leave()
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                var listCTHD  = json.arrayValue.map({ChiTietHoaDon.init(json: $0)})
                listCTHD.forEach({ (hopdong) in
                    if let hopdongCopy = hopdong.copy() as? ChiTietHoaDon {
                        Storage.shared.addOrUpdate([hopdongCopy], type: ChiTietHoaDon.self)
                    }
                })
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
    }
    
    func loadListAccounts()  {
        SVProgressHUD.show()
        dispatch?.enter()
        manager.request("https://localhost:5001/Account/GetListAccounts", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseObject) in
            self.dispatch?.leave()
            SVProgressHUD.dismiss()
            do {
                let json: JSON = try JSON.init(data: responseObject.data! )
                var listCTHD  = json.arrayValue.map({Account.init(json: $0)})
                listCTHD.forEach({ (hopdong) in
                    if let hopdongCopy = hopdong.copy() as? ChiTietHoaDon {
                        Storage.shared.addOrUpdate([hopdongCopy], type: Account.self)
                    }
                })
            } catch {
                if let error = responseObject.error {
                    Notice.make(type: .Error, content: error.localizedDescription).show()
                }
            }
        }
    }
    
    func config() {
        for item in listCanHo {
            if listHopDong.filter({ $0.IdCanHo == item.IdCanHo && $0.active }).first != nil{
                slCanHoDaThue = slCanHoDaThue + 1
            } else {
                listCanHoTrong.append(item)
            }
        }
        slCanHoConLai = listCanHo.count - slCanHoDaThue
        self.setup(pieChartView: chartViewCanHo)
        let l = chartViewCanHo.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        self.setDataCount(2, range: 100)
        chartViewCanHo.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        chartViewCanHo.entryLabelColor = .black
        chartViewCanHo.entryLabelFont = .systemFont(ofSize: 11, weight: .light)
        for item in self.listHoaDon {
            var datra: Double = 0
            let list = listPhieuThu.filter({ $0.IdHoaDon == item.idHoaDon })
            if list.count > 0 {
                datra = list.reduce(0.0, { $0 + (Double($1.SoTien) ?? 0) })
            }
            let soTienConLai = (Double(item.soTien) ?? 0 ) - datra
            if soTienConLai > 0 {
                if let maCanHo = self.listCanHo.filter({$0.IdCanHo == item.IdCanHo}).first?.maCanHo {
                    listCanHoNoTien.append(CanHoNoTien.init(maCanHo: maCanHo, soTienNo: "\(soTienConLai)"))
                }
            }
        }
        tableViewStateCanHo.reloadData()
        //load canho no tien
        tableViewCanHoNoTien.reloadData()

    }
    
    func setDataCount(_ count: Int, range: Int) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            var value: Double = 0
            if slCanHoConLai != 0 || slCanHoDaThue != 0 {
                value = Double(i == 0 ? slCanHoDaThue  : slCanHoConLai) / Double(slCanHoConLai + slCanHoDaThue)
            }
            return PieChartDataEntry(value: value * 100,
                                     label: stateCanHo[i],
                                     icon: nil)
        }
        
        let set = PieChartDataSet(values: entries, label: "")
        set.entryLabelFont = UIFont.systemFont(ofSize: 15)
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 15, weight: .light))
        data.setValueTextColor(.black)
        
        chartViewCanHo.data = data
        chartViewCanHo.highlightValues(nil)
    }
    
    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
    }
}

extension TongQuanViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView ==  self.tableViewStateCanHo {
            return listCanHoTrong.count
        } else {
            return listCanHoNoTien.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView ==  self.tableViewStateCanHo {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListCanHoTrongTableViewCell.id, for: indexPath) as! ListCanHoTrongTableViewCell
            cell.binding(maCanHo: listCanHoTrong[indexPath.row].maCanHo)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ListCanHoNoTienTableViewCell.id, for: indexPath) as! ListCanHoNoTienTableViewCell
            cell.binding(soTien: self.listCanHoNoTien[indexPath.row].soTienNo, tenCanho: self.listCanHoNoTien[indexPath.row].maCanHo)
            return cell
        }
    }
    
    
}

