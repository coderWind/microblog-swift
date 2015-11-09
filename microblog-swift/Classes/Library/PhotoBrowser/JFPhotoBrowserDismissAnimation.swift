//
//  JFPhotoBrowserDismissAnimation.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/9.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

// MARK: - 自定义dismiss动画的对象
class JFPhotoBrowserDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    /// 动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    /// 转场动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 获取 modal 出来的控制器
        let formVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! JFPhotoBrowserViewController
        
        // 获取 modal 出来的控制器的view
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        
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
                
                // 转场动画完成
                transitionContext.completeTransition(true)
        }
    }
}
