//
//  ExpandView.swift
//  Popovers
//
//  Created by HarryNg on 10/19/17.
//  Copyright © 2017 Unicorn. All rights reserved.
//

import UIKit
import SnapKit

class ExpandViewController: UIViewController {
    
    override func viewDidLoad() {
        
    }
    
    func show(dropdown: UIView) {
        self.view.addSubview(dropdown)
        dropdown.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        self.modalPresentationStyle = .overCurrentContext
        UIApplication.shared.keyWindow?.rootViewController?.present(self, animated: false, completion: nil)
    }
}

protocol ExpandViewDelgate:class {
    func expandView(_ expandView: ExpandView, addOption option:String, atIndex index: Int)
    func expandView(_ expandView: ExpandView, removeOption option:String, atIndex index: Int)
}

class ExpandView: UIView {
    weak var delegate: ExpandViewDelgate?
    var arrayOptions = [(key:Int, value : String)]()
    var searchResults = [(key:Int, value : String)]()
    
    // View
    let scrollBody = UIScrollView()
    var tfSearch : UITextField?
    weak var anchorView: UIView?
    
    // View Option
    var padding: CGFloat = 2.0
    var optionHeight: CGFloat = 44.0
    var contentHeight: CGFloat = 0.0
    
    // Text option
    var textAlignment: UIControlContentHorizontalAlignment = .center
    var font : UIFont = UIFont.systemFont(ofSize: 14)
    
    // Selection
    var isMultipleSelection: Bool = false
    var selectedIndexs: [Int]? = nil
    var selectedIndex: Int?
    
    // COlor
    var optionTitleColor =  UIColor.black
    var optionTitleSelectedColor = UIColor.white
    var optionBackgroundColor = UIColor.lightGray
    var optionBackgroundSelectedColor = UIColor.init(netHex: 0x2AA69C)
    var colorTextSeach = UIColor.black
    
    // ratio width compare anchorView.width
    var ratio: CGFloat = 1
    
    // Underline of item
    var allowBorderBottom: Bool = false
    
    // For position
    var totalHeight: CGFloat = 0
    var searchable: Bool = false
    fileprivate var originFrame: CGRect? // Use for revert frame after hide keyboard
    
    private(set) var isDirectionUp: Bool = false // direction of dropdown: up | down
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(options: [String] = [],
         tag t: Int = 0,
         font font_: UIFont? = nil,
         optionTitleColor titleNormal: UIColor = UIColor.black,
         optionTitleSelectedColor titleSelected: UIColor = UIColor.white,
         optionBackgroundColor bgNormal: UIColor = UIColor.lightGray,
         optionBackgroundSelectedColor bgSelected: UIColor = UIColor.red,
         textAlignment alignment: UIControlContentHorizontalAlignment = .left,
         optionHeight height: CGFloat = 44.0,
         padding padding_:CGFloat = 2.0) {
        if !options.isEmpty {
            for index in 0..<options.count {
                if options[index] == "" {
                    continue
                }
                let item =  (index, options[index])
                self.arrayOptions.append(item)
            }
        }
        self.optionHeight = height
        self.padding = padding_
        self.textAlignment = alignment
        self.font = font_ ?? UIFont.systemFont(ofSize: 14)
        // Color
        self.optionTitleColor =  titleNormal
        self.optionTitleSelectedColor = titleSelected
        self.optionBackgroundColor = bgNormal
        self.optionBackgroundSelectedColor = bgSelected
        // Init
        super.init(frame: .zero)
        self.tag = t
        self.searchResults = arrayOptions
    }
    
    func dismissPopOver(notification dictionData: NSNotification){
        if self.isHidden == false{
            hide()
        }
    }
    
    func createOption(indexsDisable: [Int]? = nil) {
        // Create option
        var offset: CGFloat = 0
        for index in 0...searchResults.count - 1{
            let btnOption = UIButton(type: .custom)
            btnOption.tag = searchResults[index].key
            btnOption.frame = CGRect(x: 0, y: offset, width: frame.size.width , height: optionHeight)
            btnOption.setTitle(searchResults[index].value, for: UIControlState())
            btnOption.contentHorizontalAlignment = textAlignment
            btnOption.titleEdgeInsets = UIEdgeInsets(top: 0, left: textAlignment == .left ? 20 : 0, bottom: 0, right: textAlignment == .right ? 20 : 0)
            btnOption.titleLabel?.font = font
            btnOption.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
            if let indexsDisable = indexsDisable , indexsDisable.count > 0 , indexsDisable.filter({$0 == searchResults[index].key}).first != nil {
                btnOption.isEnabled = false
                btnOption.setTitleColor(UIColor.gray, for: .normal)
            }else {
                btnOption.isEnabled = true
                btnOption.setTitleColor(optionTitleColor, for: .normal)
            }
             btnOption.setTitleColor(optionTitleSelectedColor, for: .selected)
             btnOption.setBackgroundColor(color: .clear, forState: .normal)
            if self.allowBorderBottom {
                let line = UIView.init(frame: CGRect.init(x: 20, y: btnOption.frame.height, width: (self.anchorView?.frame.width ?? 0) * ratio - 40, height: 0.1))
                line.backgroundColor = UIColor.black
                btnOption.addSubview(line)
            }
            btnOption.setBackgroundColor(color: optionBackgroundSelectedColor, forState: .selected)
            scrollBody.addSubview(btnOption)
            offset += btnOption.frame.size.height
            btnOption.autoresizingMask = UIViewAutoresizing.flexibleWidth
        }
        contentHeight = offset
        
        // set content size
        let size = scrollBody.contentSize
        scrollBody.contentSize = CGSize(width: size.width, height: offset)
    }
    
