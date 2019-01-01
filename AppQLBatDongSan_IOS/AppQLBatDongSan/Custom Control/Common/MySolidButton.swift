//
//  RoundedSolidButton.swift
//  ConnectPOS
//
//  Created by Black on 10/6/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit

@IBDesignable class MySolidButton: MyButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var actionHandler: (() -> Void)?
    var id : String?
    var value: String?
    
    private var _bgcolor : UIColor?
    open override var backgroundColor: UIColor? {
        get {
            return bgcolor
        }
        set (newvalue) {
            bgcolor = newvalue
        }
    }
    
    
    @IBInspectable var bgcolor : UIColor? {
        get{
            return _bgcolor
        }
        set (newvalue) {
            _bgcolor = newvalue ?? UIColor.clear
            self.setBackgroundColor(color: _bgcolor!, forState: .normal)
        }
    }
    
    override func restyle() {
        super.restyle()
        self.layer.cornerRadius = MyUI.buttonCornerRadius
//        self.setBackgroundColor(color:  UIColor(netHex: 0x1fa79d), forState: .normal)
        self.backgroundColor = UIColor(netHex: 0x1fa79d)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.addTarget(self, action: #selector(onPressed), for: .touchUpInside)
        if self.imageView != nil {
            setPositionImageAndText()
        }
    }
    
    func setPositionImageAndText() {
        titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        imageEdgeInsets = UIEdgeInsets(top: 5, left: 15 , bottom: 5, right:  30)
    }
    
    @objc func onPressed(sender: Any) {
        actionHandler?()
    }
}
