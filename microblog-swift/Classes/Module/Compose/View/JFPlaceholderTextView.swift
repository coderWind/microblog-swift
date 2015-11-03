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
            placeholderLabel.text = placeholder
            
            placeholderLabel.sizeToFit()
        }
    }
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        prepareUI()
        
        // 使用通知
        // object: 表示通知的发送者.
        // object = nil 表示任何人发送的 UITextViewTextDidChangeNotification 都能接受到
        // 指定 object, 表示只有 object 发送出来的 UITextViewTextDidChangeNotification 才能接受到
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewDidChange:", name: UITextViewTextDidChangeNotification, object: self)
    }
    
    deinit {
        // 注销通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func textViewDidChange(notification: NSNotification) {
        // textView没有文本的时候显示占位文本
        placeholderLabel.hidden = hasText()
    }
    
    // MARK: - 准备UI
    /// 准备UI
    private func prepareUI() {
        // 添加子控件
        addSubview(placeholderLabel)
        
        // 添加约束
        // 如果想给别的项目使用,最好少依赖第三方框架
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: placeholderLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 5))
    }
    
    // MARK: - 懒加载
    // 添加占位文本
    private lazy var placeholderLabel: UILabel = {
        // 创建label
        let label = UILabel()
        
        // 设置字体大小
        label.font = UIFont.systemFontOfSize(18)
        
        // 设置文字颜色
        label.textColor = UIColor.lightGrayColor()
        
        label.sizeToFit()
        
        return label
    }()

}
