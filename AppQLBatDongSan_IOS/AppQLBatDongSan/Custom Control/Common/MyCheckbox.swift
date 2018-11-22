//
//  MyCheckbox.swift
//  ConnectPOS
//
//  Created by Black on 10/6/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit
import SnapKit

// Checkbox & Radiobox
@IBDesignable class MyCheckbox: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    // UI Elements
    var icon : UIImageView!
    var title : UILabel!
    private var _isRadio : Bool = false
    @IBInspectable var isRadioBox : Bool {
        get {
            return _isRadio
        }
        set(newValue) {
            _isRadio = newValue
            self.isSelected = _isSelected
        }
    }
    
    @IBInspectable var text : String? {
        get {
            return title.text
        }
        set(newValue) {
            title.text = newValue
        }
    }
    
    @IBInspectable var iconwidth : Int {
        get {
            return 0
        }
        set(newValue) {
            icon.snp.updateConstraints { (make) in
                make.width.equalTo(newValue)
            }
        }
    }
    
    // Event
    var onSelectedChanged: ((MyCheckbox) -> Void)?
    
    convenience init(text t: String, isRadio: Bool) {
        self.init(type: .custom) // Next: override init(frame: CGRect) -> No need call style() here
        self.text = t
        self.isRadioBox = isRadio
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()
    }
    
    func style() {
        self.setTitle("", for: .normal)
        self.setTitle("", for: .selected)
        self.setBackgroundImage(nil, for: .normal)
        self.setBackgroundImage(nil, for: .selected)
        self.setImage(nil, for: .normal)
        self.setImage(nil, for: .selected)
        // icon
        icon = UIImageView(frame: CGRect.zero)
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        self.addSubview(icon)
        icon.snp.makeConstraints({make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.width.equalTo(18)
            make.height.equalTo(20)
        })
        
        title = UILabel(frame: CGRect.zero)
        title.font = UIFont.boldSystemFont(ofSize: 13)
        title.textColor = UIColor.black
        title.textAlignment = .left
        title.numberOfLines = 0
        self.addSubview(title)
        title.snp.makeConstraints({make in
            make.leading.equalTo(icon.snp.trailing).offset(MyUI.padding/2)
            make.trailing.equalTo(self).offset(-MyUI.padding/2)
            make.top.equalTo(self)
            make.bottom.greaterThanOrEqualTo(self)
        })
        
        // Set begin value
        self.isSelected = false
        
        // Add touch event
        self.addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }
    
    fileprivate var _isSelected = false
    override var isSelected: Bool {
        get {
            return _isSelected
        }
        set (newValue) {
            _isSelected = newValue
            if _isSelected {
                icon.image = UIImage(named: _isRadio ? "icon_radioG" : "icon_checked")
            }
            else{
                icon.image = UIImage(named: _isRadio ? "icon_radio" : "icon_check")
            }
        }
    }
    
    @objc func onClick(_ sender: UIButton) {
        if !_isRadio {
            // Check box -> change state on click
            self.isSelected = !self.isSelected
            self.onSelectedChanged?(self)
        }
        else if !self.isSelected {
            // Radio box -> only clickable when state is unchecked
            self.isSelected = true
            self.onSelectedChanged?(self)
        }
    }

}
