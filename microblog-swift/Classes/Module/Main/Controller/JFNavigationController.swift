//
//  JFNavigationController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    /**
     拦截push操作，隐藏内层控制器的tabBar
     */
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
