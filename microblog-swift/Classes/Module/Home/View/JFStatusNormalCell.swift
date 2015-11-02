//
//  JFStatusNormalCell.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/31.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFStatusNormalCell: JFStatusCell {
    
    override var status: JFStatus? {
        didSet {
            
            // 更新配图区约束
            pictureView.snp_updateConstraints { (make) -> Void in
                make.size.equalTo(size)
            }
            // 更新约束后重新布局
            layoutIfNeeded()
        }
    }
    
    override func prepareUI() {
        super.prepareUI()
        
        // 顶部视图topView
        topView.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(0)
            make.height.equalTo(53)
        }
        
        // 微博内容文本标签
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(statusMargin)
            make.right.equalTo(-statusMargin)
            make.top.equalTo(topView.snp_bottom).offset(statusMargin)
            make.width.equalTo(kScreenW - statusMargin * 2)
        }

        // 微博配图
        pictureView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(statusMargin)
            make.top.equalTo(contentLabel.snp_bottom).offset(statusMargin)
            make.size.equalTo(CGSizeZero)
        }
        
        // 底部视图
        bottomView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(pictureView.snp_bottom).offset(statusMargin)
            make.left.right.equalTo(0)
            make.height.equalTo(30)
        }
        
        // 约束底部视图和cell底部重合
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(bottomView.snp_bottom)
        }
        
    }
    
}
