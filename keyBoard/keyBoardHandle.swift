//
//  keyBoardHandle.swift
//  keyBoard
//
//  Created by nick on 2016/12/15.
//  Copyright © 2016年 nick. All rights reserved.
//
// https://github.com/nick6969/keyBoard

import UIKit

let ChlKeyBoardHandle = keyBoardHandle()

final class keyBoardHandle{
    
    fileprivate var _enable = true

    // 是否啟用鍵盤管理
    var isEnable : Bool {
        get {
            return _enable
        }
        set{
            _enable = newValue
            if newValue{
                NotificationCenter.default.removeObserver(self)
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            }else{
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    
    fileprivate init(){}
    
    /// 鍵盤彈出事件處理
    ///
    /// - Parameter noti: NSNotification
    @objc func keyboardWillShow(noti: Notification) {
        // 第一件事 取得鍵盤的高度以及動畫時間
        // 第二件事 找出誰是 FirstResponder
        // 第三件事 根據鍵盤高度 跟 FirstResponder 的位置 調整畫面
        guard let keyboardHeight = (noti.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        guard let duration = (noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue) as? TimeInterval else {
            return
        }
        guard let animationOptions = (noti.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue else {
            return
        }
        guard let top = topVC() else{
            return
        }
        
        let space : CGFloat = 30.0
        let screenHeight = top.view.frame.height
        let options = UIViewAnimationOptions.init(rawValue: UInt(animationOptions<<16))
        
        if top is UIAlertController{
            // 不處理 因為該 UIAlertController 自己有處理了
        }else{
            if let first = UIResponder.firstResponder() as? UIView {
                let rect = first.convert(CGPoint(x:0,y:first.frame.height), to: top.view).y
                let offsetX = rect + keyboardHeight - screenHeight + space
                if offsetX > 0 {
                    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                        () -> Void in
                        top.view.frame = CGRect(x: 0.0, y: -offsetX, width: top.view.frame.width, height: top.view.frame.height)
                    }, completion: nil)
                }else{
                    UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                        () -> Void in
                        top.view.frame = CGRect(x: 0, y: 0, width: top.view.frame.width, height: top.view.frame.height)
                    }, completion: nil)
                }
            }
        }
    }
    
    /// 鍵盤收起事件處理
    ///
    /// - Parameter noti: NSNotification
    @objc func keyboardWillHide(noti: Notification) {
        // 第一件事 取得鍵盤關閉的動畫時間
        // 第二件事 將螢幕調回原本的位置 使用鍵盤關閉的動畫時間
        guard let duration = (noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue) as? TimeInterval else {
            return
        }
        guard let animationOptions = (noti.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue else {
            return
        }
        guard let top = topVC() else{
            return
        }
        let options = UIViewAnimationOptions.init(rawValue: UInt(animationOptions<<16))
        
        if top is UIAlertController{
            // 不處理 因為該 UIAlertController 自己有處理了
        }else{
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                () -> Void in
                top.view.frame = CGRect(x: 0, y: 0, width: top.view.frame.width, height: top.view.frame.height)
            }, completion: nil)
        }
    }
    
    
    // TopVC 取得
    fileprivate func topVC()->UIViewController?{
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        
        return Recurrence(topViewController)
    }
    
    fileprivate func Recurrence(_ vc:UIViewController?)->UIViewController?{
        var vcc = vc
        while let presentedViewController = vcc?.presentedViewController {
            vcc = presentedViewController
        }
        if vcc is UITabBarController {
            return Recurrence((vcc as! UITabBarController).selectedViewController)
        }else if vcc is UINavigationController {
            return Recurrence((vcc as! UINavigationController).viewControllers.last)
        }else{
            return vcc
        }
    }
    
}

// MARK: - Extension UIRespinder
extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder? = nil
    
    public class func firstResponder() -> UIResponder? {
        UIResponder._currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return UIResponder._currentFirstResponder
    }
    
    internal func findFirstResponder(sender: AnyObject) {
        UIResponder._currentFirstResponder = self
    }
}
