//
//  JFStatusForwardCell.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/31.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFStatusForwardCell: JFStatusCell {

    override var status: JFStatus? {
        didSet {
            
            let name = status?.retweeted_status?.user?.name ?? "名称为空"
            let text = status?.retweeted_status?.emoticonString ?? NSAttributedString(string: "转发内容为空")
            
            let attrM = NSMutableAttributedString(string: "@\(name): ")
            // 拼接属性文本
            attrM.appendAttributedString(text)
            forwardLabel.attributedText = attrM
            
            // 更新配图区约束
            pictureView.snp_updateConstraints { (make) -> Void in
                make.size.equalTo(size)
            }
            
            // 更新约束后重新布局
            layoutIfNeeded()
        }
    }
    
    /**
     重写父控件prepareUI方法
     */
    override func prepareUI() {
        super.prepareUI()
        
        // 添加子控件
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.addSubview(forwardLabel)
        
        // 顶部视图topView
        topView.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(0)
            make.height.equalTo(53)
        }
        
        // 微博内容文本标签
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(statusMargin)
            make.top.equalTo(topView.snp_bottom).offset(statusMargin)
            make.width.equalTo(kScreenW - statusMargin * 2)
        }

        // 转发微博背景
        backButton.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(0)
            make.top.equalTo(contentLabel.snp_bottom).offset(statusMargin)
            make.bottom.equalTo(bottomView.snp_top)
        }
        
        // 转发微博文字
        forwardLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(statusMargin)
            make.right.equalTo(-statusMargin)
            make.top.equalTo(backButton.snp_top).offset(statusMargin)
            make.width.equalTo(kScreenW - statusMargin * 2)
        }
        
        // 微博配图
        pictureView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(statusMargin)
            make.top.equalTo(forwardLabel.snp_bottom).offset(statusMargin)
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
    
    // MARK: - 懒加载
    /// 转发微博文字
    private lazy var forwardLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFontOfSize(14)
        
        label.textColor = UIColor.grayColor()
        
        // 设置换行属性
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 被转发微博背景
    private lazy var backButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.Custom)
        
        // 按钮背景
        button.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
        
        return button
    }()
}
