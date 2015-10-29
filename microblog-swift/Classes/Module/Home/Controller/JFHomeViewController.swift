//
//  JFHomeViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import ReactiveCocoa

class JFHomeViewController: UITableViewController {
    
    /**
     MARK:- 视图声明周期类
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(JFUserAccount.shareUserAccount)
        
    }
    
    /**
     根据登录状态加载不同的view
     */
    override func loadView() {
        // 选择加载访客视图或已经授权的视图
        chooseView()
    }
    
}

// MARK: - extension选择加载访客视图或已经授权的视图
extension JFHomeViewController {
    
    /**
     选择加载访客视图或已经授权的视图
     */
    func chooseView() {
        if JFUserAccount.shareUserAccount.isAuth {
            // 已经授权就正常加载
            super.loadView()
            // 加载navigationBar上的按钮和标题
            // 左边好友按钮
            let leftButton = UIButton(type: UIButtonType.Custom)
            leftButton.bounds.size = CGSize(width: 30, height: 30)
            leftButton.setImage(UIImage(named: "navigationbar_friendattention"), forState: UIControlState.Normal)
            leftButton.setImage(UIImage(named: "navigationbar_friendattention_highlighted"), forState: UIControlState.Highlighted)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
            leftButton.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
                print("好友")
                return RACSignal.empty()
            })
            
            // 右边雷达按钮
            let rightButton = UIButton(type: UIButtonType.Custom)
            rightButton.bounds.size = CGSize(width: 30, height: 30)
            rightButton.setImage(UIImage(named: "navigationbar_icon_radar"), forState: UIControlState.Normal)
            rightButton.setImage(UIImage(named: "navigationbar_icon_radar_highlighted"), forState: UIControlState.Highlighted)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
            rightButton.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
                print("雷达")
                // pop控制器
                let vc = JFPopViewController(style: UITableViewStyle.Grouped)
                // 修改弹出控制器的 弹出样式
                vc.modalPresentationStyle = UIModalPresentationStyle.Popover
                // 从弹出控制器中取出UIPopoverPresentationController
                let popoverP = vc.popoverPresentationController
                popoverP?.delegate = self
                popoverP?.sourceRect = rightButton.bounds
                popoverP?.sourceView = rightButton
                self.presentViewController(vc, animated: true, completion: nil)
                return RACSignal.empty()
            })
            
            // 自定义标题
            let titleButton = JFTitleButton(type: UIButtonType.Custom)
            titleButton.bounds.size = CGSize(width: 120, height: 30)
            titleButton.adjustsImageWhenHighlighted = false
            titleButton.setTitle(JFUserAccount.shareUserAccount.name, forState: UIControlState.Normal)
            titleButton.titleLabel?.font = UIFont.systemFontOfSize(17)
            titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            titleButton.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
            titleButton.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
            titleButton.setBackgroundImage(UIImage(named: "tabbar_compose_below_button_highlighted"), forState: UIControlState.Highlighted)
            navigationItem.titleView = titleButton
            titleButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext({ (button) -> Void in
                // 改变箭头方向
                titleButton.selected = !titleButton.selected
                
                // pop控制器
                let vc = JFPopViewController(style: UITableViewStyle.Grouped)
                // 修改弹出控制器的 弹出样式
                vc.modalPresentationStyle = UIModalPresentationStyle.Popover
                // 从弹出控制器中取出UIPopoverPresentationController
                let popoverP = vc.popoverPresentationController
                popoverP?.delegate = self
                popoverP?.sourceRect = titleButton.bounds
                popoverP?.sourceView = titleButton
                self.presentViewController(vc, animated: true, completion: nil)
            })
            
        } else {
            
            // 未授权就加载访客视图
            let visitor = JFHomeVisitorView()
            // 开始旋转
            visitor.startRotationAnimation()
            // 设置代理信号
            visitor.delegateSignal = RACSubject()
            // 订阅代理信号发出的信号
            visitor.delegateSignal?.subscribeNext({ (_) -> Void in
                // 加载授权界面
                self.loadOAuthViewController()
            })
            view = visitor
            
            // 加载navigationBar上的注册和登陆
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "loadOAuthViewController")
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: "loadOAuthViewController")
            
        }
    }
    

    
    /**
     登陆、注册都调用这个方法，加载授权控制器
     */
    func loadOAuthViewController() {
        // 加载授权控制器
        presentViewController(JFNavigationController(rootViewController: JFOAuthViewController()), animated: true, completion: nil)
    }
}

// MARK: - extension各种代理方法
extension JFHomeViewController: UIPopoverPresentationControllerDelegate {
    
    // UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.Custom
    }
    
    // UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}



