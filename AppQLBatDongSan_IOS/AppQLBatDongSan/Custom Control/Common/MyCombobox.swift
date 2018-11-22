//
//  MyCombobox.swift
//  ConnectPOS
//
//  Created by Black on 10/9/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit

@objc protocol MyComboboxDelegate:class {
    @objc optional func mycombobox(_ cbb: MyCombobox, selectedAt index: Int)
    @objc optional func mycombobox(_ cbb: MyCombobox, selectionsChanged indexs: [Int]?)
}

@IBDesignable class MyCombobox: UIButton {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var delegate : MyComboboxDelegate?
    private var labelText: UILabel!
    private var iconArrow : UIImageView!
    private var dropdown : ExpandView?
    private var _options : [String]? = nil
    private var borderColor: UIColor?
    var colorTextSearch = UIColor.black
    
    fileprivate var options : [String]? {
        get{
            return _options
        }
        set(newvalue) {
            _options = newvalue
            if let options_ = _options, options_.count > 0 /*, self.text == nil */ /* comment this, because need to set text for selected item */{
                if _isMultipleSelection {
                    if _selectedIndexs != nil {
                        dropdownMultiselectionChanged()
                    }
                }
                else{
                    if let index = _selectedIndex, index < options_.count, index >= 0 {
                        self.text = options_[index]
                        self.delegate?.mycombobox?(self, selectedAt: index)
                    }
                }
            }
        }
    }
    
    var dropdownBackgroundColor : UIColor = .white
    var dropdownForcegroundColor : UIColor = UIColor.black
    var dropdownBackgroundSelectedColor : UIColor = UIColor.init(netHex: 0x2AA69C)
    var dropdownForcegroundSelectedColor : UIColor = .white
    var searchable : Bool = false
    var indexsDisable:[Int] = [Int]()
    
    // Inspect property
    var textFont : UIFont? {
        get {
            return labelText.font
        }
        set(newValue) {
            labelText.font = newValue
        }
    }
    
    var textColor : UIColor {
        get {
            return labelText.textColor
        }
        set (newValue) {
            labelText.textColor = newValue
        }
    }
    
    private var _isMultipleSelection : Bool = false
    var isMultipleSelection : Bool {
        get{
            return _isMultipleSelection
        }
        set(newvalue) {
            _isMultipleSelection = newvalue
            dropdown?.isMultipleSelection = _isMultipleSelection
        }
    }
    
    private var _selectedIndexs: [Int]?
    var selectedIndexs : [Int]? {
        get {
            return _selectedIndexs
        }
        set(value) {
            _selectedIndexs = value
            dropdown?.applySelection()
        }
    }
    
    func disableIndexs(indexs:[Int]){
       self.indexsDisable = indexs
    }
    
    
    private var _selectedIndex: Int?
    var selectedIndex : Int? {
        get {
            return _selectedIndex
        }
        set(value) {
            _selectedIndex = value
            dropdown?.applySelection()
        }
    }
    
    // Text & PlaceHolder
    fileprivate(set) var text : String? {
        get{
            return labelText.text
        }
        set(newvalue) {
            labelText.text = newvalue
            if newvalue == nil && _options != nil && _options!.count > 0 {
                labelText.text = _options![0]
            }
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            labelText.alpha = isEnabled ? 1 : 0.5
            iconArrow.alpha = isEnabled ? 1 : 0.5
        }
    }
    
    // INIT
    convenience init(text _text: String) {
        self.init(type: .custom)
        self.text = _text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        style()
    }
    

    
    // MARK: Set option & index
    
    func setOptions(_ options_: [String] = [], placeholder: String? = nil, selectedIndex index: Int? = nil) {
        // 0
        selectedIndex = index
        // Set text placeholder first, because in set Options checking nil value of placeholder
        //1
        self.text = placeholder
        if !options_.isEmpty {
            //2
            self.options = options_
        }
    }
    
