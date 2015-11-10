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
    
    /// 将emoticon表情转换成属性文本
    func emoticonToAttrString(font: UIFont) -> NSAttributedString {
        
        // 创建附件
        let attachment = JFTextAttachment()
        
        // 创建 image
        let image = UIImage(contentsOfFile: bundlePath)
        
        // 将 image 添加到附件
        attachment.image = image
        
        // 将表情图片的名称赋值
        attachment.name = chs
        
        // 获取font的高度
        let height = font.lineHeight ?? 10
        
        // 设置附件大小
        attachment.bounds = CGRect(x: 0, y: -(height * 0.25), width: height, height: height)
        
        // 创建属性文本
        let attrString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        
        // 发现在表情图片后面在添加表情会很小.原因是前面的这个表请缺少font属性
        // 给属性文本(附件) 添加 font属性
        attrString.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: 1))
        
        return attrString
    }
    
    /// 根据字符串找到对应的表情模型
    class func stringToEmoticon(string: String) -> JFEmoticon? {
        
        var emoticon: JFEmoticon? = nil
        
        for package in JFEmotionPackage.packages {
            
            emoticon = package.emoticons?.filter({ (e1) -> Bool in
                return e1.chs == string
            }).last
            
            // 一定要记得加上这句不然很可能被后面的覆盖
            if emoticon != nil {
                break
            }
        }
        
        return emoticon
    }
    
    /**
     带表情字符串的文本转换成带表情图片的属性文本
     - parameter string: 带表情字符串的文本
     - returns: 带表情图片的属性文本
     */
    class func stringToEmoticonString(string: String, font: UIFont) -> NSAttributedString {
        
        // 获取文本中的表情字符串
        
        // 定义匹配方案
        let pattern = "\\[.*?\\]"
        
        // 创建正则表达式对象
        let regular = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        // 匹配所有符合条件的内容
        let result = regular.matchesInString(string, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: string.characters.count))
        
        // 定义属性字符串
        let emoticonString = NSMutableAttributedString(string: string)
        
        // 遍历匹配结果
        var count = result.count
        
        // 从后面往前面遍历
        while count > 0 {
            
            // 获取匹配结果的第一个匹配项
            let range = result[--count].rangeAtIndex(0)
            
            // 截取表情字符串
            let emoticonStr = (string as NSString).substringWithRange(range)
            
            // 字符串转表情模型
            if let emoticon = JFEmoticon.stringToEmoticon(emoticonStr) {
                
                // 表情模型转带表情图片的属性文本
                let emoticonAttr = emoticon.emoticonToAttrString(font)
                
                // 表情字符串替换为带表情图片的属性文本
                emoticonString.replaceCharactersInRange(range, withAttributedString: emoticonAttr)
            }
        }
        
        return emoticonString
    }
    
    // 调试打印
    override var description: String {
        return "\n\t\tchs:\(chs),png:\(png),code:\(code)"
    }
    
    
}
