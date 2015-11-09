//
//  JFEmoticonPackage.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/4.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

// 获取Emoticons.bundle文件夹的路径
let bundlePath = NSBundle.mainBundle().pathForResource("Emoticons.bundle", ofType: nil)!

// MARK: - 表情包模型
class JFEmotionPackage: NSObject {
    
    // MARK: - 属性
    // 表情包文件夹名称
    var id: String
    
    // 表情包名称
    var group_name_cn: String?
    
    // 表情模型数组
    var emoticons: [JFEmoticon]?
    
    // MARK: - 构造方法
    init(id: String) {
        self.id = id
    }
    
    // 表情包持久化
    static let packages = JFEmotionPackage.loadEmoticonPackages()
    
    /**
     加载所有表情包
     - returns: 返回表情包数组
     */
    class func loadEmoticonPackages() -> [JFEmotionPackage] {
        
        // 获取emoticons.plist文件的路径
        let emoticonsPlistPath = bundlePath + "/emoticons.plist"
        
        // 获取表情包字典
        let packagesArray = NSDictionary(contentsOfFile: emoticonsPlistPath)!["packages"] as! [[String : AnyObject]]
        
        // 创建表情包数组
        var packages = [JFEmotionPackage]()
        
        // 创建最近表情包
        let recent = JFEmotionPackage(id: "")
        packages.append(recent)
        recent.group_name_cn = "最近"
        
        // 追加空表情和删除按钮
        recent.appendEmptyEmoticon()
        
        // 加载所有表情包
        for dict in packagesArray {
            
            let id = dict["id"] as! String
            packages.append(JFEmotionPackage(id: id).loadEmoticons())
            
        }
        
        return packages
    }
    
    /**
     加载表情包里所有表情模型和表情包名称
     */
    func loadEmoticons() -> Self {
        
        // 获取info.plist路径
        let infoPlistPath = "\(bundlePath)/\(id)/info.plist"
        
        // 取出表情包数据
        let emoticonDict = NSDictionary(contentsOfFile: infoPlistPath)!
        group_name_cn = emoticonDict["group_name_cn"] as? String
        let emoticonArray = emoticonDict["emoticons"] as! [[String : String]]
        
        // 创建表情模型数组
        emoticons = [JFEmoticon]()
        
        var index = 0
        
        // 遍历添加表情模型
        for dict in emoticonArray {
            
            // 表情字典转模型，添加到表情模型数组里
            emoticons?.append(JFEmoticon(id: id, dict: dict))
            
            // 重置
            index++
            
            if index == 20 {
                // 每页最后一个位置添加删除按钮
                emoticons?.append(JFEmoticon(removeEmoticon: true))
                index = 0
            }
            
        }
        
        // 当表情加载完成的时候判断是否正好满一页,不满一页的添加空白按钮,并在最后位置添加删除按钮
        appendEmptyEmoticon()
        
        return self
    }
    
    /// 当表情加载完成的时候判断是否正好满一页,不满一页的添加空白按钮,并在最后位置添加删除按钮
    private func appendEmptyEmoticon() {
        
        // 最近表情包没有表情
        if emoticons == nil {
            emoticons = [JFEmoticon]()
        }
        
        // 获取到最后一页的个数
        let count = emoticons!.count % 21

        if count > 0 || emoticons!.count == 0 {
            // 追加空白按钮
            for _ in count..<20 {
                emoticons?.append(JFEmoticon(removeEmoticon: false))
            }
            
            // 追加删除按钮
            emoticons?.append(JFEmoticon(removeEmoticon: true))
        }
    }
    
    /// 添加最近使用表情
    class func addFavorate(emoticon: JFEmoticon) {
        
        // 删除按钮不添加到最近表情
        if emoticon.removeEmoticon {
            return
        }
        
        // 使用次数加1
        emoticon.times++
        
        // 获取到最近表情包里面的表情模型数组
        var recentEmoticonPackage = packages[0].emoticons!
        
        // 移除 删除按钮
        let removeEmoticon = recentEmoticonPackage.removeLast()
        
        // 如果最近表情包已经存在,不需要添加
        let contains = recentEmoticonPackage.contains(emoticon)
        if !contains {
            // 向最近表情包添加表情
            recentEmoticonPackage.append(emoticon)
        }
        
        // 排序
        recentEmoticonPackage = recentEmoticonPackage.sort({ (e1, e2) -> Bool in
            return e1.times > e2.times
        })
        
        // 保证 最近 只有 21个按钮,最后一个是删除按钮
        if !contains {
            recentEmoticonPackage.removeLast()
        }
        
        // 添加 删除按钮
        recentEmoticonPackage.append(removeEmoticon)
        
        // 重新赋值回去
        packages[0].emoticons = recentEmoticonPackage
        
//        print("最近表情: \(packages[0].emoticons)")
        
    }
    
    
    // 调试打印
    override var description: String {
        return "\n\tid:\(id),group_name_cn:\(group_name_cn),emoticons:\(emoticons)"
    }
    
}
