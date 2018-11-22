//
//  MyButton.swift
//  ConnectPOS
//
//  Created by Black on 10/6/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit

@IBDesignable class MyButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var idCategory: String = ""
    var levelButton: Int = 0
    convenience init(text: String = "") {
        self.init(type: .custom)
        self.setTitle(text, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        restyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        restyle()
    }
    
    func restyle() {
        self.clipsToBounds = true
        self.setBackgroundColor(color: .clear, forState: .normal)
        self.contentHorizontalAlignment = .center
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    }

//    func setUnderlineText(_ text: String, color: UIColor, underline: Bool) {
//        if underline == true {
//            let discountAttribute : [NSAttributedStringKey: Any] = [
//                NSAttributedStringKey.font : MyFont.semiBold,
//                NSAttributedStringKey.strikethroughColor : color,
//                NSAttributedStringKey.foregroundColor : color,
//                NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
//            
//            let attributeString = NSMutableAttributedString(string: text,
//                                                            attributes: discountAttribute)
//            self.setAttributedTitle(attributeString, for: .normal)
//        } else {
//            let discountAttribute : [NSAttributedStringKey: Any] = [
//                NSAttributedStringKey.font : MyFont.semiBold,
//                NSAttributedStringKey.strikethroughColor : color,
//                NSAttributedStringKey.foregroundColor : color,
//                NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleNone.rawValue]
//            
//            let attributeString = NSMutableAttributedString(string: text,
//                                                            attributes: discountAttribute)
//            self.setAttributedTitle(attributeString, for: .normal)
//        }
//    }
}
