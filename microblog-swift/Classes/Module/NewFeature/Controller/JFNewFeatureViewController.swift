//
//  JFNewFeatureViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import ReactiveCocoa

class JFNewFeatureViewController: UIViewController,UIScrollViewDelegate {
    
    // 图片数量
    let picCount = 4
    
    var enterBtn: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加scrollView
        self.view.addSubview(scrollView)
        // 添加pageControl
        self.view.addSubview(pageControl)
        pageControl.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(-70)
            make.centerX.equalTo(view.snp_centerX)
        }
        
        // 创建scrollView上的子控件
        for index in 0..<picCount {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "new_feature_\(index + 1)")
            scrollView.addSubview(imgView)
            imgView.snp_makeConstraints(closure: { (make) -> Void in
                make.top.equalTo(0)
                make.height.equalTo(kScreenH)
                make.width.equalTo(kScreenW)
                make.left.equalTo(CGFloat(index) * kScreenW)
            })
            
            // 在最后一张图片上添加按钮
            if index == picCount - 1 {
                imgView.userInteractionEnabled = true
                // 创建进入微博按钮
                enterBtn = UIButton(type: UIButtonType.Custom)
                enterBtn!.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
                enterBtn!.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
                imgView.addSubview(enterBtn!)
                enterBtn!.snp_makeConstraints(closure: { (make) -> Void in
                    make.size.equalTo(CGSize(width: 80, height: 30))
                    make.centerX.equalTo(imgView.snp_centerX)
                    make.bottom.equalTo(-180)
                })
                // 添加点击事件信号
                enterBtn?.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
                    // 进入首页
                    UIApplication.sharedApplication().keyWindow?.rootViewController = JFTabBarViewController()
                    return RACSignal.empty()
                })
            }
        }
        
    }
    
    /**
     开始缩放动画
     */
    func startScaleAnimation(button: UIButton) {
        button.transform = CGAffineTransformMakeScale(0, 0)
        UIView.animateWithDuration(1.0, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            button.transform = CGAffineTransformMakeScale(1.5, 1.2)
            }) { (_) -> Void in
                
        }
    }
    
    /**
     滚动中不断调用更新页码指示器
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / kScreenW
        pageControl.currentPage = Int(index)
        
        if self.scrollView.contentOffset.x >= kScreenW * 3 && enterBtn != nil {
            enterBtn?.alpha = 1
            // 调用缩放动画方法
            startScaleAnimation(enterBtn!)
        } else if self.scrollView.contentOffset.x <= kScreenW * 2 {
            enterBtn?.alpha = 0
        }
    }
    
    // MARK: - 懒加载
    // 懒加载全屏scrollView
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: kScreenBounds)
        scroll.delegate = self
        scroll.contentSize = CGSize(width: kScreenW * CGFloat(self.picCount), height: kScreenH)
        scroll.pagingEnabled = true
        scroll.bounces = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    // 懒加载页码指示器
    lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = self.picCount
        page.pageIndicatorTintColor = UIColor.lightGrayColor()
        page.currentPageIndicatorTintColor = kOrangeColor
        page.sizeToFit()
        return page
    }()
    
    
}
