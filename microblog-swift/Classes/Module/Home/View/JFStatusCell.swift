//
//  JFStatusCell.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/30.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFStatusCell: UITableViewCell {
    
    /// 微博模型
    var status: JFStatus? {
        didSet {
            // 更新数据
            contentLabel.text = status?.text
            
            // 将模型传递给topView
            topView.status = status
            
            // 将模型传递给pictureView
            pictureView.status = status
            
            // 获取计算好的size
            size = pictureView.bounds.size
            
        }
    }
    
    // 接收计算好的配图区size
    var size: CGSize = CGSizeZero
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 准备UI
        prepareUI()
    }
    
    /**
     准备UI
     */
    func prepareUI() {
        
        // 添加子控件
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
    }
    
    /**
     根据约束计算行高
     
     - parameter status: 微博模型
     
     - returns: 返回计算好的行高
     */
    func rowHeight(status: JFStatus) -> CGFloat {
        // 重新赋值微博模型会重新设置cell里的内容
        self.status = status
        
        // 返回cell高度，cell高度就是最底部控件的底部y值
        return CGRectGetMaxY(bottomView.frame)
    }
    
    // MARK: - 懒加载cell内的子控件
    /// 顶部view，头像、名称、vip、等级等。。
    lazy var topView: JFStatusTopView = JFStatusTopView()
    
    /// 微博内容文本标签
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        // 自动换行
        label.numberOfLines = 0
        return label
    }()
    
    /// 微博配图
    lazy var pictureView: JFStatusPictureView = JFStatusPictureView()
    
    /// 懒加载底部转发、评论、赞视图
    lazy var bottomView: JFStatusBottomView = JFStatusBottomView()
    
}
