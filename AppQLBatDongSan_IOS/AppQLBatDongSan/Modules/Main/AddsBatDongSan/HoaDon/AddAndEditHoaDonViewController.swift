//
//  AddAndEditHoaDonViewController.swift
//  AppQLBatDongSan
//
//  Created by User on 11/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class AddAndEditHoaDonViewController: UIViewController {

    @IBOutlet weak var cbbCanHo: MyCombobox!
    @IBOutlet weak var tfSoPhieu: MyTextField!
    @IBOutlet weak var tfSotien: MyNumberField!
    @IBOutlet weak var btnNgayTao: MyButtonCalendar!
    @IBOutlet weak var btnTao: MySolidButton!
    @IBOutlet weak var viewBody: UIView!
    
    @IBOutlet weak var tfSoDienMoi: MyNumberField!
    @IBOutlet weak var tfSoNuocMoi: MyNumberField!
    @IBOutlet weak var labelHeaderTitle: UILabel!
    
    var listCanHo: [CanHo] = []
    var isCreateNew: Bool = true
    var hoadon: HoaDon? = nil
    var done: ((_ hoadon: HoaDon)->())?
    let manager = Alamofire.SessionManager()
    var soTien: Double = 0.0
    
    var selectedDichVu: [DichVu] = []
    var indexCanHo = -1
    
    var listDichVu: [DichVu] = []
    var listDichVu_CanHo: [CanHo_DichVu] = []
    var listHopDong: [HopDong] = []
    var listHoaDon: [HoaDon] = []
    
    var listHopDong_DichVu: [HopDong_DichVu] = []
    var soDienCu = 0.0
    var soNuocCu = 0.0
    var tienDien = 0.0
    var tienNuoc = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listDichVu = Storage.shared.getObjects(type: DichVu.self) as! [DichVu]
        listDichVu_CanHo = Storage.shared.getObjects(type: CanHo_DichVu.self) as! [CanHo_DichVu]
        listHopDong = Storage.shared.getObjects(type: HopDong.self) as! [HopDong]
        listHoaDon = Storage.shared.getObjects(type: HoaDon.self) as! [HoaDon]
        listHopDong_DichVu = Storage.shared.getObjects(type: HopDong_DichVu.self) as! [HopDong_DichVu]
        customized()
        configService()
        if !isCreateNew {
            tfSoPhieu.text = self.hoadon?.soPhieu
            if let index = self.listCanHo.index(where: { $0.IdCanHo == self.hoadon?.IdCanHo}) {
                tfSoDienMoi.text = self.hoadon?.soDienMoi
                tfSoNuocMoi.text = self.hoadon?.soNuocMoi
                self.cbbCanHo.setOptions(self.listCanHo.map({$0.maCanHo}), placeholder: nil, selectedIndex: index)
            }
            btnNgayTao.date = hoadon?.ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
            tfSotien.setValue(hoadon?.soTien)
            tfSoDienMoi.setValue(hoadon?.soDienMoi)
            tfSoNuocMoi.setValue(hoadon?.soNuocMoi)
            btnTao.setTitle("Sửa hoá đơn", for: .normal)
        } else {
            tfSoDienMoi.setValue(0.0)
            tfSoNuocMoi.setValue(0.0)
            tfSoPhieu.text = "SPHD-\(randomNumber(inRange: 100...50000))"
            self.cbbCanHo.setOptions(self.listCanHo.map({$0.maCanHo}), placeholder: nil, selectedIndex: nil)
            btnNgayTao.date = Date()
            btnTao.setTitle("Tạo hoá đơn", for: .normal)
        }
        tfSoDienMoi.delegate = self
        tfSoNuocMoi.delegate = self
        tfSotien.isEnabled = false
        tfSoPhieu.isEnabled = false
         viewBody.layer.cornerRadius = 6.0
    }
    
    func customized()  {
        listCanHo = Storage.shared.getObjects(type: CanHo.self) as! [CanHo]
        self.cbbCanHo.delegate = self
        cbbCanHo.textColor = MyColor.black
        cbbCanHo.dropdownBackgroundColor = MyColor.cyan
        cbbCanHo.dropdownBackgroundSelectedColor = MyColor.cyanHover
        cbbCanHo.dropdownForcegroundColor = .white
        tfSotien?.setAsNumericKeyboard(type: .money, autoSelectAll: true)
        tfSoDienMoi.setAsNumericKeyboard(type: .integer, autoSelectAll: true)
        tfSoNuocMoi.setAsNumericKeyboard(type: .integer, autoSelectAll: true)
        labelHeaderTitle.text = isCreateNew == true ? "Tạo hoá đơn" : "Sửa hoá đơn"
        
        btnNgayTao.layer.cornerRadius = 6.0
        btnNgayTao.layer.borderColor = UIColor.gray.cgColor
        btnNgayTao.layer.borderWidth = 1.0
        tfSoPhieu.isEnabled = false
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
    
    public func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
        let length = Int64(range.upperBound - range.lowerBound + 1)
        let value = Int64(arc4random()) % length + Int64(range.lowerBound)
        return T(value)
    }
    
    @IBAction func eventClickOutSide(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        btnNgayTao.date = picker.date
        recaculatorSoTien (isUpdateTextField: true)
    }
    
    @IBAction func eventClickHuyHD(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    @IBAction func eventClickTaoHD(_ sender: Any) {
        // CanHo
        let listCanHo: [CanHo] = Storage.shared.getObjects(type: CanHo.self) as? [CanHo] ?? []
        if let index = cbbCanHo.selectedIndex {
            let canHoObject = listCanHo.filter({ $0.IdCanHo == self.listCanHo[index].IdCanHo }).first?.copy() as? CanHo
            let listHopDong: [HopDong] = Storage.shared.getObjects(type: HopDong.self) as? [HopDong] ?? []
            let hopDongObject = listHopDong.filter({ $0.IdCanHo == canHoObject?.IdCanHo && $0.active }).first?.copy() as? HopDong
            
            let month = returnMonth(ngayTao: hopDongObject?.NgayKT ?? "")
            let year = returnYear(ngayTao: hopDongObject?.NgayKT ?? "" )
            let monthNow = Calendar.current.component(.month, from: Date())
            let yearNow = Calendar.current.component(.year, from: Date())
            if (month < monthNow && year == yearNow && month != 0 && year != 0 ) {
                Notice.make(type: .Error, content: "Căn hộ đã hết hợp đồng! Mời bạn gia hạn hợp đồng ").show()
                return
            }
        }
        
        let hoadon = HoaDon()
        guard tfSotien.text != ""  else {
            if tfSotien.text == "" {
                tfSotien.warning()
            }
            Notice.make(type: .Error, content: "Không được để rỗng hãy kiểm tra lại").show()
            return
        }
        
        hoadon.idHoaDon = isCreateNew ? "" : self.hoadon?.idHoaDon ?? ""
        hoadon.soTien = "\(tfSotien.getValueString())"
        hoadon.soPhieu = tfSoPhieu.text ?? ""
        hoadon.ngayTao = "\(btnNgayTao.date)"
        hoadon.soDienMoi = tfSoDienMoi.getValueString()
        hoadon.soNuocMoi = tfSoNuocMoi.getValueString()
        if let index = cbbCanHo.selectedIndex{
            hoadon.IdCanHo = "\(listCanHo[index].IdCanHo)"
        } else {
            cbbCanHo.warning()
            Notice.make(type: .Error, content: "Chưa chọn phòng, làm ơn hãy chọn ").show()
            return
        }
        
        let parameters: [String: String] = [
            "IdHoaDon" : hoadon.idHoaDon,
            "IdCanHo" : hoadon.IdCanHo ,
            "SoPhieu" : hoadon.soPhieu,
            "NgayTao" : hoadon.ngayTao.formatDate(date: "yyyy-MM-dd HH:mm:ss +HHHH", dateTo: "YYYY-MM-dd"),
            "SoTien" : hoadon.soTien,
            "SoDienMoi" : hoadon.soDienMoi,
            "SoNuocMoi" : hoadon.soNuocMoi
        ]
        if isCreateNew {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/HoaDon/AddListHoaDon", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let hoadonResponse  = HoaDon.init(json: json)
                    if let hoadonCopy = hoadonResponse.copy() as? HoaDon{
                        Storage.shared.addOrUpdate([hoadonCopy], type: HoaDon.self)
                    }
                    Notice.make(type: .Success, content: "Thêm mới hoá đơn thành công! ").show()
//                    self.dismiss(animated: true, completion: nil)
                    self.requestHoaDon(idHoaDon: hoadonResponse.idHoaDon, hoadonObject: hoadonResponse)
                    self.done?(hoadonResponse)
                    
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        } else {
            SVProgressHUD.show()
            self.manager.request("https://localhost:5001/HoaDon/EditListHoaDon", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responseObject) in
                SVProgressHUD.dismiss()
                do {
                    let json: JSON = try JSON.init(data: responseObject.data! )
                    let hoadonResponse  = HoaDon.init(json: json)
                    if let hoadonCopy = hoadonResponse.copy() as? HoaDon{
                        Storage.shared.addOrUpdate([hoadonCopy], type: HoaDon.self)
                    }
                    Notice.make(type: .Success, content: "Sửa mới hoá đơn thành công! ").show()
//                    self.dismiss(animated: true, completion: nil)
                     self.requestHoaDon(idHoaDon: hoadonResponse.idHoaDon, hoadonObject: hoadonResponse)
                    self.done?(hoadonResponse)
                } catch {
                    if let error = responseObject.error {
                        Notice.make(type: .Error, content: error.localizedDescription).show()
                    }
                }
            }
        }
    }
    
    func requestHoaDon(idHoaDon: String, hoadonObject: HoaDon){
        var listDichVuDocument: [ChiTietHoaDon] = []
        let hopdong_DichVu = Storage.shared.getObjects(type: HopDong_DichVu.self) as! [HopDong_DichVu]
        listDichVu = Storage.shared.getObjects(type: DichVu.self) as! [DichVu]
        // CanHo
        let listCanHo: [CanHo] = Storage.shared.getObjects(type: CanHo.self) as? [CanHo] ?? []
        let canHoObject = listCanHo.filter({ $0.IdCanHo == hoadonObject.IdCanHo }).first?.copy() as? CanHo
        let listHopDong: [HopDong] = Storage.shared.getObjects(type: HopDong.self) as? [HopDong] ?? []
        let hopDongObject = listHopDong.filter({ $0.IdCanHo == canHoObject?.IdCanHo && $0.active }).first?.copy() as? HopDong
        let listHoaDon: [HoaDon] = Storage.shared.getObjects(type: HoaDon.self) as? [HoaDon] ?? []
        
        var canHoDocumentObject = ChiTietHoaDon()
        canHoDocumentObject.Id_HoaDon = hoadonObject.idHoaDon
        canHoDocumentObject.TenDichVu = "Căn hộ " + (canHoObject?.maCanHo ?? "")
        canHoDocumentObject.DonGia = canHoObject?.DonGia ?? ""
        listDichVuDocument.append(canHoDocumentObject)
        
        let arrayHoadonLonNhat = listHoaDon.filter({ $0.IdCanHo == hoadonObject.IdCanHo}).sorted { (hoadon1, hoadon2) -> Bool in
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
        guard let hopDongObjectNonOptional = hopDongObject  else { return  }
        let giaDienDocumentObject = ChiTietHoaDon()
        giaDienDocumentObject.Id_HoaDon = hoadonObject.idHoaDon
        giaDienDocumentObject.TenDichVu = "Điện"
        giaDienDocumentObject.DonGia = hopDongObjectNonOptional.TienDien
        giaDienDocumentObject.SoCu = "\(Int(soDienCu))"
        giaDienDocumentObject.SoMoi = hoadonObject.soDienMoi
        listDichVuDocument.append(giaDienDocumentObject)
        
        let giaNuocDocumentObject = ChiTietHoaDon()
        giaNuocDocumentObject.TenDichVu = "Nước"
        giaNuocDocumentObject.Id_HoaDon = hoadonObject.idHoaDon
        giaNuocDocumentObject.DonGia = hopDongObjectNonOptional.TienNuoc
        giaNuocDocumentObject.SoCu = "\(Int(soNuocCu))"
        giaNuocDocumentObject.SoMoi = hoadonObject.soNuocMoi
        listDichVuDocument.append(giaNuocDocumentObject)
        
        let selectedHopDong_DichVu = hopdong_DichVu.filter({ $0.IdHopDong == hopDongObjectNonOptional.IdHopDong} )
        for item in selectedHopDong_DichVu {
            if  let dichvuSelected = self.listDichVu.filter({ $0.idDichVu == item.IdDichVu }).first {
                var dichvuDocumentObject = ChiTietHoaDon()
                dichvuDocumentObject.TenDichVu = dichvuSelected.TenDichVu
                dichvuDocumentObject.DonGia = item.DonGia
                dichvuDocumentObject.Id_HoaDon = hoadonObject.idHoaDon
                listDichVuDocument.append(dichvuDocumentObject)
            }
        }
    
        let  parameters = listDichVuDocument.map({$0.toDics()})
            SVProgressHUD.show()
            if let url = NSURL(string: "https://localhost:5001/ChiTietHoaDon/AddOrEditListChiTietHoaDon"){
                var request = URLRequest(url: url as URL)
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
                manager.request(request as URLRequestConvertible)
                    .responseJSON { responseObject in
                        SVProgressHUD.dismiss()
                        do {
                            let json: JSON = try JSON.init(data: responseObject.data! )
                            let hoadonResponse  =  json.arrayValue.map({ChiTietHoaDon.init(json: $0)})
                            Storage.shared.delete(ChiTietHoaDon.self, ids: [hoadonObject.idHoaDon], idPrefix: "Id_HoaDon")
                            Storage.shared.addOrUpdate(hoadonResponse, type: ChiTietHoaDon.self)
                            self.dismiss(animated: true, completion: nil)
                        } catch {
                            if let error = responseObject.error {
                                Notice.make(type: .Error, content: error.localizedDescription).show()
                            }
                        }
                }
            }
    }
    
    func recaculatorSoTien (isUpdateTextField: Bool = false) {
        guard cbbCanHo.selectedIndex != nil else { return }
        soTien = 0
        if indexCanHo >= 0 {
            soTien += Double(self.listCanHo[indexCanHo].DonGia) ?? 0
            guard let hopdongObject = listHopDong.filter({$0.IdCanHo == self.listCanHo[indexCanHo].IdCanHo && $0.active }).first?.copy() as? HopDong else {
                Notice.make(type: .Error, content: "Căn hộ này cần tạo hợp đồng mới có thể tạo được hoá đơn").show()
                btnTao.isUserInteractionEnabled = false
                return
            }
            btnTao.isUserInteractionEnabled = true
            let arrayHoadonLonNhat = listHoaDon.filter({ $0.IdCanHo == self.listCanHo[indexCanHo].IdCanHo}).sorted { (hoadon1, hoadon2) -> Bool in
                let date1 = hoadon1.ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
                let date2 = hoadon2.ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss") ?? Date()
                return date1 > date2
            }
            var  hoadonLonNhat: HoaDon? = nil
            if let _ = self.hoadon, arrayHoadonLonNhat.count > 1 {
                hoadonLonNhat = arrayHoadonLonNhat[1]
            } else {
                hoadonLonNhat = arrayHoadonLonNhat.first
            }
                let components = Calendar.current.dateComponents([.year, .month, .day], from: btnNgayTao.date)
                if let hoadonLonNhat = hoadonLonNhat, let ngay1 = hoadonLonNhat.ngayTao.toDate(format: "MM/dd/yyyy HH:mm:ss"), ngay1.month == (components.month ?? 1) - 1 , ngay1.year == components.year {
                        let tienDien = Double(hopdongObject.TienDien) ?? 0
                        soDienCu = Double(hoadonLonNhat.soDienMoi) ?? 0
                        let tienNuoc = Double(hopdongObject.TienNuoc) ?? 0
                        soNuocCu = Double(hoadonLonNhat.soNuocMoi) ?? 0
                        if isUpdateTextField {
                            self.tfSoDienMoi.setValue(soDienCu)
                            self.tfSoNuocMoi.setValue(soNuocCu)
                        }
                        soTien +=  (tienDien * (tfSoDienMoi.getValue() - soDienCu ) +  tienNuoc * ( tfSoNuocMoi.getValue() - soNuocCu ) )
                } else {
                    tienDien = Double(hopdongObject.TienDien) ?? 0
                    soDienCu = Double(hopdongObject.SoDienBd) ?? 0
                    tienNuoc = Double(hopdongObject.TienNuoc) ?? 0
                    soNuocCu = Double(hopdongObject.SoNuocBd) ?? 0
                    if isUpdateTextField {
                        tfSoDienMoi.setValue(soDienCu)
                        tfSoNuocMoi.setValue(soNuocCu)
                    }
                    soTien +=  (tienDien * (tfSoDienMoi.getValue() - soDienCu ) +  tienNuoc * ( tfSoNuocMoi.getValue() - soNuocCu ) )

                }
            
            // dich vu
            if let listDichVuSelected: [HopDong_DichVu] = self.listHopDong_DichVu.filter({ $0.IdHopDong == hopdongObject.IdHopDong }) {
                soTien += listDichVuSelected.reduce(0.0, { $0 + (Double($1.DonGia) ?? 0) })
            }
            tfSotien.setValue(soTien)
        } else {
            Notice.make(type: .Error, content: "Bạn phải nhập căn hộ mới tính tiền được").show()
        }
    }

}

extension AddAndEditHoaDonViewController :MyComboboxDelegate{
    func mycombobox(_ cbb: MyCombobox, selectedAt index: Int) {
        if index < self.listCanHo.count {
            self.indexCanHo = index
            recaculatorSoTien(isUpdateTextField: true)
        }
    }
}


extension AddAndEditHoaDonViewController :UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        recaculatorSoTien()
    }
}
