//
//  MyTextField.swift
//  ConnectPOS
//
//  Created by Black on 10/6/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit


@objc protocol MyTexfieldDelegate: class{
    @objc optional func myTextfieldShouldReturn(_ textField: MyTextField)
    @objc optional func myTextfieldDidEndEditing(_ textField: MyTextField)
}

@IBDesignable class MyTextField: UITextField {
    
    weak var textfieldDelegate: MyTexfieldDelegate?
    
    // MARK: - Padding for text
    public var padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    // Property
    var autoSelectAllOnFocus: Bool = false
    // Save Default
    var borderColor: UIColor?
    
    // MARK: - Style
    override init(frame: CGRect) {
        super.init(frame: frame)
        restyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        restyle()
    }
    
    func setBorderColor(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
        borderColor = UIColor(cgColor: color.cgColor)
    }
    
    func restyle(borderColor color: UIColor = UIColor.gray.withAlphaComponent(0.8)) {
        self.font = UIFont.systemFont(ofSize: 13)
        self.textColor = UIColor.black
        self.backgroundColor = .clear
        self.layer.cornerRadius = MyUI.buttonCornerRadius
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.spellCheckingType = .no
        self.delegate = self
        borderColor = UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor)
    }
    

    
    func warning() {
        // Set warning color
        DispatchQueue.main.async {
           self.layer.borderColor = UIColor.red.cgColor
        }
    }

}

extension MyTextField : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.layer.borderColor = borderColor?.cgColor
        textfieldDelegate?.myTextfieldDidEndEditing?(self)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.layer.borderColor = UIColor.cyan.cgColor
        self.layer.borderWidth = 1
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if autoSelectAllOnFocus {
            DispatchQueue.main.async {
                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let tfdelegate = textfieldDelegate {
            tfdelegate.myTextfieldShouldReturn?(self)
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
}

