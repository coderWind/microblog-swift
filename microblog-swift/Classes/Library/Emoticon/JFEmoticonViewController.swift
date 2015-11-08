//
//  JFEmoticonViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/4.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

// MARK: - 表情键盘控制器类
class JFEmoticonViewController: UIViewController {
    
    // MARK: - 视图声明周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 准备UI
        prepareUI()
        
        view.backgroundColor = UIColor.whiteColor()
        
    }
    
    // MARK: - 懒加载子控件
    /// 表情视图区
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: JFEmoticonLayout())
        collectionView.backgroundColor = UIColor.whiteColor()
        return collectionView
    }()
    
    /// 工具条
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        
        return toolBar
    }()
    
    /// 表情包数据
    private lazy var packages = JFEmotionPackage.packages
    
    /// 记录选中的按钮
    private var selectedButton: UIButton?
    
    /// 按钮起始tag
    private let baseTag = 1000
    
    /// textView
    weak var textView: UITextView?
    
    // cell重用标示符
    private let emoticonCellIdentifier = "emoticonCell"
}

// MARK: - UI相关扩展
extension JFEmoticonViewController {
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        // 添加约束
        collectionView.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(0)
            make.bottom.equalTo(toolBar.snp_top)
        }
        setupCollectionView()
        
        toolBar.snp_makeConstraints { (make) -> Void in
            make.left.bottom.right.equalTo(0)
            make.top.equalTo(collectionView.snp_bottom)
        }
        setupToolBar()
        
    }
    
    /**
     设置toolBar
     */
    private func setupToolBar() {
        
        // 创建items数组
        var items = [UIBarButtonItem]()
        
        var index = 0
        
        for package in packages {
            
            // 获取表情包名
            let name = package.group_name_cn
            
            let button = UIButton()
            // 设置按钮文字
            button.setTitle(name, forState: UIControlState.Normal)
            
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Selected)
            
            // 添加点击事件
            button.addTarget(self, action: "itemClick:", forControlEvents: UIControlEvents.TouchUpInside)
            
            // 添加tag用于确定点击哪个按钮
            button.tag = index + baseTag
            
            // 默认选中 最近 按钮
            if index == 0 {
                switchSelectedButton(button)
            }
            
            // 创建item
            let item = UIBarButtonItem(customView: button)
            
            // 添加到数组
            items.append(item)
            
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            
            // 自适应大小
            button.sizeToFit()
            
            index++
        }
        
        // 移除最后一个弹簧
        items.removeLast()
        
        // 设置工具条上的item
        toolBar.items = items
        
    }
    
    // MARK: - toolBar按钮点击事件
    /// toolBar按钮点击事件
    func itemClick(button: UIButton) {
        
        // 选中按钮
        switchSelectedButton(button)
        
        // 获取到对应的section, 显示每组最前面的
        let indexPath = NSIndexPath(forItem: 0, inSection: button.tag - baseTag)
        
        // 切换collectionView 到对应的section
        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.Left)
    }
    
    /**
     切换选中按钮
     parameter button: 要选中的按钮
     */
    private func switchSelectedButton(button: UIButton) {
        // 设置选中的按钮为normal状态
        selectedButton?.selected = false
        
        // 设置传入的按钮为selected状态
        button.selected = true
        
        // 设置选中的按钮为传入的按钮
        selectedButton = button
    }
    
    /**
     设置collectionView
     */
    private func setupCollectionView() {
        
        // 注册cell
        collectionView.registerClass(JFEmoticonCell.self, forCellWithReuseIdentifier: emoticonCellIdentifier)
        
        // 设置数据源
        collectionView.dataSource = self
        
        // 设置代理
        collectionView.delegate = self
    }
    
}

// MARK: - UICollectionViewDataSource数据源
extension JFEmoticonViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // cell 点击
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        
        // 调用分类方法插入表情到textView
        textView!.insertEmoticon(emoticon)
        
        // 最近表情不参与排序，不是最近表情包
        if indexPath.section != 0 {
            // 将使用的表情添加到最近表情包里面
            JFEmotionPackage.addFavorate(emoticon)
        }
        
        // 刷新数据, 用户体验不好
        collectionView.reloadSections(NSIndexSet(index: 0))
    }
    
    // 监听collectionView停止滚动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        // 获取到正在显示的section
        let indexPath = collectionView.indexPathsForVisibleItems().first
        let section = indexPath!.section
        
        // 根据section获取到对应的按钮
        let button = toolBar.viewWithTag(section + baseTag) as! UIButton
        
        // 设置按钮高亮
        switchSelectedButton(button)
    }
    
    /**
     一共多少组
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    /**
     每组多少个cell
     */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons!.count
    }
    
    /**
     创建cell
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(emoticonCellIdentifier, forIndexPath: indexPath) as! JFEmoticonCell
        
        // 赋值模型
        cell.emoticon = packages[indexPath.section].emoticons?[indexPath.row]
        
        return cell
        
    }
    
}
