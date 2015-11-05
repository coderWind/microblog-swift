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
protocol JFPhotoSelectorCellDelegate : NSObjectProtocol {
    
    // 加号按钮点击事件
    func photoSelectorCellAddPhoto(cell: JFPhotoSelectorCell)
    // 删除按钮点击时间
    func photoSelectorCellRemovePhoto(cell: JFPhotoSelectorCell)
}

class JFPhotoSelectorCell: UICollectionViewCell {
    
    /// 显示的image
    var image: UIImage? {
        didSet {
            // image == nil 表示最后一个按钮
            if image == nil {
                addButton.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
            } else {
                addButton.setImage(image, forState: UIControlState.Normal)
            }
            
            // 如果是最后一个按钮不需要显示删除按钮
            removeButton.hidden = image == nil
        }
    }
    
    /// 代理
    var cellDelegate: protocol<JFPhotoSelectorCellDelegate>?
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 准备UI
        prepareUI()
        
        backgroundColor = UIColor.whiteColor()
        
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
            self.cellDelegate?.photoSelectorCellAddPhoto(self)
        }
        // 移除
        removeButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.cellDelegate?.photoSelectorCellRemovePhoto(self)
        }
        
        
    }
    
    // 懒加载
    // 加号按钮
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
        // 设置图片的填充模式
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
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
