//
//  JFPhotoBrowserModalAnimation.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/9.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

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
        
        // 获取到 modal 目标控制器的 view
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 创建 过渡视图
        let tempView = toVC.modalTempImageView()
        
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
                
                // 转场动画完成
                transitionContext.completeTransition(true)
        }
    }
}