    func create(anchorView anchor: UIView,indexDisable:[Int]? = nil) -> Void {
        guard searchResults.count > 0 else { return }
        self.backgroundColor = .clear
        self.anchorView = anchor
        scrollBody.backgroundColor = optionBackgroundColor
        createOption(indexsDisable: indexDisable)
    }
    
    @objc func buttonClicked(sender : UIButton) {
        selectAtIndex(sender.tag)
    }
    
    func selectAtIndex(_ index: Int, notice: Bool = true) {
        guard let searchResult = searchResults.first(where: { $0.key == index })?.value else { return }
        if isMultipleSelection {
            // Multi select
            let checkIndex = selectedIndexs?.index(of: index)
            if checkIndex == nil {
                // Add to select list
                selectedIndexs = (selectedIndexs ?? []) + [index]
                if notice {
                    delegate?.expandView(self, addOption: searchResult , atIndex: index)
                }
            }
            else{
                // Remove from array
                selectedIndexs!.remove(at: checkIndex!)
                if notice {
                    delegate?.expandView(self, removeOption: searchResult, atIndex: index)
                }
            }
            // change button style
            changeStyleButtonAt(index: index, selected: checkIndex == nil)
        }
        else{
            // Single select
            if let current = selectedIndex, current >= 0 {
                // Deselect current
                changeStyleButtonAt(index: current, selected: false)
            }
            // select new
            selectedIndex = index
            changeStyleButtonAt(index: index, selected: true)
            if notice {
                delegate?.expandView(self, addOption: searchResult, atIndex: index)
            }
            hide()
        }
    }
    
    func changeStyleButtonAt(index: Int, selected: Bool) {
        if let button = scrollBody.subviews.first(where: {$0 is UIButton && $0.tag == index}) as? UIButton {
            button.isSelected = selected
        }
    }
    
    func applySelection() {
        for index in 0..<searchResults.count {
            if (isMultipleSelection && (selectedIndexs?.contains(index) ?? false)) || (!isMultipleSelection && selectedIndex == index) {
                changeStyleButtonAt(index: index, selected: true)
            }
            else {
                changeStyleButtonAt(index: index, selected: false)
            }
        }
    }
    
    //  Keyboard xuất hiện thì luôn luôn hiển thị dropdown lên trên .Thiếu trường hợp combobox nằm ở trên cùng màn hình trên dropdowlist hiển thị xuống dưới
    @objc func moveExpandViewTopCombobox(_ notification: NSNotification)  {
        // Get keyboard height
        var keyboardHeight: CGFloat = 320
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        calculatePositionAndMove(searchable: self.searchable, keyboardHeight: keyboardHeight)
    }
    
    @objc func onKeyboardWillHide() {
        calculatePositionAndMove(searchable: self.searchable)
    }
    
    @objc func searchDataInCombobox(sender: UITextField)  {
        guard let textSearch = sender.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) else { return  }
        searchResults = textSearch == "" ? arrayOptions : arrayOptions.filter({(text) -> Bool in
            return text.value.lowercased().contains(textSearch.lowercased())
        })
        scrollBody.subviews.forEach { (item) in
            if item is UIButton {
                item.removeFromSuperview()
            }
        }
        if searchResults.count == 0 {
            return
        }
        createOption()
    }
    
    @objc func outsideClick(gesture: UITapGestureRecognizer)  {
        hide()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if clipsToBounds || isHidden || alpha == 0 {
            return nil
        }
        for subview in subviews.reversed() {
            let subPoint = subview.convert(point, from: self)
            if let result = subview.hitTest(subPoint, with: event) {
                return result
            }
        }
        
        return nil
    }
}

// MARK: - Show - Hide
extension ExpandView {
    
