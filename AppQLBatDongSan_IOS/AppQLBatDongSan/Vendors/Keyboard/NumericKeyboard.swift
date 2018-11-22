//
//  NumericKeyboard.swift
//  Zipwire Location Validator
//
//  Created by Ignacio Nieto Carvajal on 13/10/16.
//  Copyright © 2016 Zipwire. All rights reserved.
//

//smartosc Customer 31/10/2107
// - Change type keyboard
// - Hidden inputAssistantItem
// - Add funcion Longpress BackSpace
// - Add number percent 

import UIKit


// public consts
let kDLNumericKeyboardRecommendedHeight = 344

enum NumericKeyboardTag: Int {
    case tag00 = 100
    case tag0 = 0
    case tag1 = 1
    case tag2 = 2
    case tag3 = 3
    case tag4 = 4
    case tag5 = 5
    case tag6 = 6
    case tag7 = 7
    case tag8 = 8
    case tag9 = 9
    case tagComma = -1
    case tagDelete = -3
    case tagReturn = -2
    case tagDone = -4
    case tagPercent50 = 5000
    case tagPercent25 = 2500
    case tagPercent10 = 1000
    case tagPercent5 = 500
    case tagMinus = -5
}

@objc protocol NumericKeyboardDelegate {
    func numericKeyPressed(key: Int)
    func numericBackspacePressed()
    func comandKeyBoard(tagComand: Int)
    func percentNumerric(percent: Int)
    func longPressedBackSpace()
    func operatorKeyPressed(tagOperator: Int)
}

class NumericKeyboard: UIView {
    static let decimalSymbol = "."
    
    // private consts
    private let kDLNumericKeyboardNormalImage = UIImage(named: "numericKeyNormalBackground")!
    private let kDLNumericKeyboardPressedImage = UIImage(named: "numericKeyPressedBackground")!
    
    private let kDLBackSpaceNormalImage = UIImage(named: "key-delete")!
    private let kDLBackSpacePressedImage = UIImage(named: "key-delete-pressed")!
    private let kDLReturnNormalImage = UIImage(named: "key-return")!
    private let kDLReturnPressedImage = UIImage(named: "key-return-Pressed")!

    // numbers
    @IBOutlet weak var buttonKey00: UIButton!
    @IBOutlet weak var buttonKey0: UIButton!
    @IBOutlet weak var buttonKey1: UIButton!
    @IBOutlet weak var buttonKey2: UIButton!
    @IBOutlet weak var buttonKey3: UIButton!
    @IBOutlet weak var buttonKey4: UIButton!
    @IBOutlet weak var buttonKey5: UIButton!
    @IBOutlet weak var buttonKey6: UIButton!
    @IBOutlet weak var buttonKey7: UIButton!
    @IBOutlet weak var buttonKey8: UIButton!
    @IBOutlet weak var buttonKey9: UIButton!
    
    // comma
    @IBOutlet weak var buttonKeyComma: UIButton!
    
    @IBOutlet weak var buttonMinus: UIButton!
    
    // backspace
    @IBOutlet weak var buttonKeyBackspace: UIButton!
    
    // Command
    @IBOutlet weak var buttonKeyReturn: UIButton!
    @IBOutlet weak var buttonKeyDone: UIButton!
    
    //percent
    
    @IBOutlet weak var buttonPercent50: UIButton!
    @IBOutlet weak var buttonPercent25: UIButton!
    @IBOutlet weak var buttonPercent10: UIButton!
    @IBOutlet weak var buttonPercent5: UIButton!
    
    var isShowPercent:Bool = false
    
    // all button numberic
    var allButtonsNumberRic: [UIButton] {
        return [buttonKey0, buttonKey1, buttonKey2, buttonKey3, buttonKey4, buttonKey5, buttonKey6, buttonKey7, buttonKey8, buttonKey9,buttonKey00, buttonPercent50, buttonPercent25, buttonPercent10, buttonPercent5, buttonKeyComma, buttonKeyDone]
        
    }
    
    // data
    weak var delegate: NumericKeyboardDelegate?
  
