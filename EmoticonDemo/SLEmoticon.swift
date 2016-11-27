//
//  SLEmoticon.swift
//  langligelang
//
//  Created by 秦－政 on 2016/11/3.
//  Copyright © 2016年 pete. All rights reserved.
//

import UIKit

class SLEmoticon: NSObject,NSCoding {
    //  表情描述 -> 以后发给新浪微博需要发送这个字段
    var chs: String?
    //  表情图片名称
    var png: String?
    //  表情类型 -> 0: 表示图片表情, 1: 表示emoji 表情
    var type: String?
    //  16进制字符串 -> 转成 emoji 表情显示
    var code: String?
    //  图片全路径
    var fullPath: String?
    //  保存图片对应的文件夹
    var folderName: String?
    //  重写默认的构造函数
    override init() {
        super.init()
    }
    
    // MARK: - 归档和解档
    //  归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(chs, forKey: "chs")
        aCoder.encode(png, forKey: "png")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(code, forKey: "code")
        aCoder.encode(fullPath, forKey: "fullPath")
        aCoder.encode(folderName, forKey: "folderName")
    }
    //  解档
    required init?(coder aDecoder: NSCoder) {
        chs = aDecoder.decodeObject(forKey: "chs") as? String
        png = aDecoder.decodeObject(forKey: "png") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        code = aDecoder.decodeObject(forKey: "code") as? String
        fullPath = aDecoder.decodeObject(forKey: "fullPath") as? String
        folderName = aDecoder.decodeObject(forKey: "folderName") as? String
        if type == "0" {
            //  如果是图片表情,那么重新修改图片全路径
            let path = SLEmoticonTools.shareTool.emoticonsBundle.path(forResource: folderName, ofType: nil)! + "/" + png!
            //  设置全路径
            fullPath = path
        }
    }
}
