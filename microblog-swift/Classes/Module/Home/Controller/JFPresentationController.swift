//
//  JFPresentationController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/9.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFPresentationController: UIPresentationController {

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // 呈现视图
        presentedView()?.snp_makeConstraints(closure: { (make) -> Void in
            make.centerX.equalTo(containerView!.snp_centerX)
            make.top.equalTo(56)
            make.size.equalTo(CGSize(width: 200, height: 300))
        })
        
        // 添加点击手势
        let tap = UITapGestureRecognizer(target: self, action: "didTappedContainerView")
        containerView?.addGestureRecognizer(tap)
    }
    
    /**
     容器视图区域的点击手势
     */
    @objc private func didTappedContainerView() {
        NSNotificationCenter.defaultCenter().postNotificationName("PopoverDismiss", object: nil)
        presentedViewController.dismissViewControllerAnimated(false, completion: nil)
    }
}
