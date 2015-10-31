//
//  JFHomeViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SVProgressHUD

/**
 cell重用标示符
 
 - NormalCell:  原创微博cell
 - ForwardCell: 转发微博cell
 */
enum JFStatusCellIdentifier: String {
    case NormalCell = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    // 根据微博模型返回重用标示符
    static func cellId(status: JFStatus) -> String {
        return (status.retweeted_status == nil) ? NormalCell.rawValue : ForwardCell.rawValue
    }
}

class JFHomeViewController: UITableViewController {
    
    /// 微博模型数组
    var statuses: [JFStatus]? {
        // 属性监视器
        didSet {
            tableView.reloadData()
        }
    }
    
    //  MARK:- 视图声明周期类
    /**
    根据登录状态加载不同的view
    */
    override func loadView() {
        // 选择加载访客视图或已经授权的视图
        chooseView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 授权了才执行
        if JFUserAccount.shareUserAccount.isAuth {
            
            // 加载微博数据
            loadStatus()
            
            // 注册可重用的cell
            tableView.registerClass(JFStatusNormalCell.self, forCellReuseIdentifier: JFStatusCellIdentifier.NormalCell.rawValue)
            tableView.registerClass(JFStatusForwardCell.self, forCellReuseIdentifier: JFStatusCellIdentifier.ForwardCell.rawValue)
            
            // 去掉分割线
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
        }
        
    }
    
}

// MARK: - extension选择加载访客视图或已经授权的视图
extension JFHomeViewController {
    
    /**
     选择加载访客视图或已经授权的视图
     */
    private func chooseView() {
        if JFUserAccount.shareUserAccount.isAuth {
            // 已经授权就正常加载
            super.loadView()
        } else {
            // 未授权就加载访客视图
            let visitor = JFHomeVisitorView()
            // 设置代理信号
            visitor.delegateSignal = RACSubject()
            // 订阅代理信号发出的信号
            visitor.delegateSignal?.subscribeNext({ (_) -> Void in
                // 加载授权界面
                self.loadOAuthViewController()
            })
            view = visitor
        }
        
        // 设置导航栏
        setNavigationBar()
    }
    
    /**
     根据授权状态设置navigationBar
     */
    private func setNavigationBar() {
        
        if JFUserAccount.shareUserAccount.isAuth {
            // 加载navigationBar上的按钮和标题
            // 左边好友按钮
            let leftButton = UIButton(type: UIButtonType.Custom)
            navigationItem.leftBarButtonItem = UIBarButtonItem(button: leftButton, imageName: "navigationbar_friendattention", highlightedImageName: "navigationbar_friendattention_highlighted")
            leftButton.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
                return RACSignal.empty()
            })
            
            // 右边雷达按钮
            let rightButton = UIButton(type: UIButtonType.Custom)
            navigationItem.rightBarButtonItem = UIBarButtonItem(button: rightButton, imageName: "navigationbar_icon_radar", highlightedImageName: "navigationbar_icon_radar_highlighted")
            rightButton.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
                // 雷达下的控制器
//                let vc = JFPopViewController(style: UITableViewStyle.Grouped)
//                self.presentViewController(vc, animated: true, completion: nil)
                return RACSignal.empty()
            })
            
            // 自定义标题
            let titleButton = JFTitleButton(title: JFUserAccount.shareUserAccount.name!)
            navigationItem.titleView = titleButton
            titleButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext({ (button) -> Void in
                // 改变箭头方向
                titleButton.selected = !titleButton.selected
                // 标题下的控制器
//                let vc = JFPopViewController(style: UITableViewStyle.Grouped)
//                self.presentViewController(vc, animated: true, completion: nil)
            })
        } else {
            // 加载navigationBar上的注册和登陆
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "loadOAuthViewController")
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登陆", style: UIBarButtonItemStyle.Plain, target: self, action: "loadOAuthViewController")
        }
    }
    
    /**
     登陆、注册都调用这个方法，加载授权控制器
     */
    private func loadOAuthViewController() {
        // 加载授权控制器
        presentViewController(JFNavigationController(rootViewController: JFOAuthViewController()), animated: true, completion: nil)
    }
}

// MARK: - 数据源和代理
extension JFHomeViewController {
    
    /**
     加载微博数据
     */
    private func loadStatus() {
        SVProgressHUD.showWithStatus("正在加载数据", maskType: SVProgressHUDMaskType.Black)
        // [weak self]: 占有列表, 表示闭包里面用到的self是 weak引用的
        JFStatus.loadStatus { [weak self](list, error) -> () in
            
            // 加载失败
            if error != nil {
                SVProgressHUD.showErrorWithStatus("网络不给力", maskType: SVProgressHUDMaskType.Black)
                return
            }
            
            // 判断是否有数据
            if list == nil || list?.count == 0 {
                SVProgressHUD.showInfoWithStatus("没有新的微博", maskType: SVProgressHUDMaskType.Black)
            }
            
            // 隐藏HUD
            SVProgressHUD.dismiss()
            
            // 将加载好的数据赋值给微博数组属性
            self?.statuses = list
        }
    }
    
    // 第section组有多少行cell
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 第一个?表示statuses有值才返回statuses.count
        // ?? statuses == nil 时返回 0
        return statuses?.count ?? 0
    }
    
    // 创建每行cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 获取微博模型
        let status = statuses?[indexPath.row]
        
        // 创建可重用的cell
        let cell = tableView.dequeueReusableCellWithIdentifier(JFStatusCellIdentifier.cellId(status!), forIndexPath: indexPath) as! JFStatusCell
        
        // 设置cell数据
        cell.status = status
        
        return cell
    }
    
    // 选中某行cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消选中效果
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    // 返回cell行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 获取当前cell的微博模型
        let status = statuses![indexPath.row]
        
        // 先从模型里取，如果没有缓存再计算
        if let status = status.rowHeight {
            return status
        }
        
        // 获取当前cell
        let cell = tableView.dequeueReusableCellWithIdentifier(JFStatusCellIdentifier.cellId(status)) as! JFStatusCell
        
        // 调用cell对象方法，返回当前cell行高
        let rowHeight = cell.rowHeight(status)
        
        // 缓存cell高度
        status.rowHeight = rowHeight
        
        return rowHeight
        
    }
    
    
}

