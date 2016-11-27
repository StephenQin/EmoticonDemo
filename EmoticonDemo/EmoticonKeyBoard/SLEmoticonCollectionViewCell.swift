//
//  SLEmoticonCollectionViewCell.swift
//  langligelang
//
//  Created by 秦－政 on 2016/11/3.
//  Copyright © 2016年 pete. All rights reserved.
//

import UIKit
// 自定义cell
class SLEmoticonCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupUI(){
        // 添加控件
        addChildButtom()
        addSubview(deleteEmoticonButton)
    }
    // 添加表情按钮
    private func addChildButtom() {
        for _ in 0..<20 {
            let btn = SLEmoticonButton()
            // 添加点击事件
            btn.addTarget(self, action: #selector(emoticonButtonAction(btn:)), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 33)
//            btn.backgroundColor = SLRandomColor()
            contentView.addSubview(btn) // 添加到contentView
            emoticonButtonArray.append(btn) // 添加到emoticonButtonArray数组
        }
    }
    // 点击表情事件处理
    @objc fileprivate func emoticonButtonAction(btn:SLEmoticonButton) {
        // 获取按钮对应的表情模型
//        let emoticon = btn.emoticon!
        // 发送点击表情按钮的通知
//        NotificationCenter.default.post(name: NSNotification.Name(DidSelectedEmoticonButtonNotification), object: emoticon)
    }
    // MARK: - 点击删除表情按钮逻辑处理
    @objc private func deleteEmoticonButtonAction() {
        //  执行删除表情内容的操作
//        NotificationCenter.default.post(name: NSNotification.Name(DidSelectedDeleteEmotionButtonNotification), object: nil)
    }
    // 布局表情按钮位置
    override func layoutSubviews() {
        super.layoutSubviews()
        // 计算表情按钮的宽度
        let btnW = width / 7
        let btnH = height / 3
        // 设置表情的 frame
        for (i,btn) in emoticonButtonArray.enumerated() {
            // 计算列的索引
            let colIndex = i % 7
            // 计算行数
            let rowIndex = i / 7
            // 设置x，y坐标
            btn.x = CGFloat(colIndex) * btnW
            btn.y = CGFloat(rowIndex) * btnH
            // 设置大小
            btn.size = CGSize(width: btnW, height: btnH)
        }
        //  设置删除按钮的大小
        deleteEmoticonButton.size = CGSize(width: btnW, height: btnH)
        //  设置 x,y 坐标
        deleteEmoticonButton.x = width - btnW
        deleteEmoticonButton.y = height - btnH
    }
    // 属性
    var emoticonArray:[SLEmoticon]? {
        didSet {
            // 设置数据的时候绑定表情按钮的数据
            guard let etnArray = emoticonArray else {
                return
            }
            // 先把表情全部隐藏，在绑定数据的时候在设置显示
            for btn in emoticonButtonArray {
                btn.isHidden = true
            }
            for (i,emoticon) in etnArray.enumerated() {
                // 根据下标获取对应的表情按键
                let emoticonButton = emoticonButtonArray[i]
                // 给按键绑定表情模型
                emoticonButton.emoticon = emoticon
                // 显示按键
                emoticonButton.isHidden = false
                // 判断表情数组内的类型
                if emoticon.type == "0" {
                    // 表示图片
                    emoticonButton.setImage(UIImage(named: emoticon.fullPath!), for: .normal)
                    emoticonButton.setTitle(nil, for: .normal)
                } else {
                    // 表示 emoji
                    emoticonButton.setTitle((emoticon.code! as NSString).emoji(), for: .normal)
                    emoticonButton.setImage(nil, for: .normal)
                }
            }
        }
    }

    fileprivate lazy var emoticonButtonArray: [SLEmoticonButton] = [SLEmoticonButton]()
     //  删除表情按钮
    fileprivate lazy var deleteEmoticonButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(deleteEmoticonButtonAction), for: .touchUpInside)
        button.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
        button.setImage(UIImage(named: "compose_emotion_delete_highlighted"), for: .highlighted)
        return button
        
    }()

}
