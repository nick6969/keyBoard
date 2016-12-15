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

         ChlKayBoardHandle.Start() // 開始鍵盤事件 監聽處理
        
        return true
    }

}







