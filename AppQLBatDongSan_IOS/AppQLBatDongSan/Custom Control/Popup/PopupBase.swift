//
//  PopupBase.swift
//  ConnectPOS
//
//  Created by Black on 10/8/17.
//  Copyright © 2017 SmartOSC Corp. All rights reserved.
//

import UIKit

enum PopupPosition {
    case center
    case top
    case custom // Notice
}

class PopupBase: UIView {
    
    let maxWidth = Global.screenSize.width - MyUI.padding * 2
    let maxHeight = Global.screenSize.height - MyUI.padding * 2
    let minWidth : CGFloat = 200
    let minHeight : CGFloat = 60
    // Updated size of popup
    var calculatedSize : CGSize = CGSize(width: 0, height: 0)
    // Event -> For case has overlay -> Call this to close overlay view
    var onClose : (() -> Void)?
    
    private(set) var animatingShow: Bool = false
    
    // MARK: Show/Hide
    func close() {
        if onClose == nil {
            hide()
        }
        else{
            onClose?()
        }
    }
    
    public func show(position: PopupPosition, overlay: Bool = false, completion: ((Bool) -> Void)? = nil){
        showIn(view: nil, position: position, overlay: overlay, completion: completion)
    }
    
    public func show(view: UIView? = nil, position: PopupPosition = .center, overlay: Bool = false, completion: ((Bool) -> Void)? = nil) {
        showIn(view: view, overlay: overlay, completion: completion)
    }
    
    private func showIn(view: UIView?, position: PopupPosition = .center, overlay: Bool = false, completion: ((Bool) -> Void)? = nil) {
        guard let view = view ?? Global.appDelegate.window else { return }
        // Calculate frame
        let x = (Global.screenSize.width - calculatedSize.width)/2
        var y = MyUI.padding
        if position == .center {
            y = (Global.screenSize.height - calculatedSize.height)/2
        }
        else if position == .custom {
            y = customConstraintTop()
        }
        self.frame = CGRect(origin: CGPoint(x: x, y: y), size: calculatedSize)
        // Add to super
        if overlay {
            let bg = UIView(frame: CGRect(x: 0, y: 0, width: Global.screenSize.width, height: Global.screenSize.height))
            bg.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            view.addSubview(bg)
            bg.addSubview(self)
            self.onClose = {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                    bg.backgroundColor = UIColor.clear
                }, completion: nil)
                self.hide(completion: {done in
                    bg.removeFromSuperview()
                })
                self.onClose = nil
            }
        }
        else{
            view.addSubview(self)
        }
        // Animation
        animatingShow = true
        self.alpha = 0.0
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.alpha = 1.0
        }, completion: {[weak self] finish in
            completion?(finish)
            self?.animatingShow = false
            self?.afterShown()
        })
    }
    
    // For override only
    func afterShown() {
        // Override only
    }
    
    func customConstraintTop() -> CGFloat {
        // For popup type custom
        return MyUI.padding
    }
    
    public func hide(completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        self.alpha = 1.0
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            self.removeFromSuperview()
            completion(finished)
        })
    }
    
}
