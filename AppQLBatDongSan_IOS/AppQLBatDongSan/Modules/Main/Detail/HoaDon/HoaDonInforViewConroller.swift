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
    
    var listDichVuDocument: [DichVuDocument] = []
    var hoaDonObject: HoaDon? = nil
    var hopDongObject: HopDong? = nil
    var canHoObject: CanHo? = nil
    
    var hopdong_DichVu: [HopDong_DichVu] = []
    var listDichVu: [DichVu] = []
    var tongTien: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblHoaDon.dataSource = self
        tblHoaDon.delegate = self
        config()
        guard let hoaDonObject = hoaDonObject else {
            return
        }
        lbMaHoaDon.text = "Số hoá đơn #" + hoaDonObject.soPhieu
        lbNgayTaoHD.text = self.hoaDonObject?.ngayTao.formatDate()
        lbMaHopDong.text = self.hopDongObject?.maHopDong
        
        lbTongTien.text = "\(tongTien)".toNumberString(decimal: false)
        let frame = self.tblHoaDon.frame
        self.tblHoaDon.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 70)
        tblHoaDon.tableFooterView = viewFooter
        viewFooter.layoutIfNeeded()
     }
    
    func config() {
        hopdong_DichVu = Storage.shared.getObjects(type: HopDong_DichVu.self) as! [HopDong_DichVu]
        listDichVu = Storage.shared.getObjects(type: DichVu.self) as! [DichVu]
        // CanHo
        let listCanHo: [CanHo] = Storage.shared.getObjects(type: CanHo.self) as? [CanHo] ?? []
        canHoObject = listCanHo.filter({ $0.IdCanHo == hoaDonObject?.IdCanHo }).first?.copy() as? CanHo
        let listHopDong: [HopDong] = Storage.shared.getObjects(type: HopDong.self) as? [HopDong] ?? []
        hopDongObject = listHopDong.filter({ $0.IdCanHo == canHoObject?.IdCanHo }).first?.copy() as? HopDong
        let listHoaDon: [HoaDon] = Storage.shared.getObjects(type: HoaDon.self) as? [HoaDon] ?? []
        
        
        var canHoDocumentObject = DichVuDocument()
        canHoDocumentObject.nameDichVu = "Căn hộ " + (canHoObject?.maCanHo ?? "")
        canHoDocumentObject.donGia = canHoObject?.DonGia ?? ""
        canHoDocumentObject.thanhTien = canHoObject?.DonGia ?? ""
        listDichVuDocument.append(canHoDocumentObject)
        
        // tien dien, nuoc
        var tienDien: Double =  0
        var soDienCu: Double =  0
        var tienNuoc: Double =  0
        var soNuocCu: Double =  0
        var tongTienDienTieuThu: Double = 0
        var tongTienNuocTieuThu: Double = 0
        
        let arrayHoadonLonNhat = listHoaDon.filter({ $0.IdCanHo == hoaDonObject?.IdCanHo}).sorted { (hoadon1, hoadon2) -> Bool in
            let date1 = hoadon1.ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            let date2 = hoadon2.ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            return date1 < date2
        }
        var  hoadonLonNhat: HoaDon? = nil
        if  arrayHoadonLonNhat.count > 1 {
            hoadonLonNhat = arrayHoadonLonNhat[1]
        } else {
            hoadonLonNhat = arrayHoadonLonNhat.first
        }
        guard let hopDongObject = self.hopDongObject , let hoaDonObject = self.hoaDonObject else { return  }
        let components = Calendar.current.dateComponents([.year, .month, .day], from: hoaDonObject.ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date())
        if let hoadonLonNhat = hoadonLonNhat, let ngay1 = hoadonLonNhat.ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss"), ngay1.month == (components.month ?? 1) - 1 , ngay1.year == components.year {
            tienDien = Double(hopDongObject.TienDien) ?? 0
            soDienCu = Double(hoadonLonNhat.soDienMoi) ?? 0
            tienNuoc = Double(hopDongObject.TienNuoc) ?? 0
            soNuocCu = Double(hoadonLonNhat.soNuocMoi) ?? 0
        } else {
            tienDien = Double(hopDongObject.TienDien) ?? 0
            soDienCu = Double(hopDongObject.SoDienBd) ?? 0
            tienNuoc = Double(hopDongObject.TienNuoc) ?? 0
            soNuocCu = Double(hopDongObject.SoNuocBd) ?? 0
        }
        tongTienDienTieuThu = (tienDien * ( (Double(hoaDonObject.soDienMoi) ?? 0) - soDienCu ))
        tongTienNuocTieuThu = (tienNuoc * ( (Double(hoaDonObject.soNuocMoi) ?? 0) - soNuocCu ))
        
        var giaDienDocumentObject = DichVuDocument()
        giaDienDocumentObject.nameDichVu = "Điện"
        giaDienDocumentObject.donGia = hopDongObject.TienDien
        giaDienDocumentObject.soCu = "\(Int(soDienCu))"
        giaDienDocumentObject.soMoi = hoaDonObject.soDienMoi
        giaDienDocumentObject.thanhTien = "\(tongTienDienTieuThu)"
        
        var giaNuocDocumentObject = DichVuDocument()
        giaNuocDocumentObject.nameDichVu = "Nước"
        giaNuocDocumentObject.donGia = hopDongObject.TienNuoc
        giaNuocDocumentObject.soCu = "\(Int(soNuocCu))"
        giaNuocDocumentObject.soMoi = hoaDonObject.soNuocMoi
        giaNuocDocumentObject.thanhTien = "\(tongTienNuocTieuThu)"
        
        let selectedHopDong_DichVu = self.hopdong_DichVu.filter({ $0.IdHopDong == hopDongObject.IdHopDong } )
        for item in selectedHopDong_DichVu {
            if  let dichvuSelected = self.listDichVu.filter({ $0.idDichVu == item.IdDichVu }).first {
                var dichvuDocumentObject = DichVuDocument()
                dichvuDocumentObject.nameDichVu = dichvuSelected.TenDichVu
                dichvuDocumentObject.donGia = item.DonGia
                dichvuDocumentObject.thanhTien = item.DonGia
                listDichVuDocument.append(dichvuDocumentObject)
                tongTien += Double(item.DonGia) ?? 0
            }
            

        }
        
        
        tongTien += tongTienNuocTieuThu + tongTienDienTieuThu + (Double(canHoDocumentObject.thanhTien) ?? 0 )
        listDichVuDocument.append(giaDienDocumentObject)
        listDichVuDocument.append(giaNuocDocumentObject)
        tblHoaDon.reloadData()
    }
    
    
    @IBAction func eventClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension HoaDonInforViewConroller:  UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listDichVuDocument.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HoaDonInforTableViewCell.id, for: indexPath) as? HoaDonInforTableViewCell
        cell?.binding(dichvu: self.listDichVuDocument[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
