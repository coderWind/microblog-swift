//
//  JFTextAttachment.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/5.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFTextAttachment: NSTextAttachment {
    
    // MARK: - 属性
    /// 保存表情图片对应的名称
    var name: String?
    
    /**
     根据emoticon创建属性文本
     */
    class func imageText(emoticon: JFEmoticon, font: UIFont) -> NSAttributedString{
        // 1.创建附件
        let attachment = JFTextAttachment()
        attachment.name = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        
        // font的高度
        let h = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: h, height: h)
        
        // 2.创建属性文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        imageText.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: 1))
        
        return imageText
    }
    
}
