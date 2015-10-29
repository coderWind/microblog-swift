//
//  JFItemButton.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/28.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFItemButton: UIButton {

    /**
     重新布局子控件
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = CGRect(x: (bounds.width - 71) * 0.5, y: 10, width: 71, height: 71)
        titleLabel?.frame = CGRect(x: 0, y: 90, width: bounds.width, height: 30)
        
        if self.highlighted {
            imageView?.frame = CGRect(x: (bounds.width - 71) * 0.5 - 2, y: 10, width: 75, height: 75)
        }
    }

}
