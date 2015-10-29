//
//  JFTitleButton.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/27.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFTitleButton: UIButton {

    
    /**
     重新布局子控件
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let str = titleLabel!.text! as NSString
        let textSize = str.sizeWithAttributes([NSFontAttributeName : titleLabel!.font])
        titleLabel?.frame = CGRect(x: (bounds.width - textSize.width - 13) * 0.5, y: 0, width: textSize.width, height: bounds.height)
        imageView?.frame = CGRect(x: textSize.width + 15, y: 12, width: 13, height: 7)
    }
    
}
