//
//  HoaDonInforViewConroller.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 12/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

struct DichVuDocument {
    var nameDichVu: String = ""
    var soCu: String = ""
    var soMoi: String = ""
    var donGia: String = ""
    var thanhTien: String = ""
    
    
}

class HoaDonInforViewConroller: UIViewController {

    @IBOutlet weak var tblHoaDon: UITableView!
    @IBOutlet weak var lbMaHopDong: UILabel!
    @IBOutlet weak var lbNgayTaoHD: UILabel!
    @IBOutlet weak var lbMaHoaDon: UILabel!
    
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var lbTongTien: UILabel!
    
    @IBOutlet weak var constraintHeightViewHoaDon: NSLayoutConstraint!
    var listDichVuDocument: [DichVuDocument] = []
    var hoaDonObject: HoaDon? = nil
    var hopDongObject: HopDong? = nil
    var canHoObject: CanHo? = nil
    
    var hopdong_DichVu: [HopDong_DichVu] = []
    var listDichVu: [DichVu] = []
    var tongTien: Double = 0
    var listCTHDSelected: [ChiTietHoaDon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblHoaDon.dataSource = self
        tblHoaDon.delegate = self
        guard let hoaDonObject = hoaDonObject else {
            return
        }
        hopdong_DichVu = Storage.shared.getObjects(type: HopDong_DichVu.self) as! [HopDong_DichVu]
        listDichVu = Storage.shared.getObjects(type: DichVu.self) as! [DichVu]
        // CanHo
        let listCanHo: [CanHo] = Storage.shared.getObjects(type: CanHo.self) as? [CanHo] ?? []
        canHoObject = listCanHo.filter({ $0.IdCanHo == hoaDonObject.IdCanHo }).first?.copy() as? CanHo
        let listHopDong: [HopDong] = Storage.shared.getObjects(type: HopDong.self) as? [HopDong] ?? []
        hopDongObject = listHopDong.filter({ $0.IdCanHo == canHoObject?.IdCanHo }).first?.copy() as? HopDong
        lbMaHoaDon.text = "Số hoá đơn #" + hoaDonObject.soPhieu
        lbNgayTaoHD.text = self.hoaDonObject?.ngayTao.formatDate()
        lbMaHopDong.text = self.hopDongObject?.maHopDong
        
        var listCTHD = Storage.shared.getObjects(type: ChiTietHoaDon.self) as! [ChiTietHoaDon]
        listCTHDSelected = listCTHD.filter({ $0.Id_HoaDon == self.hoaDonObject?.idHoaDon})
        tongTien = listCTHDSelected.reduce(0.0, { $0 + $1.thanhTien})
        lbTongTien.text = "\(tongTien)".toNumberString(decimal: false)
        let frame = self.tblHoaDon.frame
        self.tblHoaDon.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 70)
        tblHoaDon.tableFooterView = viewFooter
        viewFooter.layoutIfNeeded()
        constraintHeightViewHoaDon.constant = CGFloat(70 + 70 + listCTHDSelected.count * 50 + 10)
     }
    
    
    @IBAction func eventClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension HoaDonInforViewConroller:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCTHDSelected.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HoaDonInforTableViewCell.id, for: indexPath) as? HoaDonInforTableViewCell
        cell?.binding(CTHD: self.listCTHDSelected[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
