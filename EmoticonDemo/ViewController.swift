//
//  ViewController.swift
//  EmoticonDemo
//
//  Created by 秦－政 on 2016/11/26.
//  Copyright © 2016年 pete. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textFielf: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func emotionKeyBoard(_ sender: Any) {
        textFielf.inputView = emoticonKeyBoard
        textFielf.becomeFirstResponder()
        textFielf.reloadInputViews()
    }
    @IBAction func commenKeyBoard(_ sender: Any) {
        textFielf.autocorrectionType = .no
        textFielf.inputView = nil
        textFielf.becomeFirstResponder()
        textFielf.reloadInputViews()
        
    }
    
    // 表情键盘
    fileprivate lazy var emoticonKeyBoard: SLEmoticonKeyBoard = {
        let keybard = SLEmoticonKeyBoard()
        //  设置自定义键盘的大小
        keybard.size = CGSize(width: self.view.width, height: 216)
        return keybard
    }()


}

