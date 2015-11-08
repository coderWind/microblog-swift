//
//  JFPhotoBrowserViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/7.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFPhotoBrowserViewController: UIViewController {
    
    // MARK: - 属性
    // cell重用标示符
    private let cellIdentifier = "cellIdentifier"
    
    // 布局属性
    private var layout = UICollectionViewFlowLayout()
    
    // 当前图片索引
    private var index = 0
    
    // 图片URL数组
    private var urls: [NSURL]
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(index: Int, urls: [NSURL]) {
        self.index = index
        self.urls = urls
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册cell
        collectionView.registerClass(JFPhotoBrowserViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        // 准备UI
        prepareCollectionView()
        
        // 更新页码显示
        pageIndicator.text = "\(index + 1) / \(urls.count)"
        
        // 背景颜色
        view.backgroundColor = UIColor.redColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 代码滚动cell到指定的位置
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
    }
    
    /**
     准备collectionView
     */
    private func prepareCollectionView() {
        
        // 每个item尺寸和屏幕一样大
        layout.itemSize = kScreenBounds.size
        // 每个item的间隔
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        // 布局方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 数据源、代理
        collectionView.dataSource = self
        collectionView.delegate = self
        // 分页
        collectionView.pagingEnabled = true
        
        // 添加子控件
        // collectionView
        view.addSubview(collectionView)
        view.addSubview(pageIndicator)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        // 约束子控件
        // collectionView
        collectionView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view.snp_edges)
        }
        
        // 页码指示器
        pageIndicator.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(30)
            make.centerX.equalTo(view.snp_centerX)
        }
        
        // 关闭按钮
        closeButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(50)
            make.bottom.equalTo(-30)
        }
        
        // 保存按钮
        saveButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-50)
            make.bottom.equalTo(-30)
        }
        
    }
    
    /// 图片保存后的回调方法
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            print("error: \(error)")
            JFProgressHUD.jf_showErrorWithStatus("保存图片失败")
            return
        }
        JFProgressHUD.jf_showSuccessWithStatus("保存图片成功")
    }
    
    // MARK: - 懒加载
    // collectionView
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    
    // 页码
    private lazy var pageIndicator: UILabel = {
        let label = UILabel(textColor: UIColor.whiteColor(), fontSize: 12)
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        return label
    }()
    
    // 关闭按钮
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("关闭", forState: UIControlState.Normal)
        button.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext({ (_) -> Void in
            // 关闭控制器
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        button.sizeToFit()
        return button
    }()
    
    // 保存按钮
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("保存", forState: UIControlState.Normal)
        button.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext({ (_) -> Void in
            // 保存图片到相册
            print("保存")
     
            guard let indexPath = self.collectionView.indexPathsForVisibleItems().first  else {
                return
            }
            
            // 获取当前显示的图片
            let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as! JFPhotoBrowserViewCell
            let image = cell.imgView.image
            
            // 保存图片到相册
            UIImageWriteToSavedPhotosAlbum(image!, self, "", nil)
        })
        button.sizeToFit()
        return button
    }()
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension JFPhotoBrowserViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! JFPhotoBrowserViewCell
        
        // 赋值URL
        cell.imageUrl = urls[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("选中cell")
    }
    
    // 滚动停止调用
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        // 获取当前正在显示的cell的indexPath
        if let indexPath = collectionView.indexPathsForVisibleItems().first {
            self.index = indexPath.item
        }
        
        // 设置页码
        pageIndicator.text = "\(index + 1) / \(urls.count)"
        
    }
}
