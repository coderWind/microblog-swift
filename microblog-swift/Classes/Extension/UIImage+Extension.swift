//
//  UIImage+Extension.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/16.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
    让图片不被渲染
    
    - parameter image: 需要不被渲染的图片
    - returns: 返回不被渲染的图片
    */
    func setupImageAlwaysOriginal() -> UIImage? {
        return self.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
    
    /**
    无损拉伸图片
    
    - parameter imageName: 被拉伸图片的名称
    
    - returns: 返回拉伸后的图片对象
    */
    static func resizableImage(imageName imageName: String) -> UIImage {
        let image = UIImage(named: imageName)
        let imgW = image!.size.width
        let imgH = image!.size.height
        return image!.resizableImageWithCapInsets(UIEdgeInsets(top: imgH / 2, left: imgW / 2, bottom: imgH / 2, right: imgW / 2), resizingMode: UIImageResizingMode.Stretch)
    }
    
}
