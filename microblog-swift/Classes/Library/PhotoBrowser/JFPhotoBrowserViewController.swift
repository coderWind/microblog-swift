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
    
    // 当前模型的索引
    private var index = 0
    
    // 模型数组
    private var models: [JFPhotoBrowserModel]
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(index: Int, models: [JFPhotoBrowserModel]) {
        self.index = index
        self.models = models
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 注册cell
        collectionView.registerClass(JFPhotoBrowserViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        // 准备UI
        prepareCollectionView()
        
        // 更新页码显示
        pageIndicator.text = "\(index + 1) / \(models.count)"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        // 布局方向
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        // 数据源、代理
        collectionView.dataSource = self
        collectionView.delegate = self
        // 分页
        collectionView.pagingEnabled = true
        
        // 添加子控件
        view.addSubview(backgroundView)
        view.addSubview(collectionView)
        view.addSubview(pageIndicator)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        
        // 约束子控件
        // 背景
        backgroundView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view.snp_edges)
        }
        
        // collectionView
        collectionView.snp_makeConstraints { (make) -> Void in
            make.left.top.bottom.equalTo(0)
            // 宽度增加一个间距的宽度
            make.width.equalTo(kScreenW + 10)
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
            JFProgressHUD.jf_showErrorWithStatus("保存图片失败")
            return
        }
        JFProgressHUD.jf_showSuccessWithStatus("保存图片成功")
    }
    
    // MARK: - 懒加载
    // collectionView
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    
    // 页码
    private lazy var pageIndicator: UILabel = {
        let label = UILabel(textColor: UIColor.whiteColor(), fontSize: 12)
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
            
            // 获取真正显示的item的idnexPath
            guard let indexPath = self.collectionView.indexPathsForVisibleItems().first  else {
                return
            }
            
            // 获取当前显示的图片
            let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as! JFPhotoBrowserViewCell
            
            guard let image = cell.imgView.image else {
                return
            }

            // 保存图片到相册
            UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        })
        button.sizeToFit()
        return button
    }()
    
    /// 背景视图,转场动画时用来设置透明度
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blackColor()
        return view
    }()
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension JFPhotoBrowserViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // 创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! JFPhotoBrowserViewCell
        
        cell.imageUrl = models[indexPath.item].imageUrl
        cell.model = models[indexPath.item]
        
        // 设置代理
        cell.transitionDelegate = self
        
        return cell
    }
    
    // 滚动停止调用
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

        // 获取当前正在显示的cell的indexPath
        if let indexPath = collectionView.indexPathsForVisibleItems().first {
            self.index = indexPath.item
        }
        
        // 设置页码
        pageIndicator.text = "\(index + 1) / \(models.count)"
        
    }
}

// MARK: - UIViewControllerTransitioningDelegate自定义转场动画
extension JFPhotoBrowserViewController: UIViewControllerTransitioningDelegate {
    
    /// 返回控制 modal 动画的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JFPhotoBrowserModalAnimation()
    }
    
    /// 返回控制 dismiss 动画的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JFPhotoBrowserDismissAnimation()
    }
}

// MARK: - 自定义moadl动画的对象
class JFPhotoBrowserModalAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    /// 转场动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 获取到 modal 的目标控制器
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! JFPhotoBrowserViewController
        
        // 创建 过渡视图
        let tempView = toVC.modalTempImageView()
        
        // 获取到 modal 目标控制器的 view
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 添加 toView 到 容器视图
        transitionContext.containerView()?.addSubview(toView)
        
        // 添加 过渡视图 到 容器视图
        transitionContext.containerView()?.addSubview(tempView)
        
        // 设置toView的alpha
        toView.alpha = 0
        
        // 隐藏collectionView
        toVC.collectionView.hidden = true
        
        // 动画 toView的alpha 由 0 - 1 渐入效果
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            // 淡入动画
            toView.alpha = 1
            
            // 放大动画
            tempView.frame = toVC.modalTargetFrame()
            }) { (_) -> Void in
                // 显示collectionView
                toVC.collectionView.hidden = false
                
                // 移除 过渡视图
                tempView.removeFromSuperview()
                
                // 转场动画完成一定要记得调用 completeTransition, 否则系统不知道转场动画完成,无法交互
                transitionContext.completeTransition(true)
        }
    }
}

