//
//  JFPopoverModalAnimation.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/9.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFPopoverModalAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    // 动画时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.25
    }
    
    // modal动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        // 获取到需要modal的控制器的view
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        // 将需要modal的控制器的view添加到容器视图
        transitionContext.containerView()?.addSubview(toView)
        
        toView.transform = CGAffineTransformMakeScale(1, 0)
        toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
        // 动画缩放modal的控制器的view到正常大小
        UIView.animateWithDuration(transitionDuration(nil), delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 2, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            toView.transform = CGAffineTransformIdentity
            }, completion: { (_) -> Void in
            transitionContext.completeTransition(true)
        })
    }
}
