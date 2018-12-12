//
//  SlidePictureViewController.swift
//  ConnectPOS
//
//  Created by HarryNg on 10/18/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit
import Alamofire
protocol DelegateSlidePictureViewController:class {
    func showPicuterWhenTap(strUlr: String)
}

class SlidePictureViewController: UIViewController {
    weak var delegate:DelegateSlidePictureViewController?
    var arrayImage = [String]()
    let manager = Alamofire.SessionManager()
    
    @IBOutlet weak var scrollViewImage: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if arrayImage.count > 0 {
            self.addSlideShowPicture()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addSlideShowPicture() -> Void {
        var xPostion:CGFloat = 10.0
        let heightView: CGFloat = scrollViewImage.frame.size.height*0.6
        if arrayImage.count > 0 {
            for index in 0...arrayImage.count-1 {
                let viewCatery:CategoryView = CategoryView.init(frame: CGRect(x: xPostion, y: 0, width: 120, height: heightView))
                let stringUrl = "https://localhost:5001/CanHo/Image/\(arrayImage[index])"
                if let remoteImageURL = URL(string: stringUrl) {
                    
                    manager.request(remoteImageURL).responseData { (response) in
                        if response.error == nil {
                            if let data = response.data {
                                viewCatery.imgBackgound.image = UIImage(data: data)
                            }
                        }
                    }
                }
                
                
                viewCatery.setImageButton(urlStr: arrayImage[index])
                viewCatery.boderViewColor(colorBoder: UIColor(red: 233, green: 233, blue: 233))
                viewCatery.tag = index
                viewCatery.clipsToBounds = true
                scrollViewImage.addSubview(viewCatery)
                viewCatery.delegate = self
                xPostion = xPostion + viewCatery.frame.size.width + 10.0
            }
            scrollViewImage.contentSize = CGSize(width: xPostion, height:  scrollViewImage.frame.size.height*0.5)
        }
        self.view.layoutIfNeeded()
    }
}

extension SlidePictureViewController : CategoryViewDelegate {
    func sendEventSlidePicture(tagButton tag: Int) {
        delegate?.showPicuterWhenTap(strUlr:arrayImage[tag])
    }
}