// MARK: - 自定义dismiss动画的对象
class JFPhotoBrowserDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    /// 转场动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 获取 modal 出来的控制器的view
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
        // 获取 modal 出来的控制器
        let formVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! JFPhotoBrowserViewController
        
        // 生成过渡视图
        let tempView = formVC.dismissTempImageView()
        
        // 添加到容器视图
        transitionContext.containerView()?.addSubview(tempView)
        
        // 隐藏collectionView
        formVC.collectionView.hidden = true
        
        // 动画 fromView.alpha 由 1 - 0
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            // 透明
            fromView?.alpha = 0
            
            // 过渡视图缩小到目标位置
            tempView.frame = formVC.dismissTargetFrame()
            }) { (_) -> Void in
                fromView?.removeFromSuperview()
                transitionContext.completeTransition(true)
        }
    }
}

// MARK: - 提供过渡视图
extension JFPhotoBrowserViewController {
    
    /**
     提供放大过渡视图，大小和缩略图一样
     */
    func modalTempImageView() -> UIImageView {
        
        // 获取被点击的模型
        let model = models[index]
        
        let imageView = UIImageView(image: model.imageView?.image)
        
        // 设置属性
        imageView.contentMode = model.imageView!.contentMode
        imageView.clipsToBounds = true
        
        // 设置frame
        imageView.frame = model.imageView!.superview!.convertRect(model.imageView!.frame, toCoordinateSpace: view)
        
        return imageView
    }
    
    /**
     计算放大后的frame,图片等比例放大到宽度等于屏幕宽度
     - returns: 放大后的尺寸
     */
    func modalTargetFrame() -> CGRect {
        // 获取图片
        let image = models[index].imageView!.image!
        
        // 计算高度
        // 放大后的高度 / 放大后的宽度 = 放大前的高度 / 放大前的宽度
        var newHeight = UIScreen.mainScreen().bounds.width * image.size.height / image.size.width
        
        var offestY: CGFloat = 0
        if newHeight < UIScreen.mainScreen().bounds.height {
            // 短图,居中
            offestY = (UIScreen.mainScreen().bounds.height - newHeight) * 0.5
        } else {
            // 长图,顶部开始显示,高度等于屏幕的高度
            newHeight = UIScreen.mainScreen().bounds.height
        }
        
        return CGRect(x: 0, y: offestY, width: UIScreen.mainScreen().bounds.width, height: newHeight)
    }
    
    /**
     提供缩小过渡视图,大小和正在显示的图片一样
     - returns: 过渡视图
     */
    func dismissTempImageView() -> UIImageView {
        // 获取当前显示的索引
        let showIndexPath = collectionView.indexPathsForVisibleItems().first!
        
        // 获取正在显示的cell
        let cell = collectionView.cellForItemAtIndexPath(showIndexPath) as! JFPhotoBrowserViewCell
        
        //获取正在显示的imageView
        let showImageView = cell.imgView
        
        // 生成过渡视图
        let tempImageView = UIImageView(image: showImageView.image)
        
        // 设置相关属性
        tempImageView.contentMode = UIViewContentMode.ScaleAspectFill
        tempImageView.clipsToBounds = true
        
        // 将cell的imageView坐标系转换到当前控制器的view的坐标系
        let rect = showImageView.superview?.convertRect(showImageView.frame, toCoordinateSpace: view)
        tempImageView.frame = rect!
        
        return tempImageView
    }
    
    /**
     缩小后的frame,缩略图cell的位置
     - returns: 缩略图cell的位置
     */
    func dismissTargetFrame() -> CGRect {
        // 获取正在显示的cell的indexPath
        let showIndexPath = collectionView.indexPathsForVisibleItems().first
        
        // 获取对应的模型
        let model = models[showIndexPath!.item]
        
        // 小图
        let imageView = model.imageView
        
        // 坐标系转换
        let rect = imageView?.convertRect(imageView!.frame, toCoordinateSpace: view)
        
        return rect!
    }
    
}

// MARK: - JFPhotoBrowserCellDelegate委托方法
extension JFPhotoBrowserViewController: JFPhotoBrowserCellDelegate {
    
    /// 关闭modal视图
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 返回需要透明的背景视图
    func viewForTransparent() -> UIView {
        return backgroundView
    }
}