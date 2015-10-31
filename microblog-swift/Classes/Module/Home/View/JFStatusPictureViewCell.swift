//
//  JFStatusPictureViewCell.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/31.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFStatusPictureViewCell: UICollectionViewCell {
    
    /// 图片URL，接收到数据就立马加载图片
    var imageURL: NSURL? {
        didSet {
            // 加载图片
            iconView.sd_setImageWithURL(imageURL)
        }
    }

    // MARK: - 构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 准备UI
        prepareUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(iconView)
        
        // 添加约束
        iconView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView.snp_edges)
        }
        
    }
    
    // 图片
    private lazy var iconView = UIImageView()
    
}
