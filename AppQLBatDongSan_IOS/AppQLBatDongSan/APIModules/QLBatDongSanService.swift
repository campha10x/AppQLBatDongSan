//
//  QLBatDongSanService.swift
//  AppQLBatDongSan
//
//  Created by User on 9/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias CompletionHandler = (JSON?, Error?) -> Void

enum key: String {
    case loadPhong = "loadPhong"
    case loadHoaDon = "loadHoaDon"
    case loadNhaTro = "loadNhaTro"
    case loadPhieuThu = "loadPhieuThu"
    case loadPhieuChi = "loadPhieuChi"
    case loadKhachHang = "loadKhachHang"
    case loadDichVu = "loadDichVu"
    case loadDonVi = "loadDonVi"
    case loadHopDong = "loadHopDong"
    case removeHopDong = "removeHopDong"
    
    case removeHoaDon = "removeHoaDon"
    case removePhieuChi = "removePhieuChi"
    case removeKhachHang = "removeKhachHang"
    
    case editKhachHang = "editKhachHang"
    case editPhieuChi = "editPhieuChi"
    
    case login = "login"
    case addPhieuThu = "addPhieuThu"
    case removePhieuThu = "removePhieuThu"
}

class QLBatDongSanService {
    static let shared = QLBatDongSanService()
    var completions: [key : CompletionHandler] = [:]
    
    static var Manager: Alamofire.SessionManager = Alamofire.SessionManager()

}
