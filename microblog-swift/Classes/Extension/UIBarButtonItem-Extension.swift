//
//  UIBarButtonItem-Extension.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/30.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /**
     快速创建带高亮图片的UIBarButtonItem
     parameter imageName:            正常时的图片名称
     parameter highlightedImageName: 高亮时的图片名称
     returns: UIBarButtonItem
     */
    convenience init(button: UIButton, imageName: String, highlightedImageName: String) {
        button.setBackgroundImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: highlightedImageName), forState: UIControlState.Highlighted)
        button.sizeToFit()
        
        self.init(customView: button)
    }
}
