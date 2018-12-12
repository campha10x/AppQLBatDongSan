//
//  QLCanHoTableViewCell.swift
//  AppQLBatDongSan
//
//  Created by User on 10/27/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import Alamofire

class QLCanHoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lbTieuDe: UILabel!
    @IBOutlet weak var lbGiaCanho: UILabel!
    @IBOutlet weak var lbMaCanHo: UILabel!
    
    @IBOutlet weak var lbNgayDang: UILabel!
    @IBOutlet weak var lbDienTich: UILabel!
    @IBOutlet weak var lbMoTa: UILabel!
    @IBOutlet weak var imgAnhCanHo: UIImageView!
    var delegate: eventProtocols?
    
    static let id = "QLCanHoTableViewCell"
    
    let manager = Alamofire.SessionManager()
    var index: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configService()
        self.imgAnhCanHo.contentMode = .scaleAspectFit
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
    @IBAction func eventRemove(_ sender: Any) {
        delegate?.eventRemove(self.index)
    }
    
    @IBAction func eventEdit(_ sender: Any) {
        delegate?.eventEdit(self.index)
    }
    
    
    func binding(canHo: CanHo, index: Int )  {
        self.index = index
        lbTieuDe.text = canHo.TieuDe
        lbMoTa.text = canHo.MoTa
        lbGiaCanho.text = "Giá: " + canHo.DonGia.toNumberString(decimal: false) +  " /tháng"
        lbDienTich.text = "Diện tích: " + canHo.DienTich + " m2"
        lbMaCanHo.text = "Mã căn hộ: CT" + canHo.IdCanHo
        lbNgayDang.text = canHo.NgayTao.formatDate()
        let listImage = canHo.AnhCanHo.split(separator: ",")
        guard let imgFirst = listImage.first else { return }
        // The image to dowload
        let stringUrl = "https://localhost:5001/CanHo/Image/\(imgFirst)"
        if let remoteImageURL = URL(string: stringUrl) {
            
            manager.request(remoteImageURL).responseData { (response) in
                if response.error == nil {
                    if let data = response.data {
                        self.imgAnhCanHo.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
}
