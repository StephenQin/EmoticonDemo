//
//  SLEmoticonTools.swift
//  langligelang
//
//  Created by 秦－政 on 2016/11/3.
//  Copyright © 2016年 pete. All rights reserved.
//

import UIKit
import YYModel
//  每页上有20个表情
let NumberOfPage = 20
//  归档和接档路径
let RecentEmoticonPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("recentEmoticonArray.archive") // 最后的名字随便写
class SLEmoticonTools: NSObject {
    
    // 单例全局访问点
    static let shareTool: SLEmoticonTools = SLEmoticonTools()
    // 构造函数私有化
    private override init() {
        super.init()
    }
    // 获取默认表情
    private lazy var defaultEmoticonArray: [SLEmoticon] = {
        return self.loadEmoticonArray(folderName: "default", fileName: "info.plist")
    }()
    // 获取emoji表情
    private lazy var emojiEmoticonArray:[SLEmoticon] = {
        return self.loadEmoticonArray(folderName: "emoji",fileName: "info.plist")
    }()
    // 获取小浪花表情
    private lazy var lxhEmoticonArray:[SLEmoticon] = {
        return self.loadEmoticonArray(folderName: "lxh",fileName: "info.plist")
    }()
    // 获取最近表情
    private lazy var recentEmoticonArray: [SLEmoticon] = {
        if let localArray = self.loadRecentEmoitcon() {

            // 表示有数据 返回数据
            return localArray
            
        } else {
            // 没有数据就返回空数组
            let emoticonArray = [SLEmoticon]()
            return emoticonArray
        }
        
    }()
    // 准备表情视图所需要的数据
    lazy var allEmoticonArray:[[[SLEmoticon]]] = {
        return[
            // 最近表情数据
            [self.recentEmoticonArray],
            // 默认表情数据
            self.sectionEmoticonsArray(emotions:self.defaultEmoticonArray),
            // emoji表情数据
            self.sectionEmoticonsArray(emotions:self.emojiEmoticonArray),
            // 浪小花表情数据
            self.sectionEmoticonsArray(emotions:self.lxhEmoticonArray)
        ]
    }()
    //  创建 Emoticons bundle 对象
    lazy var emoticonsBundle: Bundle = {
        // 获取表情 bundle 文件路径
        let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)!
        // 根据路径创建bundle
        let bundle = Bundle(path: path)!
        
        return bundle
    }()
    //  根据文件夹和文件名获取对应的表情数据
    private func loadEmoticonArray(folderName: String, fileName: String) -> [SLEmoticon] {
        // 子路径拼接
        let subPath = folderName + "/" + fileName
        // 使用path(forResource:xx) 会透过两层文件夹(Contents/Resources)
        let path = self.emoticonsBundle.path(forResource: subPath, ofType: nil)!
        // 加载plis文件 -> 返回数组字典
        let dicArray = NSArray(contentsOfFile: path)!
        // 通过YYModel把数组字典转成模型
        let modelArray = NSArray.yy_modelArray(with: SLEmoticon.self, json: dicArray) as! [SLEmoticon]
        // 遍历表情模型数组判断是否是图片表情
        for model in modelArray {
//            print(model.type,model.code,model.png)
            if model.type == "0" {
                // 表示图片，需要拼接路径
                let path = self.emoticonsBundle.path(forResource: folderName, ofType: nil)! + "/" + model.png!
                // 图片全路径
                model.fullPath = path
                // 保存图片对应的文件夹
                model.folderName = folderName
            }
        }
        return modelArray
    }
    //  把表情数据拆分二维数组
    private func sectionEmoticonsArray(emotions: [SLEmoticon]) -> [[SLEmoticon]] {
        
        // 根据传入的表情数组的个数计算显示的页数
        let pageCount = (emotions.count - 1) / NumberOfPage + 1
        // 创建二维数组
        var tempArray = [[SLEmoticon]]()
        // 遍历页数，获取对应的表情数据
        for i in 0..<pageCount {
            // 开始截取的索引
            let loc = i * NumberOfPage
            var len = NumberOfPage
            if loc + len > emotions.count {
                // 表示超出范围,截取剩余的个数
                len = emotions.count - loc
            }
            // 截取子数组
            let subArray = (emotions as NSArray).subarray(with: NSMakeRange(loc, len)) as! [SLEmoticon]
            tempArray.append(subArray)
        }
        return tempArray
    }
    
    //  读取本地最近表情数据
    func loadRecentEmoitcon() -> [SLEmoticon]? {
        
        //  完成解档
        let array = NSKeyedUnarchiver.unarchiveObject(withFile: RecentEmoticonPath) as? [SLEmoticon]
//        print(array)
        return array
    }

    // 添加最近表情数据
    func saveRecentEmoticon(emoticon: SLEmoticon) {
        
        // 判断最近表情里面是否存在传入的表模型
        for (i, etn) in recentEmoticonArray.enumerated() {
            
            // 如果是图片，那么判断chs
            if etn.type == "0" {
                // 判断表情描述是否相同
                if emoticon.chs == etn.chs {
                    // 删除表情
                    recentEmoticonArray.remove(at: i)
                    break
                }
            } else {
                // 不是图片表情 判断code是否相同
                if emoticon.code == etn.code {
                    recentEmoticonArray.remove(at: i)
                    break
                }
            }
        }
        //  插入到第一个元素位置
        recentEmoticonArray.insert(emoticon, at: 0)
        // 超出20个表情以后把最后一个表情元素删除
        while recentEmoticonArray.count > 20 {
            // 删除最后一个元素
            recentEmoticonArray.removeLast()
        }
        // 修改数据源
        allEmoticonArray[0][0] = recentEmoticonArray
        //  归档最近表情
        NSKeyedArchiver.archiveRootObject(recentEmoticonArray, toFile: RecentEmoticonPath)
        
//        print(recentEmoticonArray)
    }
    // 根据表情描述获取表情模型
    func selectEmoticonWithChs(chs: String) -> SLEmoticon? {
        //  查找表情模型只需要在默认表情和浪小花表情里面去找可以了,原因只有这两组数据才有表情描述
        
        for emoticon in defaultEmoticonArray {
            if emoticon.chs == chs {
                //  找到了对应的表情模型
                return emoticon
            }
        }
        for emoticon in  lxhEmoticonArray {
            if emoticon.chs == chs {
                //  找到了对应的表情模型
                return emoticon
            }            
        }
        //  表示找不到对应的表情模型
        return nil
    }
}
