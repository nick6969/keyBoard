//
//  CViewController.swift
//  keyBoard
//
//  Created by nick on 2016/12/14.
//  Copyright © 2016年 nick. All rights reserved.
//

import UIKit

class CViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // 不要使用的鍵盤管理的介面 在viewWillAppear 關閉觀盤管理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ChlKeyBoardHandle.isEnable = false
    }
    
    // 不要使用的鍵盤管理的介面 在viewWillDisappear 重新打開觀盤管理
    override func viewWillDisappear(_ animated: Bool) {
        ChlKeyBoardHandle.isEnable = true
    }
    
}
