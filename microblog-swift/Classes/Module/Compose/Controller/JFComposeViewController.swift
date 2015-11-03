//
//  JFComposeViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景颜色
        view.backgroundColor = UIColor.whiteColor()
        
        // 准备UI
        prepareUI()
        
        // 添加键盘frame改变的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 主动弹出键盘
        textView.becomeFirstResponder()
    }
    
    // MARK: - 键盘frame改变方法
    /// 键盘frame改变方法
    func keyboardWillChangeFrame(notifiction: NSNotification) {
        // 获取键盘最终的frame
        let endFrame = notifiction.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        // toolBar底部到父控件的底部的距离 = 屏幕高度 - 键盘.frame.origin.y
        let bottomOffset = -(kScreenH - endFrame.origin.y)
        
        // 更新约束
        toolBar.snp_updateConstraints { (make) -> Void in
            make.bottom.equalTo(bottomOffset)
        }
        
        // 获取动画时间
        let duration = notifiction.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        
        // toolBar动画
        UIView.animateWithDuration(duration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    // 注销通知
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - 懒加载
    /// 工具条
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        // 设置背景颜色
        toolBar.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return toolBar
    }()
    
    /// textView
    private lazy var textView: JFPlaceholderTextView = {
        let textView = JFPlaceholderTextView()
        
        // 设置字体大小
        textView.font = UIFont.systemFontOfSize(18)
        
        // 设置contentInset
        textView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        // 设置 textView 有回弹效果
        textView.alwaysBounceVertical = true
        
        // 拖动textView关闭键盘
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        // 添加代理,监听文字改变来设置导航栏右边按钮
        textView.delegate = self
        
        textView.placeholder = "分享新鲜事..."
        
        return textView
    }()
    
}

// MARK: - 准备UI扩展
extension JFComposeViewController {
    
    
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 设置导航
        setupNavigationBar()
        
        // 设置工具条
        setupToolBar()
        
        setupTextView()
    }
    
    /**
     设置textView
     */
    private func setupTextView() {
        
        // 添加textView到控制器的view上
        view.addSubview(textView)
        
        // 约束
        textView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(toolBar.snp_top)
        }
        
    }
    
    /**
     设置工具条
     */
    private func setupToolBar() {
        
        // 添加工具条到控制器的view
        view.addSubview(toolBar)
        
        // 添加约束
        toolBar.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(44)
        }
        
        // 创建toolBar上的item
        var items = [UIBarButtonItem]()
        
        // 每个item对应的图片名称
        let itemSettings = [["imageName": "compose_toolbar_picture", "action" : "picture"],
            ["imageName": "compose_mentionbutton_background", "action" : "mention"],
            ["imageName": "compose_trendbutton_background", "action" : "trend"],
            ["imageName": "compose_emoticonbutton_background", "action" : "emotion"],
            ["imageName": "message_add_background", "action" : "add"]]
        
        // 遍历 itemSettings 创建 UIBarbuttonItem
        for dict in itemSettings {
            
            // 获取图片名称
            let name = dict["imageName"]!
            let nameHighlighted = name + "_highlighted"
            
            // 创建item
            let item = UIBarButtonItem(button: UIButton(), imageName: name, highlightedImageName: nameHighlighted)
            
            // 添加点击事件
            let button = item.customView as! UIButton
            button.addTarget(self, action: Selector(dict["action"]!), forControlEvents: UIControlEvents.TouchUpInside)
            
            items.append(item)
            
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        
        // 删除最后一根弹簧
        items.removeLast()
        
        toolBar.items = items
    }
    
    // MARK: - toolBar item 点击事件
    @objc private func picture() {
        print("图片")
    }
    
    @objc private func mention() {
        print("@")
    }
    
    @objc private func trend() {
        print("#")
    }
    
    @objc private func emotion() {
        print("表情")
    }
    
    @objc private func add() {
        print("加号")
    }
    
    /**
     设置导航条
     */
    private func setupNavigationBar() {
        
        // 取消
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "didTappedCancelButton")
        
        // 发送
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "didTappedSendButton")
        
        // 标题
        setupTitle()
    }
    
    /**
     取消按钮点击事件
     */
    @objc private func didTappedCancelButton() {
        // 退出键盘
        textView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     发送按钮点击事件
     */
    @objc private func didTappedSendButton() {
        print("发送微博")
    }
    
    /**
     设置导航标题
     */
    private func setupTitle() {
        
        let prefixString = "发微博"
        
        if let userName = JFUserAccount.shareUserAccount.name {
            
            // 创建标题标签
            let titleLabel = UILabel()
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = NSTextAlignment.Center
            
            let titleString = prefixString + "\n" + userName
            
            // 创建属性字符串
            let attributeText = NSMutableAttributedString(string: titleString)
            
            // 设置前缀属性
            let prefixRange = (titleString as NSString).rangeOfString(prefixString)
            attributeText.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(14), range: prefixRange)
            
            // 昵称属性
            let nameRange = (titleString as NSString).rangeOfString(userName)
            attributeText.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(12), NSForegroundColorAttributeName : UIColor.grayColor()], range: nameRange)
            
            // 设置Label的attributedText值
            titleLabel.attributedText = attributeText
            // 自适应
            titleLabel.sizeToFit()
            
            // 设置自定义的标题视图
            navigationItem.titleView = titleLabel
        } else {
            // 没有昵称就直接显示 发微博
            navigationItem.title = prefixString
        }
        
    }
}

// MARK: - 扩展 JFComposeViewController 实现 UITextViewDelegate代理
extension JFComposeViewController: UITextViewDelegate {
    
    // 文字改变代理方法
    func textViewDidChange(textView: UITextView) {
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
}
