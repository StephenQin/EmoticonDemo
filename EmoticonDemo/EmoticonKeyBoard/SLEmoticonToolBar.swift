//
//  SLEmoticonToolBar.swift
//  langligelang
//
//  Created by 秦－政 on 2016/11/2.
//  Copyright © 2016年 pete. All rights reserved.
//

import UIKit
enum SLEmoticonToolBarButtonType: Int {
    //  最近表情
    case recent = 1000
    //  默认表情
    case normal = 1001
    //  emoji
    case emoji = 1002
    //  浪小花
    case lxh = 1003
}
class SLEmoticonToolBar: UIStackView {
    // 记录上一次选中的按钮
    var lastSelectedButton: UIButton?
    // 点击toolbar 执行闭包
    var callBack: ((SLEmoticonToolBarButtonType)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI() {
        
        //  设置布局方式
        axis = .horizontal
        //  设置子控件填充方式
        distribution = .fillEqually
        
        addChildButton(imageName: "compose_emotion_table_left", title: "最近", type:.recent)
        addChildButton(imageName: "compose_emotion_table_mid", title: "默认",type:.normal)
        addChildButton(imageName: "compose_emotion_table_mid", title: "Emoji",type:.emoji)
        addChildButton(imageName: "compose_emotion_table_right", title: "浪小花",type:.lxh)
        
    }
    //  添加子按钮操作
    private func addChildButton(imageName: String, title: String, type: SLEmoticonToolBarButtonType) {
        
        let button = UIButton()
        button.tag = type.rawValue
        //  添加点击事件
        button.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside)
        // 设置不同状态下的背景图片
        button.setBackgroundImage(UIImage(named: imageName + "_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named: imageName + "_selected"), for: .selected)
        
        //  设置不同状态下的文字颜色
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .selected)
        
        //  设置字体大小
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(title, for: .normal)
        
        //  取消高亮效果
        button.adjustsImageWhenHighlighted = false
        
        addArrangedSubview(button)
        if type == .normal {
            lastSelectedButton?.isSelected = false
            button.isSelected = true
            lastSelectedButton = button
        }
        
    }
    // MARK: - 点击事件处理
    @objc private func buttonAction(btn: UIButton) {
        // 如果点击的同一个按键 不执行任何操作立即返回
        if lastSelectedButton == btn{
            return
        }
        //  上一次选中的按钮选中状态改成 false
        lastSelectedButton?.isSelected = false
        //  当前点击按钮的选中状态改成 true
        btn.isSelected = true
        //  记录当前选中的按钮
        lastSelectedButton = btn
        // 通过tag获取当前的枚举
        let type = SLEmoticonToolBarButtonType(rawValue: btn.tag)!
        // 执行响应的闭包
        callBack?(type)
    }
    func selectedButtonWithSection(section: Int)  {
        //  以后设置 tag 的时候尽量不用从0开始,否则取值的时候去的不是这个空间,而是当前对象自己
        let button = viewWithTag(section + 1000) as! UIButton
        if lastSelectedButton == button {
            return
        }
        lastSelectedButton?.isSelected = false
        button.isSelected = true
        lastSelectedButton = button
    }    
}

















