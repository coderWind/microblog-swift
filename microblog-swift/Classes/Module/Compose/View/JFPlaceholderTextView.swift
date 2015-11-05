//
//  JFPlaceholderTextView.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/4.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFPlaceholderTextView: UITextView {

    // MARK: - 属性
    /// 占位文本
    var placeholder: String? {
        didSet {
            
            // 设置占位文本
            placeholderLabel.text = placeholder
            
            // 设置占位文本的大小等于textView的大小
            placeholderLabel.font = font
        }
    }
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        // 准备UI
        prepareUI()
        
        // 注册通知监听者
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewDidChange:", name: UITextViewTextDidChangeNotification, object: self)
    }
    
    deinit {
        // 注销通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     textView文本内容改变事件
     */
    func textViewDidChange(notification: NSNotification) {
        // textView没有文本的时候显示占位文本
        placeholderLabel.hidden = hasText()
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        
        // 添加子控件
        addSubview(placeholderLabel)
        
        // 约束子控件
        placeholderLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(8)
            make.left.equalTo(5)
        }
    }
    
    // MARK: - 懒加载
    // 占位Label
    private lazy var placeholderLabel: UILabel = {
        // 创建label
        let label = UILabel()
        
        // 设置字体大小
        label.font = UIFont.systemFontOfSize(18)
        
        // 设置文字颜色
        label.textColor = UIColor.lightGrayColor()
        
        return label
    }()

}
