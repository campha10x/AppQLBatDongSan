//
//  MyServiceView.swift
//  AppQLBatDongSan
//
//  Created by Duy Xuan on 12/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class MyServiceGroupView: UIView {
    private(set) var boxGroup : [MyServiceView] = []

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addOptions(_ options: [Int: (text: String, number: Double)]) {
        for item in boxGroup{
            item.removeFromSuperview()
        }
        boxGroup.removeAll()
        let dict = options.sorted(by: {$0.key < $1.key})
        var top = 10
        for item in dict {
            // Create box
            let box = MyServiceView()
            box.tag = item.key
            box.backgroundColor = .clear
            box.text = item.value.text
            box.donGia = item.value.number
            self.addSubview(box)
            box.snp.makeConstraints({ (make) in
                make.leading.equalTo(self)
                 make.trailing.equalTo(self)
                make.top.equalTo(self).offset(top)
                make.height.equalTo(45)
            })
            top += 65
            box.clipsToBounds = true
            boxGroup.append(box)
        }
    }
    
    func getDichVuAmount() -> [(idDichVu: String, amount: Double)] {
        var arrayDichVu: [(idDichVu: String, amount: Double)] = []
        for item in boxGroup {
            let dichvuAmount: (idDichVu: String, amount: Double) = ("\(item.tag)",item.donGia)
            arrayDichVu.append(dichvuAmount)
        }
        return arrayDichVu
    }
}