    func selectedAt(index: Int, notice: Bool = false) {
        if let options = self.options, index < options.count && index >= 0 {
            selectedIndex = index
            self.text = options[index]
        }
        else{
            selectedIndex = index
        }
        dropdown?.selectAtIndex(index, notice: notice)
    }
    
    // MARK: - Action
    @objc func onPressed(sender: MyCombobox) {
        setupDropdown()
        dropdown?.show(searchable: searchable)
    }
    
    func setupDropdown() {
        // delete if need
        dropdown?.delegate = nil
        dropdown?.anchorView = nil
        dropdown = nil
        // create new
        dropdown = ExpandView(options: options ?? ["-"],
                              tag: self.tag,
                              font: self.labelText.font,
                              optionTitleColor: dropdownForcegroundColor,
                              optionTitleSelectedColor: dropdownForcegroundSelectedColor,
                              optionBackgroundColor: dropdownBackgroundColor,
                              optionBackgroundSelectedColor: dropdownBackgroundSelectedColor)
        dropdown?.colorTextSeach = self.colorTextSearch
        dropdown?.create(anchorView: self, indexDisable: self.indexsDisable)
        dropdown?.isMultipleSelection = _isMultipleSelection
        dropdown?.delegate = self
        if _isMultipleSelection {
            dropdown?.selectedIndexs = _selectedIndexs
        }
        else{
            dropdown?.selectedIndex = _selectedIndex
        }
    }
    
}

extension MyCombobox {
    // MARK: - Style
    
    func style() {
        self.setTitle("", for: .normal)
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = MyUI.buttonCornerRadius
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        // Icon Arrow
        iconArrow = UIImageView(frame: .zero)
        iconArrow.image = UIImage(named: "icon-arrow-combobox")
        iconArrow.contentMode = .center
        self.addSubview(iconArrow)
        iconArrow.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-MyUI.padding/2)
            make.centerY.equalTo(self)
            make.width.equalTo(10)
            make.height.equalTo(10)
        }
        
        // text
        labelText = UILabel(frame: .zero)
        labelText.font = UIFont.systemFont(ofSize: 14)
        labelText.textColor = .black
        labelText.numberOfLines = 0
        self.addSubview(labelText)
        labelText.snp.makeConstraints({make in
            make.leading.equalTo(self).offset(MyUI.textPadding)
            make.top.equalTo(self).offset(0)
            make.bottom.equalTo(self).offset(0)
            make.trailing.equalTo(iconArrow.snp.leading).offset(MyUI.textPadding)
        })
        // Pressed event
        self.addTarget(self, action: #selector(onPressed), for: .touchUpInside)
        
        saveBorderColor()
    }
    
    func setBorder() {
        self.backgroundColor = UIColor.gray
        self.layer.cornerRadius = 5
    }
    

    func saveBorderColor() {
        // save border color
        borderColor = UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
        layer.borderColor = borderColor?.cgColor
    }
    
    func warning() {
        layer.borderColor = UIColor.red.cgColor
    }
}

extension MyCombobox : ExpandViewDelgate {
    func expandView(_ expandView: ExpandView, addOption option: String, atIndex index: Int) {
        if _isMultipleSelection {
            dropdownMultiselectionChanged()
        }
        else{
            _selectedIndex = index
            self.text = option
            self.delegate?.mycombobox?(self, selectedAt: index)
        }
        layer.borderColor = borderColor?.cgColor
    }
    
    func expandView(_ expandView: ExpandView, removeOption option: String, atIndex index: Int) {
        dropdownMultiselectionChanged()
        layer.borderColor = borderColor?.cgColor
    }
    
    func dropdownMultiselectionChanged() {
        if let selections = dropdown?.selectedIndexs {
            self.text = selections.map({dropdown?.arrayOptions[$0].value ?? ""}).joined(separator: ", ")
        }
        selectedIndexs = dropdown?.selectedIndexs
        delegate?.mycombobox?(self, selectionsChanged: selectedIndexs)
    }
}
