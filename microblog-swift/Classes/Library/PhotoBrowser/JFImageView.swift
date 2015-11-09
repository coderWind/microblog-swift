//
//  JFImageView.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/9.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFImageView: UIImageView {

    // 重写父类transform属性，让最小缩放 不小于0.5
    override var transform: CGAffineTransform {
        didSet {
            if transform.a < 0.5 {
                transform.a = 0.5
                transform.d = 0.5
            }
        }
    }
    
}
