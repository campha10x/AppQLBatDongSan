//
//  Notice.swift
//  ConnectPOS
//
//  Created by Black on 10/10/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit

enum NoticeType : Int{
    case Info = 0
    case Warning = 1
    case Success = 2
    case Error = 3
}

class NoticeGroup {
    static let shared = NoticeGroup()
    var notices : [Notice] = []
    
    private var deleting = false
    private var stackDeleteNotices: [Notice] = []
    
    func popNotice(_ notice : Notice){
        guard !deleting /* in deleting other notice */ && !notice.animatingShow /* this notice showing */ else {
            if stackDeleteNotices.first(where: {$0.tag == notice.tag}) == nil {
                stackDeleteNotices.append(notice)
            }
            return
        }
        deleting = true
        if notices.count > notice.tag {
            notices.remove(at: notice.tag)
        }
        DispatchQueue.main.async {[weak self] in
            self?.updatePosition()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
            self?.deleting = false
            if let no = self?.stackDeleteNotices.first {
                self?.stackDeleteNotices.removeFirst()
                self?.popNotice(no)
            }
        }
    }
    
    //Close All notice Apply when show network
    func closeAllNoticeNetWork() {
        if notices.count > 0 {
            let tmp = notices.filter({$0.noticeNetWork})
            tmp.forEach({$0.close()})
        }
    }
    
    func updatePosition() {
        var height : CGFloat = MyUI.padding
        for i in 0..<notices.count {
            let no = notices[i]
            no.tag = i
            var frame = no.frame
            frame.origin.y = height
            UIView.animate(withDuration: 0.2, animations: {
                no.frame = frame
            })
            height += no.calculatedSize.height + MyUI.padding
        }
    }
    
    func addNotice(_ notice: Notice){
        notice.tag = notices.count
        notices.append(notice)
    }
    
    func height() -> CGFloat {
        return notices.reduce(MyUI.padding, {result, notice in
            return result + notice.calculatedSize.height + MyUI.padding
        })
    }
    
    func originTopOf(notice: Notice) -> CGFloat {
        var top = MyUI.padding
        for i in 0..<min(notice.tag, notices.count) {
            top += notices[i].calculatedSize.height + MyUI.padding
        }
        return top
    }
}

class Notice: PopupBase {
   
    var noticeNetWork:Bool = false
    @IBOutlet weak var iconType: UIImageView!
    @IBOutlet weak var labelContent: UILabel!
    var timer : Timer?
    
    private var _type : NoticeType = .Info
    var type : NoticeType {
        get{
            return _type
        }
        set(newType) {
            _type = newType
            self.backgroundColor = color()
            iconType.image = icon()
        }
    }
    
    class func make(type: NoticeType, content: String , isNetWork:Bool = false) -> Notice {
        let view = Bundle.main.loadNibNamed("Notice", owner: self, options: nil)![0] as! Notice
        view.type = type
        view.labelContent.text = content
        view.noticeNetWork = isNetWork
        // Update size
        view.updateSize()
        return view
    }

    override func awakeFromNib() {
        customize()
    }
    
    func updateSize() {
        let maxNoticeWidth = Global.screenSize.width/4
        let content = labelContent.text ?? ""
        let height = content.heightWithConstrainedWidth(width: maxNoticeWidth, font:UIFont.systemFont(ofSize: 16)) + 20
        //let width = content.widthWithConstrainedHeight(height: height, font: MyFont.big) + 150 // icon + close button
        let width = maxNoticeWidth + 150 // icon + close button
        calculatedSize = CGSize(width: max(minWidth, width), height: max(minHeight, height))
    }
    
    private func customize() {
        self.clipsToBounds = true
        self.layer.cornerRadius = MyUI.alertCornerRadius
//        labelContent.font = MyFont.big
        labelContent.font = UIFont.systemFont(ofSize: 16)
        labelContent.textColor = .white
        labelContent.numberOfLines = 0
    }
    
    private func icon() -> UIImage? {
        switch type {
        case .Info:
            return UIImage(named: "notice-info")
        case .Warning:
            return UIImage(named: "notice-warning")
        case .Success:
            return UIImage(named: "notice-success")
        case .Error:
            return UIImage(named: "icon-denied")
        }
    }
    
    private func color() -> UIColor {
        switch type {
        case .Info:
            return UIColor(netHex: 0x56c0e0)
        case .Warning:
            return UIColor(netHex: 0xfbb040)
        case .Success:
            return UIColor(netHex: 0x58b957)
        case .Error:
            return UIColor(netHex: 0xdb524b)
        }
    }
    
    // MARK: - Actions
    @IBAction func actionClose(_ sender: Any) {
        close()
    }
    
    // MARK: - Override show function
    func show() {
        guard let content = self.labelContent.text, content != "" else {return}
        DispatchQueue.main.async {
            self.show(position: .custom)
        }
        NoticeGroup.shared.addNotice(self)
    }
    
    override func afterShown() {
        timer = Timer.scheduledTimer(timeInterval: TimerDuration.notice, target: self, selector: #selector(closeNotice), userInfo: nil, repeats: false)
    }
    
    @objc func closeNotice() {
        close()
    }
    
    override func close() {
        timer?.invalidate()
        timer = nil
        NoticeGroup.shared.popNotice(self)
        super.close()
    }
    

    override func customConstraintTop() -> CGFloat {
        return NoticeGroup.shared.originTopOf(notice: self)
    }
}
