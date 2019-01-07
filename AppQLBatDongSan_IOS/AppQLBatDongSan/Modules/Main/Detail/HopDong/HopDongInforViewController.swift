//
//  HopDongInforViewController.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 12/11/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class HopDongInforViewController: UIViewController {

        @IBOutlet weak var lbNgayTaoHopDong: UILabel!
    // Chu Hop Dong
    @IBOutlet weak var lbHotenChuCanHo: UILabel!
    @IBOutlet weak var lbCMNDChuHopDong: UILabel!
    @IBOutlet weak var lbNgayCapChuHopDong: UILabel!
    @IBOutlet weak var lbNoiCapChuHopDong: UILabel!
    @IBOutlet weak var lbDiaChiChuHopDong: UILabel!
    @IBOutlet weak var lbSdtChuHopDong: UILabel!
    // nguoi  thue
    
    @IBOutlet weak var lbHotenNguoiThue: UILabel!
    @IBOutlet weak var lbCMNDNguoiThue: UILabel!
    @IBOutlet weak var lbNgayCapNguoiThue: UILabel!
    @IBOutlet weak var lbNoiCapNguoiThue: UILabel!
    @IBOutlet weak var lbSdtNguoiThue: UILabel!
    
    @IBOutlet weak var lbNoiDungHopDong: UILabel!
    @IBOutlet weak var lbHanHopDong: UILabel!
    @IBOutlet weak var lbGiaThueCanHo: UILabel!
    @IBOutlet weak var lbSoTienCoc: UILabel!
    
    @IBOutlet weak var lbSoDienSoNuoc: UILabel!
    @IBOutlet weak var lbGiaDienGiaNuoc: UILabel!
    
    
    @IBOutlet weak var lbDichVuCanHo: UILabel!
    
    var hopDongObject: HopDong? = nil
    var canHoObject: CanHo? = nil
    var khachHangObject: KhachHang? = nil
    var accountObject: Account? = nil
    var listdichVu: [DichVu] = []
    var listDichVu_HopDong: [HopDong_DichVu] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listdichVu = Storage.shared.getObjects(type: DichVu.self) as! [DichVu]
        listDichVu_HopDong = Storage.shared.getObjects(type: HopDong_DichVu.self) as! [HopDong_DichVu]
        let accounts = Storage.shared.getObjects(type: Account.self) as! [Account]
        accountObject = accounts.filter({$0.IdAccount == self.hopDongObject?.IdChuCanHo}).first?.copy() as? Account

        let listKhachHang = Storage.shared.getObjects(type: KhachHang.self) as! [KhachHang]
        khachHangObject = listKhachHang.filter({ $0.idKhachHang == hopDongObject?.IdKhachHang }).first?.copy() as? KhachHang
        let listCanHo = Storage.shared.getObjects(type: CanHo.self) as! [CanHo]
        canHoObject = listCanHo.filter({ $0.IdCanHo == hopDongObject?.IdCanHo }).first?.copy() as? CanHo
        bindingData()

    }

    
    func bindingData() {
        lbHotenChuCanHo.text = "Họ và tên: " + (self.accountObject?.hoten ?? "")
        lbCMNDChuHopDong.text = "CMND: " + (self.accountObject?.CMND ?? "")
        lbNgayCapChuHopDong.text = "Ngày cấp: " + (self.accountObject?.ngayCap.formatDate() ?? "")
        lbNoiCapChuHopDong.text = "Nơi cấp: " + (self.accountObject?.noiCap ?? "")
        lbDiaChiChuHopDong.text = "Địa chỉ: " + (self.accountObject?.diaChi ?? "")
        lbSdtChuHopDong.text = "Số điện thoại: " + (self.accountObject?.sdt ?? "")
        
        // nguoi thue
        lbHotenNguoiThue.text = "Họ và tên: " + (self.khachHangObject?.TenKH ?? "")
        lbCMNDNguoiThue.text = "CMND: " + (self.khachHangObject?.CMND ?? "")
        lbNgayCapNguoiThue.text = "Ngày cấp: " + (self.khachHangObject?.NgayCap.formatDate() ?? "")
        lbNoiCapNguoiThue.text = "Nơi cấp: " + (self.khachHangObject?.NoiCap ?? "")
        lbSdtNguoiThue.text = "Số điện thoại: " + (self.khachHangObject?.SDT ?? "")
        
        lbNoiDungHopDong.text = "Bên A đồng ý cho bên B thuê căn hộ mã " + (self.canHoObject?.IdCanHo ?? "") + " tại địa chỉ " + (self.canHoObject?.DiaChi ?? "")
        lbHanHopDong.text = "Từ " + (self.hopDongObject?.NgayBD.formatDate() ?? "") + " đến " + (self.hopDongObject?.NgayKT.formatDate() ?? "")
        lbGiaThueCanHo.text = "Bên A đồng ý cho bên B thuê  với giá: " + (self.canHoObject?.DonGia.toNumberString(decimal: false) ?? "") + " VND/tháng"
        lbSoTienCoc.text = "Sau khi ký hợp đồng cho thuê nhà, bên B phải đặt cọc trước cho bên cho bên A số tiền là " + (self.hopDongObject?.SoTienCoc.toNumberString(decimal: false) ?? "")
        
        if let hopDongObject = hopDongObject{
            lbSoDienSoNuoc.text = """
            + Số điện căn hộ: \(hopDongObject.SoDienBd)
            + Số nước căn hộ: \(hopDongObject.SoNuocBd)
            """
            
            lbGiaDienGiaNuoc.text = """
            + Giá điện căn hộ: \(hopDongObject.TienDien.toNumberString(decimal: false)) / số
            + Số nước căn hộ: \(hopDongObject.TienNuoc.toNumberString(decimal: false)) / số
            """
        }
        let listDichVu_HopDongSelected = self.listDichVu_HopDong.filter({ $0.IdHopDong == hopDongObject?.IdHopDong })
        var text: String = ""
            for item in listDichVu_HopDongSelected {
                if let getDichVu = self.listdichVu.filter({ $0.idDichVu == item.IdDichVu }).first {
                    text += " \(getDichVu.TenDichVu) : \(item.DonGia.toNumberString(decimal: false)) \(getDichVu.DonVi) \n "
                }
            }
            lbDichVuCanHo.text = "Các dịch vụ trong căn hộ : \n" + text
    }
    
    
    @IBAction func eventClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
