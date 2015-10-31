//
//  JFTitleButton.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/27.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFTitleButton: UIButton {

     convenience init(title: String) {
        self.init()
        
        setTitle(title, forState: UIControlState.Normal)
        adjustsImageWhenHighlighted = false
        titleLabel?.font = UIFont.systemFontOfSize(17)
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        setBackgroundImage(UIImage(named: "tabbar_compose_below_button_highlighted"), forState: UIControlState.Highlighted)
        setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        sizeToFit()
    }
    
    /**
     重新布局子控件
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 把label移动到左边
        titleLabel?.frame.origin.x = 0
        
        // 把图片移到label的后面
        imageView?.frame.origin.x = titleLabel!.frame.width + 2
    }
    
}
