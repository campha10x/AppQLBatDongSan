//
//  String+Extension.swift
//  ConnectPOS
//
//  Created by Black on 10/10/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit


struct POSFormatter {
    static let date = DateFormatter()
    static let number = NumberFormatter()
    
}

struct DateFormat {
    static let Server = "yyyy-MM-dd HH:mm:ss"
    static let DayFull = "EEEE, MMMM dd%@ yyyy"
    static let DayString = "EE, MMM dd%@ yyyy"
    static let DayShortCut = "EE, MMM dd, yyyy"
    static let DayAndTimeShortCut = "EE, MMM dd yyyy, hh:mm:ss a"
    static let DayOnly = "MMM dd"
    static let TimeOnly = "hh:mm a"
    static let MMddyyyy = "MM/dd/yyyy"
    static let ddMMMyyHHmmss = "dd MMM yy HH:mm:ss a"
    static let Full = "EEE, MMM dd%@ yyyy, hh:mm:ss a"
}

extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}

extension String {
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }
}

extension String {

    // MARK: - calculate size
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.height
    }
    
    func widthWithConstrainedHeight(height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = (self as NSString).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.width
    }
    
    func size(maxWidth: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let boundingBox = (self as NSString).boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        return boundingBox.size
    }
}

// MARK: - Money formatter
extension String {
    func toNumber() -> NSNumber {
        let num = Double(self) ?? 0
        return NSNumber(value: num)
    }

    func toNumberString(decimal: Bool = true) -> String {
        let formatter = POSFormatter.number
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "," // hard code same web do
        formatter.decimalSeparator = "."
        formatter.maximumFractionDigits = decimal ? 2 : 0
        formatter.minimumFractionDigits = 0
        formatter.minimumIntegerDigits = 1
        formatter.groupingSize = 3
        return formatter.string(from: self.toNumber()) ?? self
    }

//    func formatNumber(format: String? = nil, type: MyNumberFieldFormat ) -> String {
//        return (Double(self) ?? 0.0).formatNumber(format: nil, type: type)
//    }

}

// MARK: - Date formatter
extension String {
    
    func formatDate(date: String = "MM/dd/yyyy HH:mm:ss", dateTo: String = "dd/MM/yyyy" ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = date
        
        let dateReceived: Date = dateFormatter.date(from:  self)!
        dateFormatter.dateFormat = dateTo
        
        return  dateFormatter.string(from: dateReceived)
    }
    
    func toDate(isDayOnly: Bool = false) -> Date? {
        let formatter = POSFormatter.date
        formatter.calendar = Calendar.current
        formatter.dateFormat = DateFormat.Server
        let result = formatter.date(from: self)
        if !isDayOnly || result == nil {
            return result
        }
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: result!)
    }
    
    
    func toDate(format:String) ->Date? {
        
        let formatter = POSFormatter.date
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    func toTime() -> Date? {
        let formatter = POSFormatter.date
        formatter.dateFormat = "hh:mm a"
        return formatter.date(from: self)
    }
}

// HTML convert
extension String {
    func convertHtmlToAttribuedString() -> NSAttributedString? {
        guard !self.isEmpty else {
            return nil
        }
        var text = self
        if !text.contains("font-family") {
            // Set Default font -> OpenSans-14
            text = "<span style=\"font-size: 14px; font-family: sans-serif,OpenSans;\">\(self)</span>"
        }
        guard let data = text.data(using: .utf8, allowLossyConversion: false) else {return nil}
        do {
            let attributeText = try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
            return attributeText
        } catch {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
}

extension NSAttributedString {
    func convertToHtml() -> String {
        let documentAttributes = [NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.html]
        do {
            let htmlData = try self.data(from: NSMakeRange(0, self.length), documentAttributes:documentAttributes)
            if let htmlString = String(data: htmlData, encoding: String.Encoding.utf8) {
                /*
                 "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">\n
                 <html>
                 \n<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n<meta http-equiv=\"Content-Style-Type\" content=\"text/css\">\n<title></title>\n<meta name=\"Generator\" content=\"Cocoa HTML Writer\">\n<style type=\"text/css\">\np.p1 {margin: 0.0px 0.0px 0.0px 0.0px; font: 14.0px \'.SF UI Text\'}\nspan.s1 {font-family: \'.SFUIText\'; font-weight: normal; font-style: normal; font-size: 14.00pt}\n</style>\n</head>\n
                 <body>\n<p class=\"p1\"><span class=\"s1\">Tying<span class=\"Apple-converted-space\"> </span></span></p>\n</body>\n
                 </html>\n"
                */
                // minimize html string
                // 1 - remove header <Document>, tag <html>
                if let html1 = htmlString.components(separatedBy: "<html>").last?.components(separatedBy: "</html>").first {
                    // 2 - remove meta tag, remove <span class=\"Apple-converted-space\">
                    if let html2 = html1.components(separatedBy: "<style type=\"text/css\">").last?.replacingOccurrences(of: "<span class=\"Apple-converted-space\">", with: "").replacingOccurrences(of: "</span>", with: "") {
                        return "<head><style type=\"text/css\">" + html2
                    }
                }
                return htmlString
            }
        }
        catch {
            print("error creating HTML from Attributed String")
        }
        return ""
    }
}


extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
