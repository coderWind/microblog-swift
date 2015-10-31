//
//  JFStatusBottomView.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/31.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFStatusBottomView: UIView {
    
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
        addSubview(forwardButton)
        addSubview(commentButton)
        addSubview(likeButton)
        addSubview(separatorViewOne)
        addSubview(separatorViewTwo)
        addSubview(separatorViewTop)
        addSubview(separatorViewBottom)
        
    }
    
    // 妈蛋，约束加不了，只能用frame了
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 按钮宽度
        let buttonWidth = kScreenW / 3
        // 按钮高度
        let buttonHeight = self.bounds.height
        
        // 转发
        forwardButton.frame = CGRectMake(0, 0, buttonWidth, buttonHeight)
        // 评论
        commentButton.frame = CGRectMake(buttonWidth, 0, buttonWidth, buttonHeight)
        // 赞
        likeButton.frame = CGRectMake(buttonWidth * 2, 0, buttonWidth, buttonHeight)
        // 分割线1
        separatorViewOne.frame = CGRectMake(buttonWidth, 8, 1, buttonHeight - 16)
        // 分割线2
        separatorViewTwo.frame = CGRectMake(buttonWidth * 2, 8, 1, buttonHeight - 16)
        // 顶部分割线
        separatorViewTop.frame = CGRectMake(0, 0, kScreenW, 1)
        // 底部分割线
        separatorViewBottom.frame = CGRectMake(0, buttonHeight, kScreenW, 1)

    }
    
    // MARK: - 懒加载控件
    // 转发
    private lazy var forwardButton = UIButton(title: "转发", fontSize: 12, textColor: UIColor.darkGrayColor(), imageName: "timeline_icon_retweet")
    
    // 评论
    private lazy var commentButton = UIButton(title: "评论", fontSize: 12, textColor: UIColor.darkGrayColor(), imageName: "timeline_icon_comment")
    
    // 赞
    private lazy var likeButton = UIButton(title: "赞", fontSize: 12, textColor: UIColor.darkGrayColor(), imageName: "timeline_icon_unlike")
    
    // 水平分割线
    private lazy var separatorViewOne = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    private lazy var separatorViewTwo = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    
    // 顶部分割线
    private lazy var separatorViewTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
        return view
        }()
    
    // 底部分割线
    private lazy var separatorViewBottom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
        return view
    }()
    
}
