//
//  UIImageView+Extension.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/1.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

// MARK: - 隔离SDWebImage
extension UIImageView {
    
    /**
     URL加载图片
     
     - parameter url: 图片URL
     */
    public func jf_setImageWithURL(url: NSURL!) {
        sd_setImageWithURL(url)
    }
    
    /**
     带占位图的URL加载图片
     
     - parameter url:         图片URL
     - parameter placeholder: 占位图
     */
    public func jf_setImageWithURL(url: NSURL!, placeholderImage placeholder: UIImage!) {
        sd_setImageWithURL(url, placeholderImage: placeholder)
    }
}