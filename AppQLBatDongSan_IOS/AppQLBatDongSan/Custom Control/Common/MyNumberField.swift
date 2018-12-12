//
//  MyNumberField.swift
//  ConnectPOS
//
//  Created by User on 3/2/18.
//  Copyright © 2018 SmartOSC Corp. All rights reserved.
//

import UIKit

enum MyNumberFieldFormat {
    case integer // not decimal
    case money // = decimal + fragtion by setting
    case decimal // same with money -> for using after. Dùng trong trường hợp sau này cần decimal và money khác số lượng số sau dấu phẩy
    case percent // decimal fixed 2
    static let PercentMaxFragtion = 5
}

class MyNumberFieldLeft: MyNumberField {
    // MARK: - For Alignment
    override public var padding: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
        set{
            // No need implement
        }
    }
    
}

class MyNumberFieldRight: MyNumberField {
    // MARK: - For Alignment
    override public var padding: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
        set{
            // No need implement
        }
    }
}

protocol MyNumberFieldDelegate {
    func numberFieldEndEditing(_ textfield: MyNumberField)
    func numberFieldChanged(_ textfield: MyNumberField)
}

class MyNumberField: MyTextField {
    let defaultFragtion = 0
    
    // delegate
    var numberDelegate : MyNumberFieldDelegate?
    var isRemoveComma: Bool = false
    // For format number decimal
    private var value_ : Double = 0 // true value of text
    private var number: String = "" // input text
    var isNagative: Bool = false
    var format: MyNumberFieldFormat = .decimal
    
    private var _autoSelectAllOnFocus: Bool = true
    override var autoSelectAllOnFocus: Bool {
        get { return _autoSelectAllOnFocus}
        set { _autoSelectAllOnFocus = newValue }
    }
    
    func setValue(_ string: String?) {
        guard let string = string else {return}
        setValue(Double(string) ?? 0)
    }
    
    func setValue(_ value: Double) {
        value_ = value
        if format == .integer {
            value_ = round(value_)
            number = "\(Int(value_))"
            text = value_.formatNumber(type: format, isRemoveComma: self.isRemoveComma)
        }
        else {
            // money | decimal
            number = String(format: "%0.\(defaultFragtion)f", value_)
            number = number.replacingOccurrences(of: ".", with: "")
            text = value_.formatNumber(type: format, isRemoveComma: self.isRemoveComma)
        }
    }
    
    func getValue() -> Double {
        return value_
    }
    
    func getValueString() -> String {
        return "\(value_)"
    }
    
    // MARK: - For Alignment
    override public var padding: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        set{
            // No need implement
        }
    }
    
    // MARK: - Public methods to set or unset this uitextfield as NumericKeyboard.
    func setAsNumericKeyboard(type: MyNumberFieldFormat, autoSelectAll: Bool, allowNegative: Bool = false) {
        self.format = type
        let numericKeyboard = NumericKeyboard(frame: CGRect(x: 0, y: 0, width: 0, height: kDLNumericKeyboardRecommendedHeight), type: type)
        numericKeyboard.setShowPercent(isShow: type == .percent)
        numericKeyboard.setAllowNegative(allowNegative)
        self.inputView = numericKeyboard
        numericKeyboard.delegate = self
        self.autocapitalizationType = .none
        let shortcut: UITextInputAssistantItem? =  self.inputAssistantItem
        shortcut?.leadingBarButtonGroups = []
        shortcut?.trailingBarButtonGroups = []
        
        let viewForDoneButtonOnKeyboard = UIToolbar()
        viewForDoneButtonOnKeyboard.sizeToFit()
        viewForDoneButtonOnKeyboard.items = []
        viewForDoneButtonOnKeyboard.frame = .zero
        self.inputAccessoryView = viewForDoneButtonOnKeyboard
        
        // select all
        autoSelectAllOnFocus = autoSelectAll
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    func unsetAsNumericKeyboard() {
        if let numericKeyboard = self.inputView as? NumericKeyboard {
            numericKeyboard.delegate = nil
        }
        self.inputView = nil
    }
}

extension MyNumberField: NumericKeyboardDelegate {
    func textFromKey(_ key: Int) -> String {
        if key == NumericKeyboardTag.tag00.rawValue {
            return "00"
        }
        if key == NumericKeyboardTag.tagComma.rawValue {
            return NumericKeyboard.decimalSymbol
        }
        return "\(key)"
    }
    
    func numericKeyPressed(key: Int) {
//        if let textRange = self.selectedTextRange {
//            let selectedText = self.text(in: textRange)
//            if selectedText != "" {
//                self.text = ""
//            }
//        }
        
        // check selected range
        if let empty = self.selectedTextRange?.isEmpty, empty == false {
            // Force select all !!!
            number = ""
            value_ = 0
        }
        let text = textFromKey(key)
        if format == .money || format == .decimal || format == .integer || format == .percent {
            // Auto add comma
            if key == NumericKeyboardTag.tagComma.rawValue{
                return
            }
            number += text
            // value
            if format == .integer {
                value_ = round(Double(number) ?? 0)
            }
            else {
                value_ = (Double(number) ?? 0)/(pow(10, Double(defaultFragtion)))
            }
            applyText()
//            self.text = value_.formatNumber(type: format)
        }
//        else if format == .percent {
//            if key == NumericKeyboardTag.tagComma.rawValue && number.contains(NumericKeyboard.decimalSymbol){
//                return
//            } else {
//                number += text
//                value_ = Double(number) ?? 0
//            }
//            self.text = number
//        }
        numberDelegate?.numberFieldChanged(self)
    }
    
    func numericBackspacePressed(){
        guard number != "" else { return }
        if let empty = self.selectedTextRange?.isEmpty, empty == false {
            // Force select all !!!
            number = ""
            value_ = 0
        }
        else {
            number.removeLast()
            if format == .money || format == .decimal || format == .percent {
                if number.last == Character.init(".") {
                    number.removeLast()
                }
//                // value
//                if format == .percent {
//                    value_ = Double(number) ?? 0
//                }
//                else{
                    value_ = (Double(number) ?? 0)/(pow(10, Double(defaultFragtion)))
//                }
            }
            else if format == .integer {
                value_ = round(Double(number) ?? 0)
            }
        }
        //self.text = value_.formatNumber(type: format)
        applyText()
        numberDelegate?.numberFieldChanged(self)
    }
    
    func comandKeyBoard(tagComand: Int){
        // return
        
        numberDelegate?.numberFieldEndEditing(self)
        self.resignFirstResponder()
    }
    
    func percentNumerric(percent: Int){
        // clear
        longPressedBackSpace()
        // set new
        setValue(Double(percent/100))  // because percent tag = percent * 100
        // hide keyboard
        
        numberDelegate?.numberFieldEndEditing(self)
        self.resignFirstResponder()
    }
    
    func longPressedBackSpace(){
        value_ = 0
        number = ""
//        self.text = ""
        applyText()
        numberDelegate?.numberFieldChanged(self)
    }
    
    func operatorKeyPressed(tagOperator: Int) {
        isNagative = !isNagative
        applyText()
    }
    
    func applyText(){
        self.text = (isNagative && value_ > 0 ? "-" : "") + value_.formatNumber(type: format, isRemoveComma: self.isRemoveComma)
    }
    
}
