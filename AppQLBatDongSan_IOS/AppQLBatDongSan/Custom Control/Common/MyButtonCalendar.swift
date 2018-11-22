//
//  MyButtonCalendar.swift
//  ConnectPOS
//
//  Created by Black on 10/23/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit

@IBDesignable class MyButtonCalendar: UIButton {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    private var _date : Date?
    var date: Date {
        get{
            return _date ?? Date()
        }
        set(newdate) {
            let datestring = newdate.toString(format: DateFormat.DayString)
            self.setTitle(datestring, for: .normal)
            _date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: newdate) // remove time
        }
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
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = MyUI.buttonCornerRadius
        self.setTitleColor(UIColor.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0)
    }
    
}
