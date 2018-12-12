//
//  CategorySample.swift
//  ConnectPOS
//
//  Created by HarryNg on 10/16/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit
import SnapKit
@objc protocol CategoryViewDelegate: class {
    @objc optional func sendEventOpenCategory(id: String)
    @objc optional func sendEventSlidePicture(tagButton tag: Int)
}

class CategoryView: UIView {
    // Image background
    var imgBackgound: UIImageView!
    // Button to touch
    var btnButton: MyButton!
    // Delegate
    weak var delegate: CategoryViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpCategoryDefaultView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpCategoryDefaultView()
    }
    
    func setImageButton(urlStr urlstr:String) -> Void {
        imgBackgound.contentMode = .scaleAspectFit
        imgBackgound.layer.zPosition = -1000
    }
    
    func setUpCategoryDefaultView() -> Void {
        self.layer.cornerRadius = 6.0
        // Background Image
        self.imgBackgound = UIImageView(image: UIImage(named: "default"))
        imgBackgound.clipsToBounds = true
        imgBackgound.contentMode = .scaleAspectFill
        self.addSubview(imgBackgound)
        imgBackgound.snp.makeConstraints({make in
            make.edges.equalTo(self).inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        })
        
        // Button
        self.btnButton  = MyButton(frame: .zero)
        self.btnButton.circleAnBorderButton(radius: MyUI.buttonCornerRadius, border: 0.0)
        self.btnButton.titleLabel?.numberOfLines = 0
        self.btnButton.backgroundColor  = UIColor.clear
        self.btnButton.addTarget(self, action:  #selector(eventClickButton(_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(btnButton)
        btnButton.snp.makeConstraints({make in
            make.edges.equalTo(self).inset(UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0))
        })
    }
    
    @objc func eventClickButton(_ sender: Any) {
        if let button = sender as? MyButton {
            delegate?.sendEventOpenCategory?(id: button.idCategory)
            delegate?.sendEventSlidePicture?(tagButton: self.tag)
        }
    }
    
//    func configureView(category: Category,
//                       fontButton font: UIFont = UIFont.boldSystemFont(ofSize: 13),
//                       holderColor colorHolder: UIColor = MyColor.colorCategory,
//                       alphaHolder alpha: CGFloat = 0.8) {
//        self.btnButton.setTitle(category.name.uppercased(), for: .normal)
//        self.btnButton.titleLabel?.font = font
//        self.btnButton.idCategory = category.id
//        self.btnButton.levelButton = category.level
//        self.btnButton.backgroundColor = colorHolder.withAlphaComponent(alpha)
//        self.imgBackgound.sd_setImage(with: URL(string: category.image_url), placeholderImage: UIImage(named: "default"))
//    }
    
    func boderViewColor(colorBoder color:UIColor) -> Void {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
    }
}
