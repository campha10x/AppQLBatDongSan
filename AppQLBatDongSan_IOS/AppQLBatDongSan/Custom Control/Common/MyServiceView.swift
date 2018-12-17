//
//  MyServiceView.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 12/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import SnapKit

class MyServiceView: UIView {
    
    var text: String {
        get {
            return labelTitle.text ?? ""
        } set {
            labelTitle.text = newValue
        }
    }
    
    var donGia: Double {
        get {
            return tfNumber.getValue()
        } set {
            tfNumber.setValue(newValue)
            tfNumber.applyText()
        }
    }
    
    let labelTitle: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.font = UIFont.systemFont(ofSize: 17)
        return lbl
    }()
    
    
    let tfNumber: MyNumberField = {
        let tf = MyNumberField()
        tf.setAsNumericKeyboard(type: .money, autoSelectAll: true)
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()
    }
    
    func style() {
        self.addSubview(labelTitle)
        self.addSubview(tfNumber)
        labelTitle.snp.makeConstraints({make in
            make.leading.equalTo(self.snp.leading)
            make.width.equalTo(300)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        })
        tfNumber.snp.makeConstraints({make in
            make.leading.equalTo(self.labelTitle.snp.trailing).offset(20)
            make.trailing.equalTo(self.snp.trailing)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        })
    }

}
