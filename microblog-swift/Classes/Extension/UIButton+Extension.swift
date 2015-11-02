//
//  UIButton+Extension.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/31.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

extension UIButton {
    
    /**
     快速创建按钮
     - parameter title:     按钮文字内容
     - parameter fontSize:  按钮文字大小
     - parameter textColor: 按钮文字颜色
     - parameter imageName: 按钮图片名称
     - returns: 按钮 
     */
    convenience init(title: String, fontSize: CGFloat = 12, textColor: UIColor = UIColor.darkGrayColor(), imageName: String) {
        self.init()
        
        // 文字内容
        setTitle(title, forState: UIControlState.Normal)
        
        // 文字大小
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        
        // 文字颜色
        setTitleColor(textColor, forState: UIControlState.Normal)
        
        // 图片
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        
        // 设置按钮背景色
        backgroundColor = UIColor.whiteColor()
    
    }
}