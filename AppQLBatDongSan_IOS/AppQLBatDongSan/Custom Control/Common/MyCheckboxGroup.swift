//
//  MyCheckboxGroup.swift
//  ConnectPOS
//
//  Created by Black on 10/8/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit
import SnapKit


@IBDesignable class MyCheckboxGroup: UIView {

    var onSelectedAtIndex: ((_ index: Int) -> Void)?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var labelTitle : UILabel!
    var viewBody: UIView!
    var lineView: UIView!
    
    private(set) var boxGroup : [MyCheckbox] = []
    private(set) var isRadio : Bool = false
    var minSelectionCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style(title: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style(title: "")
    }

//    convenience init(checkbox: [Int: String], title: String) { // [key: name]
//        self.init(frame: CGRect.zero)
//        // Style
//        labelTitle.text = title
//        // Add content
//        _ = addOptions(checkbox)
//    }
    
    convenience init(radiobox: [Int: String], title: String) { // [key: name]
        self.init(frame: CGRect.zero)
        // Style
        labelTitle.text = title
        // Add content
        _ = addOptions(radiobox, isRadioBox: true)
    }
    
    func style(title: String) {
        self.clipsToBounds = true
        self.layer.cornerRadius = MyUI.buttonCornerRadius
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.white.cgColor
    
        // body
        viewBody = UIView(frame: .zero)
        viewBody.backgroundColor = .clear
        self.addSubview(viewBody)
        viewBody.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(MyUI.padding)
            make.trailing.equalTo(self.snp.trailing).offset(MyUI.padding)
            make.top.equalTo(self.snp.top).offset(MyUI.padding)
            make.bottom.equalTo(self.snp.bottom).offset(MyUI.padding)
        }
    }
    
    @discardableResult func addTitleAndOptions(_ title: String, options: [Int: String], isRadioBox: Bool = false, minSelectionCount: Int = 1, optionWidth: CGFloat = 90) -> CGFloat {
        self.minSelectionCount = minSelectionCount
        // let itemwidth = (optionWidth - MyUI.padding*2)/2
        let height = addOptions(options, isRadioBox: isRadioBox)
        return height + MyUI.padding * 1.5 + 20
    }
    
    fileprivate func addOptions(_ options: [Int: String], isRadioBox: Bool = false, optionWidth: CGFloat = 110) -> CGFloat {
        isRadio = isRadioBox
        for item in boxGroup{
            item.removeFromSuperview()
        }
        boxGroup.removeAll()
        let dict = options.sorted(by: {$0.key < $1.key})
        let minCellHeight: CGFloat = 30
        var height : CGFloat = 0
        for item in dict {
            let index = boxGroup.count
            let col = CGFloat(index % 2)
            let last : MyCheckbox? = col == 1 ? self.boxGroup[index - 1] : nil
            // Create box
            let box = MyCheckbox()
            box.tag = item.key
            box.backgroundColor = .clear
            box.text = item.value
            box.isRadioBox = isRadioBox
            box.onSelectedChanged = {[weak self] b in
                if isRadioBox {
                    self?.boxGroup.filter({$0.isSelected && $0 != b}).forEach({$0.isSelected = false})
                    self?.onSelectedAtIndex?(b.tag)
                }
                else {
                    // Checkbox -> check min select
                    if b.isSelected == false && (self?.boxGroup.filter({$0.isSelected}).count ?? 0) < (self?.minSelectionCount ?? 0) {
                        // Prevent event
                        b.isSelected = true
                    }
                }
            }
            
            viewBody.addSubview(box)
            let boxHeight = max(minCellHeight, item.value.heightWithConstrainedWidth(width: optionWidth - 25 /* checkbox */, font: box.title.font))
            box.snp.makeConstraints({ (make) in
                if col == 0 {
                    make.leading.equalTo(viewBody)
                    make.top.equalTo(viewBody).offset(height)
                }
                else if col == 1 {
                    make.leading.equalTo(last!.snp.trailing)
                    make.width.equalTo(last!)
                    make.trailing.equalTo(viewBody)
                    make.top.equalTo(last!.snp.top)
                }
                make.height.equalTo(boxHeight)
            })
            box.clipsToBounds = true
            boxGroup.append(box)
            // Incease col when calculated bolt 2 col
            if col == 1{
                height += max(boxHeight, last!.frame.height)
            }
        }
        return height
    }
    
    func radioSelectId(_ id: Int) {
        if isRadio {
            boxGroup.forEach({item in
                item.isSelected = item.tag == id
            })
        }
    }
    
    func selecteAt(index i: Int?){
        guard let index = i, index >= 0 && index < boxGroup.count else { return }
        let box = boxGroup[index]
        if isRadio {
            boxGroup.forEach({$0.isSelected = false})
        }
        self.onSelectedAtIndex?(box.tag)
        box.isSelected = true
    }
    
    func selectetedOption(indexs array: [Int]?){
        guard let arrayOption = array, arrayOption.count > 0 && boxGroup.count >= arrayOption.count else {
            return
        }
        for i in 0...arrayOption.count-1 {
            let box = boxGroup[arrayOption[i]]
            if isRadio {
                boxGroup.forEach({$0.isSelected = false})
            }
            box.isSelected = true
        }
    }
    
    // get selected index
    var selectedId: Int? {
        get {
            return boxGroup.first(where: {$0.isSelected})?.tag
        }
    }
    
    // get selected index
    var selectedText: String? {
        get {
            return boxGroup.first(where: {$0.isSelected})?.text
        }
    }
    
    var selectedIds: [Int]? {
        get {
            return boxGroup.filter({$0.isSelected}).map({$0.tag})
        }
    }
}




