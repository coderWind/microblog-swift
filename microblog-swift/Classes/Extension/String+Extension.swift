//
//  String+Extension.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/10.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import Foundation

extension String {
    
    /// 扩展String,使用正则表达式获取来源
    func linkSource() -> String {
        // 匹配规则
        let pattern = ">(.*?)</a>"
        
        // 创建正则表达式
        let regular = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        // 匹配
        let result = regular.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
        
        // 匹配个数
        let count = result?.numberOfRanges ?? 0
        
        var text = "火星"
        if count > 0 {
            let range = result!.rangeAtIndex(1)
            
            // 使用范围截取字符串
            text = (self as NSString).substringWithRange(range)
        }
        
        return "来自 \(text)"
    }
}