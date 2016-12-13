//
//  ViewController.swift
//  keyBoard
//
//  Created by nick on 2016/12/12.
//  Copyright © 2016年 nick. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    @IBAction func showAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: "測試", message: "鍵盤會不會處理的正確呢", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = "這是一場奇怪的測試"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    

}

extension UIViewController{
    // MARK : - Touch
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

