//
//  JFEmoticonCell.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/4.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

// MARK: - 自定义cell类
class JFEmoticonCell: UICollectionViewCell {
    
    // MARK: - 属性
    var emoticon: JFEmoticon? {
        didSet {
            
            // 判断是否是 表情图片
            if emoticon?.pngPath != nil {
                // 按钮要显示 Emoticons.bundle 里面的图片需要图片的全路径,图片的全路径有模型来提供
                emojiButton.setImage(UIImage(contentsOfFile: emoticon!.pngPath!), forState: UIControlState.Normal)
            } else {
                // 没有图片表情,需要清空,否则cell重用
                emojiButton.setImage(nil, forState: UIControlState.Normal)
            }
            
            // 判断是否有emoji字符串
            emojiButton.setTitle(emoticon?.emoji, forState: UIControlState.Normal)
            
            // 判断是否是删除按钮
            if emoticon!.removeEmoticon {
                // 设置删除按钮图片
                emojiButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
            }
            
        }
    }
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 背景颜色
        contentView.backgroundColor = UIColor.whiteColor()
        
        // 准备UI
        prepareUI()
        
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 添加子控件
        contentView.addSubview(emojiButton)
        
        // 添加约束
        emojiButton.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 32, height: 32))
            make.center.equalTo(contentView.snp_center)
        }
        
    }
    
    // MARK: - 懒加载子控件
    /// 表情按钮
    private lazy var emojiButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFontOfSize(32)
        button.backgroundColor = UIColor.whiteColor()
        // 禁止按钮交互
        button.userInteractionEnabled = false
        return button
    }()
    
}
