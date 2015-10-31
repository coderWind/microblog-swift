//
//  JFStatusTopView.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/30.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFStatusTopView: UIView {
    
    /// 微博模型
    var status: JFStatus? {
        didSet {
            // 更新topView的数据
            // 头像
            if let url = status?.user?.profileImageUrl {
                iconView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar"))
            }
            
            // 认证
            verifiedView.image = status?.user?.verifiedTypeImage
            
            // 用户名称
            nameLabel.text = status?.user?.name
            
            // 会员等级
            memberView.image = status?.user?.mbrankImage
            
            // 时间标签
            timeLabel.text = status?.created_at
            
            // 来源
            sourceLabel.text = "微博"
        }
    }
    
    // 构造方法，从sb/xib加载调用
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 准备UI
        prepareUI()
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 添加控件
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(memberView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(topSeparatorView)
        
        // 约束控件
        // 顶部分割线
        topSeparatorView.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(0)
            make.height.equalTo(10)
        }
        
        // 头像图标
        iconView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 35, height: 35))
            make.top.equalTo(topSeparatorView.snp_bottom).offset(12)
            make.left.equalTo(12)
        }
        
        // 认证图标
        verifiedView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 17, height: 17))
            make.bottom.equalTo(iconView.snp_bottom)
            make.left.equalTo(iconView.snp_right).offset(-8.5)
        }
        
        // 名称
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(iconView.snp_right).offset(12)
            make.top.equalTo(iconView.snp_top).offset(1)
        }
        
        // 会员等级图标
        memberView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 14, height: 14))
            make.left.equalTo(nameLabel.snp_right).offset(5)
            make.centerY.equalTo(nameLabel.snp_centerY)
        }
        
        // 发布时间
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp_bottom).offset(5)
            make.left.equalTo(nameLabel.snp_left)
        }
        
        // 来源
        sourceLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(timeLabel.snp_top)
            make.left.equalTo(timeLabel.snp_right).offset(12)
        }
        
    }
    
    // MARK: - 懒加载topView子控件
    // 用户头像
    private lazy var iconView: UIImageView = {
        let image = UIImage(named: "avatar")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 17.5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // 认证图标
    private lazy var verifiedView: UIImageView = {
        UIImageView()
    }()
    
    // 用户名称标签
    private lazy var nameLabel = UILabel(textColor: UIColor.darkGrayColor(), fontSize: 14)
    
    // 会员等级图标
    private lazy var memberView: UIImageView = {
        let image = UIImage(named: "common_icon_membership")
        return UIImageView(image: image)
    }()
    
    // 时间标签
    private lazy var timeLabel = UILabel(textColor: UIColor.orangeColor(), fontSize: 9)
    
    // 来源标签
    private lazy var sourceLabel = UILabel(textColor: UIColor.lightGrayColor(), fontSize: 9)
    
    // 顶部分割线
    private lazy var topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
        return view
    }()
    
}

