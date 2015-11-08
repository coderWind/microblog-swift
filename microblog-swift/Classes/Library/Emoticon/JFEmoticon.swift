//
//  JFEmoticon.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/4.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

// MARK: - 表情模型
class JFEmoticon: NSObject {
    
    // MARK: - 属性
    /// 使用次数
    var times = 0
    
    /// 是否是删除按钮, true表示删除按钮
    var removeEmoticon: Bool = false
    
    // 表情包文件夹名称
    var id: String?
    
    // 表情名称，用于网络传输 如：[笑哈哈]
    var chs: String?
    
    /// 表情路径
    var pngPath: String?
    
    // 表情图片名称，用于表情键盘上显示
    var png: String? {
        didSet {
            
            // 如果png没有值则pngPath也置空
            if png == nil {
                pngPath = nil
            }
            
            // 拼接png图片完整路径
            pngPath = bundlePath + "/" + id! + "/" + png!
        }
    }
    
    // emoji字符串
    var emoji: String?

    // emoji 16进制表情字符串
    var code: String? {
        didSet {
            
            // 将 code 转成 emoji字符串
            let scanner = NSScanner(string: code!)
            var result: UInt32 = 0
            scanner.scanHexInt(&result)
            
            emoji = "\(Character(UnicodeScalar(result)))"
        }
    }
    
    // MARK: - 字典转模型
    init(id: String?, dict: [String : AnyObject]) {
        super.init()
        
        self.id = id
        // kvc为模型属性赋值
        setValuesForKeysWithDictionary(dict)
    }
    
    /// 构造方法 removeEmoticon = true 表示删除按钮, false表示空白按钮
    init(removeEmoticon: Bool) {
        super.init()
        
        self.removeEmoticon = removeEmoticon
    }
    
    // 字典中的key在模型中找不到对应的属性时调用
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // 调试打印
    override var description: String {
        return "\n\t\tchs:\(chs),png:\(png),code:\(code)"
    }
    
    
}
