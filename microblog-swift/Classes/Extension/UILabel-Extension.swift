//
//  UILabel-Extension.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/31.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

extension UILabel {
    
    /**
     便利构造方法
     
     - parameter textColor: 文本颜色
     - parameter fontSize:  文本大小
     
     - returns: 返回UILabel
     */
    convenience init(textColor: UIColor, fontSize: CGFloat) {
        self.init()
        self.textColor = textColor
        self.font = UIFont.systemFontOfSize(fontSize)
    }
}