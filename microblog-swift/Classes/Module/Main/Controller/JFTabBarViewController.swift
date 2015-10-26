//
//  JFTabBarViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/25.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加子控制器
        addAllChildViewController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 添加加号按钮
        setupCenterButton()
        
        // 设置tabBar的背景
        tabBar.backgroundImage = UIImage(named: "tabbar_background")
        
        // 设置tabBarItem的颜色
        tabBar.tintColor = UIColor.orangeColor()
    }
    
    /**
     添加tabBar中间的加号按钮
     */
    private func setupCenterButton() {
        let centerBtn = UIButton(type: UIButtonType.Custom)
        
        centerBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        centerBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        centerBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        centerBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        tabBar.addSubview(centerBtn)
        centerBtn.frame = CGRectInset(tabBar.bounds, 2 * tabBar.bounds.width / CGFloat(childViewControllers.count) - 1, 0)
    }

    /**
     添加子控制器
     */
    private func addAllChildViewController() {
        
        setupOneChildViewController(JFHomeViewController(), title: "首页", itemImageName: "tabbar_home", badgeValue: "5")
        setupOneChildViewController(JFMessageViewController(), title: "消息", itemImageName: "tabbar_message_center", badgeValue: nil)
        addChildViewController(UIViewController())  // 占位置的
        setupOneChildViewController(JFDiscoverViewController(), title: "发现", itemImageName: "tabbar_discover", badgeValue: nil)
        setupOneChildViewController(JFProfileTableViewController(), title: "我", itemImageName: "tabbar_profile", badgeValue: "")
    }
    
    /**
     配置单个子控制器
     
     - parameter viewController:        需要配置的控制器
     - parameter title:                 控制器标题
     - parameter itemImageName:         tabBarItem默认状态图片名称
     - parameter badgeValue:            tabBarItem上的数字
     */
    private func setupOneChildViewController(viewController: UIViewController, title: String, itemImageName: String, badgeValue: String?) {
        
        viewController.title = title
        viewController.tabBarItem.image = UIImage(named: itemImageName)
        viewController.tabBarItem.badgeValue = badgeValue
        let nav = JFNavigationController(rootViewController: viewController)
        addChildViewController(nav)
    }
    
    /**
     设置全局样式
     */
    static func setupGlobalStyle() {
        let navigationBar = UINavigationBar.appearance()
        // 导航条背景色
        navigationBar.barTintColor = UIColor.whiteColor()
        
        let barButtonItem = UIBarButtonItem.appearance()
        // 文字颜色
        barButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.grayColor()], forState: UIControlState.Normal)
        barButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orangeColor()], forState: UIControlState.Highlighted)
    }
    
}
