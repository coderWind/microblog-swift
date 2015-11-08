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
            iconView.jf_setImageWithURL(imageURL)
            
            // 根据URL字符串后缀判断是否显示gif图标
            let isGif = (imageURL!.absoluteString as NSString).hasSuffix("gif")
            gifView.hidden = !isGif
        }
    }

    // MARK: - 构造方法
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
        // 添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(gifView)
        
        // 添加约束
        iconView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView.snp_edges)
        }
        
        gifView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(contentView.snp_center)
        }
        
    }
    
    // 图片
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // gif图片
    private lazy var gifView = UIImageView(image: UIImage(named: "timeline_image_gif"))
    
}