    @discardableResult func calculatePositionAndMove(searchable: Bool, keyboardHeight: CGFloat = 0) -> Bool {
        guard let anchorView = anchorView else {
            return false
        }
        
        // Make search field
        createSearchField(searchable: searchable)
        
        // Keyboard
        let keyboardMode = keyboardHeight > 0
        
        // default value
        let screenHeight = Global.screenSize.height
        totalHeight = contentHeight + (searchable ? optionHeight : 0)
        
        // convert frame
        let anchorConvertedFrame = anchorView.convert(anchorView.bounds, to: nil)
        let anchorWidth = anchorConvertedFrame.size.width
        let anchorHeight = anchorConvertedFrame.size.height
        let anchorTopSpace = keyboardMode ? (screenHeight - keyboardHeight) : (anchorConvertedFrame.origin.y)
        let anchorBottomSpace = keyboardMode ? 0 : (screenHeight - (anchorConvertedFrame.origin.y + anchorHeight))
        isDirectionUp = anchorTopSpace > anchorBottomSpace
        
        // calculate
        var calHeight = max(anchorTopSpace, anchorBottomSpace) - padding * 2
        calHeight = min(calHeight, totalHeight)
        var calY = isDirectionUp ? max((anchorTopSpace - calHeight) - padding, padding) : (anchorTopSpace + anchorHeight + padding)
        
        // KEYBOARD MODE
        // If anchorView is TextField -> ExpandView (self) must move above the textfield
        // Else anchor is other type -> have search field inside -> just above the keyboard
        if keyboardMode, isDirectionUp  && anchorView is UITextField {
            if calHeight > anchorTopSpace - anchorView.frame.height - 10 {
                calHeight = calHeight - (anchorView.frame.height + 10)
            } else {
                calY = calY - (anchorView.frame.height + 10)
            }
        }
        
        // frame
        originFrame = CGRect(x: anchorConvertedFrame.origin.x, y: calY, width: anchorWidth * ratio, height: calHeight)
        
        // Check search field
        let searchY = isDirectionUp ? (calHeight - optionHeight) : 0
        tfSearch?.frame = CGRect(x: 0, y: searchY, width: anchorWidth * ratio, height: optionHeight)

        // Body frame
        let bodyY = isDirectionUp ? 0 : (searchable ? optionHeight : 0)
        let bodyHeight = searchable ? (calHeight - optionHeight) : calHeight

        scrollBody.frame = CGRect(x: 0, y: bodyY, width: anchorWidth * ratio, height: bodyHeight)
        scrollBody.contentSize = CGSize(width: anchorWidth * ratio, height: contentHeight)
        scrollBody.layer.cornerRadius = 10.0
        self.addSubview(scrollBody)
        
        // Animation show
        performAnimationToCurrentPosition()
        return true
    }
    
    private func createSearchField(searchable: Bool) {
        self.searchable = searchable
        if searchable && tfSearch != nil { // already have search field -> no need create any more
            return
        }
        tfSearch?.removeFromSuperview()
        tfSearch = nil
        guard searchable else { return }
        tfSearch = UITextField(frame: CGRect.zero) //(x: 0, y: 0, width: anchorConvertedFrame.size.width, height: optionHeight))
        tfSearch?.backgroundColor = optionBackgroundColor
        tfSearch?.textColor = colorTextSeach
        tfSearch?.addTarget(self, action: #selector(searchDataInCombobox), for: .editingChanged)
        self.addSubview(tfSearch!)
        tfSearch?.delegate = self
    }
    
    func performAnimationToCurrentPosition() {
        guard let originFrame = originFrame else {
            return
        }
        self.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = originFrame
            self.alpha = 1
        })
    }
    
    func show(searchable: Bool = false) {
        guard calculatePositionAndMove(searchable: searchable) else {
            return
        }
            // Search field
            self.isHidden = false
            
            // Apply selection style for selected indexs
            self.applySelection()
            
            //         showInWindow(content: background)
            self.showInController()
            
            // Animate show
            NotificationCenter.default.addObserver(self, selector: #selector(self.moveExpandViewTopCombobox), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.onKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)

    }
    
    private func makeBackgroundSelectable() -> UIView {
        // Add bg cover
        let frame = CGRect(x: 0, y: 0, width: Global.screenSize.width, height: Global.screenSize.height)
        let background = UIView(frame: frame)
        background.backgroundColor = .clear
        background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(outsideClick)))
        background.addSubview(self)
        return background
    }
    
    private func showInWindow() {
        let bg = makeBackgroundSelectable()
        UIApplication.shared.keyWindow?.addSubview(bg)
    }
    
    private func showInController() {
        let bg = makeBackgroundSelectable()
        let controller = ExpandViewController()
        controller.show(dropdown: bg)
    }
    
    func hide(){
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.alpha = 0
        },completion: { finished in
            self.delegate = nil
            self.isHidden = true
            if self.superview?.superview == UIApplication.shared.keyWindow {
                self.superview?.removeFromSuperview()
            }
            else {
                UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        })
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}


// MARK: - Text field delegate
extension ExpandView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}








