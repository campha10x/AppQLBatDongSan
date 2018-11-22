//
//  AppSetting.swift
//  AppQLBatDongSan
//
//  Created by User on 9/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit

struct MyUI {
    static let textPadding : CGFloat = 10
    static let padding : CGFloat = 20
    static let alertCornerRadius : CGFloat = 6
    static let buttonCornerRadius : CGFloat = 6
    static let groupCornerRadius : CGFloat = 10
    static let buttonHeight : CGFloat = 40
    static let labelHeight : CGFloat = 30
}

struct Global {
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let screenSize = UIScreen.main.bounds
    static let ipad = UIDevice.current.userInterfaceIdiom == .pad
}

// MARK: - Timer duration
struct TimerDuration {
    static let search = 3.0
    static let notice = 3.0
}

struct RealmSetting {
    static let schemaVersion: UInt64 = 9
}

// Color using in app
struct MyColor {
    static let clear = UIColor.clear
    static let veryblack = UIColor(netHex: 0x333333)
    static let veryVeryDarkGray = UIColor(netHex: 0x7D7D7D)
    static let black = UIColor(netHex: 0x4f4f4f)
    static let lightBlack = UIColor(netHex: 0x777777)
    static let quiteLightcyan = UIColor(netHex: 0x089A90)
    static let veryCyan = UIColor(netHex: 0x49C2B9)
    static let lightCyan = UIColor(netHex: 0x1FA69D)
    static let cyan = UIColor(netHex: 0x1fa79d)
    static let quiteCyan = UIColor(netHex: 0x189188)
    static let cyanHover = UIColor(netHex: 0x49c2b9)
    static let orange = UIColor(netHex: 0xffab21)
    static let veryOrange = UIColor(netHex: 0xFFAB21)
    static let lightOrange = UIColor(netHex: 0xffc15b)
    static let veryVeryOrange = UIColor(netHex: 0xf48924)
    static let red = UIColor(netHex: 0xfc636b)
    static let redDark = UIColor(netHex: 0xbd6669)
    static let lightGray = UIColor(netHex: 0xf5f5f5)
    static let gray = UIColor(netHex: 0xC7C7C7)
    static let veryGray = UIColor(netHex: 0xBCC3CB)
    static let darkGray = UIColor(netHex: 0x818181)
    static let settingBackground = UIColor(netHex: 0xecf0f3)
    static let quiteLightGray = UIColor(netHex: 0xe0e0e0)
    static let colorCategory = UIColor(netHex: 0xbd6669)
    static let veryLightGray = UIColor(netHex: 0xeeeeee)
    static let white = UIColor(netHex: 0xffffff)
    static let veryLightBlack = UIColor(netHex: 0x999999)
    static let quiteLightBlack = UIColor(netHex: 0x555555)
    static let veryQuiteLightGray = UIColor(netHex: 0xBBBBBB)
    static let quiteDarkGray = UIColor(netHex: 0xE1E1E1)
    static let purple = UIColor(netHex: 0x1F3246)
    static let lightBlue = UIColor(netHex: 0xF3F6F8)
    static let veryDarkGray = UIColor(netHex: 0xE6E6E6)
    static let veryDark = UIColor(netHex: 0x8D96A1)
    static let veryQuiteDarkGray = UIColor(netHex: 0xF0F0F0)
    static let quiteBlack = UIColor(netHex: 0x666666)
    static let veryVeryGray = UIColor(netHex: 0xCCCCCC)
    static let veryVeryBlack = UIColor(netHex: 0x555555)
    static let trueBlack = UIColor(netHex: 0x000000)
    
    
    static let colorBackgroundEnablePayButton = UIColor.init(red: 42, green: 166, blue: 156)
    static let colorBackgroundNagativeButton = UIColor(netHex: 0xFC636B)
    
    static let lightGrayBackground = UIColor.init(red: 245, green: 245, blue: 245)
    static let colorCostItem = UIColor.init(red: 42, green: 166, blue: 156)
    static let colorNameItem = UIColor.init(red: 102, green: 102  , blue: 102)
    static let colorIdItem = UIColor.init(red: 129, green: 129, blue: 129)
    static let colorCountItem = UIColor.init(red: 253, green: 170, blue: 55)
    static let colorBorderImageItem = UIColor.init(red: 194, green: 194, blue: 194)
    static let colorBackgroundItemCell = UIColor.init(red: 235, green: 235, blue: 235)
    static let colorBackgroundDisablePayButton = UIColor.init(red: 164, green: 213, blue: 209)
    static let colorBackgroundTouchEnablePayButton = UIColor.init(red: 19, green: 50, blue: 87)
    static let colorBackgroundTouchDisablePayButton = UIColor.init(red: 155, green: 167, blue: 182)
    static let colorPathFolder = UIColor.init(red: 29, green: 157, blue: 146)
    
    static let whiteWithAlpha = UIColor.init(white: 1, alpha: 0.5)
    static let quiteWhiteWithAlpha = UIColor.init(white: 1, alpha: 0.06)
    
    
    //Quick Login
    static let colorWhite = UIColor.init(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    static let colorLabelDisable = UIColor.init(red: 119.0/255.0, green: 119.0/255.0, blue: 119.0/255.0, alpha: 1.0)
    static let colorImageDisSelected = UIColor.init(red: 125.0/255.0, green: 125.0/255.0, blue: 125.0/255.0, alpha: 1.0)
    static let backgoundViewSelected = UIColor.init(red: 73.0/255.0, green: 194.0/255.0, blue: 185.0/255.0, alpha: 1.0)
    static let backgoundViewDisSelected = UIColor.init(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
}
