//
//  UITextView+Emoticon.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/5.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

extension UITextView {
    
    /**
     插入表情
     */
    func insertEmoticon(emoticon: JFEmoticon) {
        
        // 删除按钮,删除textView内容
        if emoticon.removeEmoticon {
            deleteBackward()
        }
        
        // 插入emoji
        if emoticon.emoji != nil {
//            replaceRange(selectedTextRange!, withText: emoticon.emoji!)
            insertText(emoticon.emoji!)
            return
        }
        
        // 插入表情图片
        if emoticon.chs != nil {

            // 创建属性文本
            let imageText = JFTextAttachment.imageText(emoticon, font: font!)
            
            // 拼接到已有的属性文本
            // 获取textView中的属性文本
            let content = NSMutableAttributedString(attributedString: attributedText)
            
            // 将选中的内容替换为图片表情
            content.replaceCharactersInRange(selectedRange, withAttributedString: imageText)
            
            // 记录选中的范围
            let range = selectedRange
            
            // 将新拼接好的属性赋值给textView
            attributedText = content
            
            // 修改光标位置到之前位置
            selectedRange = NSRange(location: range.location + 1, length: 0)
            
            // 主动调用代理的文本发生改变，清空占位文字
            delegate?.textViewDidChange?(self)
            
            // 主动发送文本发生改变的通知，改变发布按钮的禁用状态
            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self)
        }
    }
    
    /// 获取表情文本
    func emoticonText() -> String {
        
        // 属性文本是分段保存的,要获得所有的文本,需要将每一段都拿出来,拼接在一起
        var strM = ""
        
        // 遍历属性文本
        attributedText.enumerateAttributesInRange(NSRange(location: 0, length: attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) -> Void in
            
            // 如果是图片,dict件包含 NSAttachment这个key
            if let attchment = dict["NSAttachment"] as? JFTextAttachment {
                strM += attchment.name!
            } else {
                let str = (self.text as NSString).substringWithRange(range)
                strM += str
            }
        }
        
        return strM
    }
}

