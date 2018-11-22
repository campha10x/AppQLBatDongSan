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

class TongQuanViewController: UIViewController {
    @IBOutlet weak var chartViewPhong: PieChartView!
    var listPhong: [Phong] = []
    var listHopDong: [HopDong] = []
    
    var statePhong = ["Phòng chưa thuê","Phòng đã thuê"]
    var slPhongDaThue: Int = 0
    var slPhongConLai: Int = 0
    
    var listPhongTrong: [Phong] = []
    
    @IBOutlet weak var tableViewStatePhong: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       config()
        tableViewStatePhong.dataSource = self
        tableViewStatePhong.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func config() {
        listPhong = Storage.shared.getObjects(type: Phong.self) as! [Phong]
        listHopDong = Storage.shared.getObjects(type: HopDong.self) as! [HopDong]
        
        for item in listPhong {
            if listHopDong.filter({ $0.idPhong == item.idPhong}).first != nil{
                slPhongDaThue = slPhongDaThue + 1
            } else {
                listPhongTrong.append(item)
            }
        }
        slPhongConLai = listPhong.count - slPhongDaThue
        self.setup(pieChartView: chartViewPhong)
        let l = chartViewPhong.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        self.setDataCount(2, range: 100)
        chartViewPhong.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        chartViewPhong.entryLabelColor = .black
        chartViewPhong.entryLabelFont = .systemFont(ofSize: 11, weight: .light)
    }
    
    func setDataCount(_ count: Int, range: Int) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            var value: Double = 0
            if slPhongConLai != 0 || slPhongDaThue != 0 {
                value = Double(i == 0 ? slPhongConLai : slPhongDaThue) / Double(slPhongConLai + slPhongDaThue)
            }
            return PieChartDataEntry(value: value * 100,
                                     label: statePhong[i],
                                     icon: nil)
        }
        
        let set = PieChartDataSet(values: entries, label: "")
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
        
        data.setValueFont(.systemFont(ofSize: 14, weight: .light))
        data.setValueTextColor(.black)
        
        chartViewPhong.data = data
        chartViewPhong.highlightValues(nil)
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
        return listPhongTrong.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListPhongTrongTableViewCell.id, for: indexPath) as! ListPhongTrongTableViewCell
        cell.binding(tenPhong: listPhongTrong[indexPath.row].tenPhong)
        return cell
    }
    
    
}
