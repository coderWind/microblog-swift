//
//  JFNewFeatureViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFNewFeatureViewController: UIViewController,UIScrollViewDelegate {
    
    // 图片数量
    let picCount = 4

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
                let enterBtn = UIButton(type: UIButtonType.Custom)
                enterBtn.setBackgroundImage(UIImage(named: "new_feature_button"), forState: UIControlState.Normal)
                enterBtn.setBackgroundImage(UIImage(named: "new_feature_button_highlighted"), forState: UIControlState.Highlighted)
                imgView.addSubview(enterBtn)
                enterBtn.snp_makeConstraints(closure: { (make) -> Void in
                    make.size.equalTo(CGSize(width: 186, height: 42.5))
                    make.centerX.equalTo(imgView.snp_centerX)
                    make.bottom.equalTo(-120)
                })
                // 添加点击事件信号
                enterBtn.addTarget(self, action: "didTappedEnterButton", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        
    }
    
    /**
     滚动中不断调用更新页码指示器
     */
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / kScreenW
        pageControl.currentPage = Int(index)
    }
    
    /**
     进入微博按钮的点击事件
     */
    func didTappedEnterButton() {
        // 进入首页
        UIApplication.sharedApplication().keyWindow?.rootViewController = JFTabBarViewController()
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
