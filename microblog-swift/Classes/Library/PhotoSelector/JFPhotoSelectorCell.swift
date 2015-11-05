//
//  JFPhotoSelectorCell.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/5.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import ReactiveCocoa

/**
 *  cell代理
 */
protocol JFPhotoSelectorCellDelegate {
    
    // 加号按钮点击事件
    func photoSelectorCellAddPhoto()
    
    // 删除按钮点击时间
    func photoSelectorCellRemovePhoto()
}

class JFPhotoSelectorCell: UICollectionViewCell {
    
    /// 代理
    var cellDelegate: JFPhotoSelectorCellDelegate?
    
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
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        
        // 约束子控件
        // 添加按钮
        addButton.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView.snp_edges)
        }
        
        // 删除按钮
        removeButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(addButton.snp_right)
            make.top.equalTo(addButton.snp_top)
        }
        
        
        // 按钮点击事件
        // 添加
        addButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.cellDelegate?.photoSelectorCellAddPhoto()
        }
        // 移除
        removeButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.cellDelegate?.photoSelectorCellRemovePhoto()
        }
        
        
        
    }
    
    // 懒加载
    // 加号按钮
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
        return button
    }()
    
    
    // 删除按钮
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pic_delete"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "pic_delete_highlighted"), forState: UIControlState.Highlighted)
        return button
    }()
    
}