    // MARK: - Initialization and lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeKeyboard()
        
    }
    
    convenience init (frame: CGRect, type: MyNumberFieldFormat? = nil) {
        self.init(frame: frame)
        if type == .integer || type == .money {
            buttonKeyComma.isEnabled = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeKeyboard()
    }
    
    func initializeKeyboard() {
        // set view
        let xibFileName = "NumericKeyboard"
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        buttonKeyComma.setTitle(NumericKeyboard.decimalSymbol, for: .normal)
        // set buttons appearance.
        self.updateButtonsAppearance()
    }
    
    func setAllowNegative(_ allow: Bool) {
        buttonMinus.isHidden = !allow
    }
    
    func setShowPercent(isShow: Bool) -> Void {
        self.isShowPercent = isShow
        if isShowPercent {
            self.buttonPercent5.isHidden = false
            self.buttonPercent10.isHidden = false
            self.buttonPercent25.isHidden = false
            self.buttonPercent50.isHidden = false
        }else {
            self.buttonPercent5.isHidden = true
            self.buttonPercent10.isHidden = true
            self.buttonPercent25.isHidden = true
            self.buttonPercent50.isHidden = true
        }
    }
    
    // MARK: - Changes in appearance
    fileprivate func setImageBackSpace() {
        
    }
    
    fileprivate func updateButtonsAppearance() {
        for button in allButtonsNumberRic {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
            button.setTitleColor(UIColor.black, for: .normal)
            button.setBackgroundImage(kDLNumericKeyboardNormalImage, for: .normal)
            button.setBackgroundImage(kDLNumericKeyboardPressedImage, for: .highlighted)
        }
        //Key BackSpace
        self.buttonKeyBackspace.setBackgroundImage(kDLBackSpaceNormalImage, for: .normal)
        self.buttonKeyBackspace.setBackgroundImage(kDLBackSpacePressedImage, for: .highlighted)
        //Key Done
        self.buttonKeyDone.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        self.buttonKeyDone.setBackgroundImage(kDLNumericKeyboardNormalImage, for: .normal)
        self.buttonKeyDone.setBackgroundImage(kDLNumericKeyboardPressedImage, for: .highlighted)
        //Key Return
         self.buttonKeyReturn.setBackgroundImage(kDLReturnNormalImage, for: .normal)
        self.buttonKeyReturn.setBackgroundImage(kDLReturnPressedImage, for: .highlighted)
        // Long gesture
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap)) 
        buttonKeyBackspace.addGestureRecognizer(longGesture)
        
        // Tag
        buttonKey00.tag = NumericKeyboardTag.tag00.rawValue
        buttonKey0.tag = NumericKeyboardTag.tag0.rawValue
        buttonKey1.tag = NumericKeyboardTag.tag1.rawValue
        buttonKey2.tag = NumericKeyboardTag.tag2.rawValue
        buttonKey3.tag = NumericKeyboardTag.tag3.rawValue
        buttonKey4.tag = NumericKeyboardTag.tag4.rawValue
        buttonKey5.tag = NumericKeyboardTag.tag5.rawValue
        buttonKey6.tag = NumericKeyboardTag.tag6.rawValue
        buttonKey7.tag = NumericKeyboardTag.tag7.rawValue
        buttonKey8.tag = NumericKeyboardTag.tag8.rawValue
        buttonKey9.tag = NumericKeyboardTag.tag9.rawValue
        buttonKeyComma.tag = NumericKeyboardTag.tagComma.rawValue
        buttonKeyBackspace.tag = NumericKeyboardTag.tagDelete.rawValue
        buttonKeyReturn.tag = NumericKeyboardTag.tagReturn.rawValue
        buttonKeyDone.tag = NumericKeyboardTag.tagDone.rawValue
        buttonPercent50.tag = NumericKeyboardTag.tagPercent50.rawValue
        buttonPercent25.tag = NumericKeyboardTag.tagPercent25.rawValue
        buttonPercent10.tag = NumericKeyboardTag.tagPercent10.rawValue
        buttonPercent5.tag = NumericKeyboardTag.tagPercent5.rawValue
        buttonMinus.tag = NumericKeyboardTag.tagMinus.rawValue
    }
   
    
    @objc func handleTap() {
       self.delegate?.longPressedBackSpace()
    }
    
    // MARK: - Button actions
    @IBAction func numericButtonPressed(_ sender: UIButton) {
        self.delegate?.numericKeyPressed(key: sender.tag)
    }
    
    @IBAction func backspacePressed(_ sender: AnyObject) {
        self.delegate?.numericBackspacePressed()
    }
    
    @IBAction func comandPressed(_ sender: UIButton) {
        self.delegate?.comandKeyBoard(tagComand: sender.tag)
    }
    
    @IBAction func percentNumberric(_ sender: UIButton) {
        self.delegate?.percentNumerric(percent: sender.tag)
    }
    
    @IBAction func operatorPressed(_ sender: UIButton) {
        self.delegate?.operatorKeyPressed(tagOperator: sender.tag)
    }
    
    
}
