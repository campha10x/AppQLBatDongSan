//
//  CanHoInforViewController.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 12/10/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Alamofire

class CanHoInforViewController: UIViewController {

    var canHoObject: CanHo? = nil
    @IBOutlet weak var lbThongTinMoTa: UILabel!
    
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var lbDienTich: UILabel!
    @IBOutlet weak var lbTieuDe: UILabel!
    @IBOutlet weak var lbKhuVuc: UILabel!
    @IBOutlet weak var lbGia: UILabel!
    let manager = Alamofire.SessionManager()
    @IBOutlet weak var viewBanDo: UIView!
    var mapViewOutlet: MapViewCustom?
    
    @IBOutlet weak var lbDichVu: UILabel!
    
    var listDichVu_CanHo: [CanHo_DichVu] = []
    var listDichVu: [DichVu] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listDichVu_CanHo = Storage.shared.getObjects(type: CanHo_DichVu.self) as! [CanHo_DichVu]
        listDichVu = Storage.shared.getObjects(type: DichVu.self) as! [DichVu]
        configData()
        displayDataWith()
        configService()
        initMapview()
    }
    
    func configData() {
        if let canHoObject = canHoObject {
            lbTieuDe.text = canHoObject.TieuDe
            lbKhuVuc.text = "Khu vực: " + canHoObject.DiaChi
            lbGia.text = "Giá: " + canHoObject.DonGia.toNumberString(decimal: false)
            lbDienTich.text = "Diện tích: " + canHoObject.DienTich + " m2"
            lbThongTinMoTa.text = canHoObject.MoTa
            if let dichVuObjects = listDichVu_CanHo.filter({ $0.IdCanHo == self.canHoObject?.IdCanHo }).first  {
                let string = dichVuObjects.IdDichVu.components(separatedBy: ",")
                var listDichVuSelected: [DichVu] = []
                for item in string {
                    if let dichVu = self.listDichVu.filter({ $0.idDichVu == item}).first {
                        listDichVuSelected.append(dichVu)
                    }
                }
                lbDichVu.text = "Các dịch vụ: " + listDichVuSelected.reduce("", { $0 + $1.TenDichVu + ", " })
            }

            
        }
    }
    
    func initMapview() {
        DispatchQueue.main.async {
            let latitude: Double = 34.052234200000001
            let longitude: Double = -118.24368490000001
            if let mapView = MapViewCustom.createMapKit(latitude:latitude, longitude: longitude, frame: CGRect.init(x: self.viewBanDo.frame.origin.x, y: self.viewBanDo.frame.origin.y, width: self.viewBanDo.frame.width, height: self.viewBanDo.frame.height)) {
                self.viewBanDo.addSubview(mapView)
                mapView.snp.makeConstraints { (make) in
                    make.top.equalTo(self.viewBanDo)
                    make.leading.equalTo(self.viewBanDo)
                    make.trailing.equalTo(self.viewBanDo)
                    make.bottom.equalTo(self.viewBanDo)
                }
                self.mapViewOutlet = mapView
            }
            
            self.mapViewOutlet?.searchPlaceFromGoogle(place: self.canHoObject?.DiaChi ?? "")
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

    @IBAction func eventClickBackCanHo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayDataWith(){
        let listImage = canHoObject?.AnhCanHo.split(separator: ",")
        guard let imgFirst = listImage?.first else { return }
        // The image to dowload
        let stringUrl = "https://localhost:5001/CanHo/Image/\(imgFirst)"
        if let remoteImageURL = URL(string: stringUrl) {
            
            manager.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    if let data = response.data {
                        self.imgShow.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is SlidePictureViewController {
            let slidePictureVC = segue.destination as? SlidePictureViewController
            if let meidi_gallery = canHoObject?.AnhCanHo.components(separatedBy: ",") {
                slidePictureVC?.delegate = self
                slidePictureVC?.arrayImage = meidi_gallery
            }
            
        }
    }
}

extension CanHoInforViewController: DelegateSlidePictureViewController {
    func showPicuterWhenTap(strUlr:String) {
        // The image to dowload
        let stringUrl = "https://localhost:5001/CanHo/Image/\(strUlr)"
        if let remoteImageURL = URL(string: stringUrl) {
            
            manager.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    if let data = response.data {
                        self.imgShow.image = UIImage(data: data)
                    }
                }
            }
        }
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: self.imgShow, duration: 0.6, options: transitionOptions, animations: {
            self.imgShow.isHidden = true
        })
        
        UIView.transition(with: self.imgShow, duration: 0.6, options: transitionOptions, animations: {
            self.imgShow.isHidden = false
        })
    }
}
