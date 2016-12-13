//
//  AppDelegate.swift
//  keyBoard
//
//  Created by nick on 2016/12/12.
//  Copyright © 2016年 nick. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        keyBoardHandleStart() // 開始鍵盤事件 監聽處理
        
        return true
    }

}


// MARK: - 鍵盤事件處理
extension AppDelegate{
    
    /// 開始鍵盤事件監聽
    func keyBoardHandleStart(){
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.keyboardWillShow(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.keyboardWillHide(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    /// 鍵盤彈出事件處理
    ///
    /// - Parameter noti: NSNotification
    func keyboardWillShow(noti: Notification) {
        // 第一件事 取得鍵盤的高度以及動畫時間
        // 第二件事 找出誰是 FirstResponder
        // 第三件事 根據鍵盤高度 跟 FirstResponder 的位置 調整畫面
        guard let keyboardHeight = (noti.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height else {
            return
        }
        guard let duration = (noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue) as? TimeInterval else {
            return
        }
        
        guard let top = UIApplication.shared.topViewController else{
            return
        }
        let space : CGFloat = 30.0
        let screenHeight = top.view.frame.height
        
        if top is UIAlertController{
            // 不處理 因為該 UIAlertController 自己有處理了
        }else{
            if let first = UIResponder.firstResponder() as? UIView {
                let rect = first.convert(CGPoint(x:0,y:first.frame.height), to: top.view).y
                let offsetX = rect + keyboardHeight - screenHeight + space
                if offsetX > 0 {
                    UIView.animate(withDuration: duration )
                    { () -> Void in
                        top.view.frame = CGRect(x: 0.0, y: -offsetX, width: top.view.frame.width, height: top.view.frame.height)
                    }
                }else{
                    UIView.animate(withDuration: duration )
                    { () -> Void in
                        top.view.frame = CGRect(x: 0, y: 0, width: top.view.frame.width, height: top.view.frame.height)
                    }
                }
            }
        }
    }
    
    /// 鍵盤收起事件處理
    ///
    /// - Parameter noti: NSNotification
    func keyboardWillHide(noti: Notification) {
        // 第一件事 取得鍵盤關閉的動畫時間
        // 第二件事 將螢幕調回原本的位置 使用鍵盤關閉的動畫時間
        guard let duration = (noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSValue) as? TimeInterval else {
            return
        }
        guard let top = UIApplication.shared.topViewController else{
            return
        }
        if top is UIAlertController{
            // 不處理 因為該 UIAlertController 自己有處理了
        }else{
            UIView.animate(withDuration: duration )
            { () -> Void in
                top.view.frame = CGRect(x: 0, y: 0, width: top.view.frame.width, height: top.view.frame.height)
            }
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


extension UIApplication {
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
}














