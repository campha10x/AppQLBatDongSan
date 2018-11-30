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
    @IBOutlet weak var chartViewCanHo: PieChartView!
    var listCanHo: [CanHo] = []
    var listHopDong: [HopDong] = []
    
    var stateCanHo = ["Phòng chưa thuê","Phòng đã thuê"]
    var slCanHoDaThue: Int = 0
    var slCanHoConLai: Int = 0
    
    var listCanHoTrong: [CanHo] = []
    
    @IBOutlet weak var tableViewStateCanHo: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       config()
        tableViewStateCanHo.dataSource = self
        tableViewStateCanHo.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    func config() {
        listCanHo = Storage.shared.getObjects(type: CanHo.self) as! [CanHo]
        listHopDong = Storage.shared.getObjects(type: HopDong.self) as! [HopDong]
        
        for item in listCanHo {
            if listHopDong.filter({ $0.IdCanHo == item.IdCanHo}).first != nil{
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
    }
    
    func setDataCount(_ count: Int, range: Int) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            var value: Double = 0
            if slCanHoConLai != 0 || slCanHoDaThue != 0 {
                value = Double(i == 0 ? slCanHoConLai : slCanHoDaThue) / Double(slCanHoConLai + slCanHoDaThue)
            }
            return PieChartDataEntry(value: value * 100,
                                     label: stateCanHo[i],
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
        return listCanHoTrong.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCanHoTrongTableViewCell.id, for: indexPath) as! ListCanHoTrongTableViewCell
        cell.binding(tenPhong: listCanHoTrong[indexPath.row].TenCanHo)
        return cell
    }
    
    
}
