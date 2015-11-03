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
import MJRefresh

/**
 cell重用标示符
 
 - NormalCell:  原创微博cell
 - ForwardCell: 转发微博cell
 */
enum JFStatusCellIdentifier: String {
    
    case NormalCell  = "NormalCell"
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
            
            // 初始化下拉刷新控件
            refreshControl = JFRefreshControl(frame: CGRectZero)
            
            // 刷新控件的值改变事件
            refreshControl?.rac_signalForControlEvents(UIControlEvents.ValueChanged).subscribeNext({ (_) -> Void in
                // 加载微博数据
                self.loadStatus()
            })
            
            // 手动触发刷新控件的值改变事件
            refreshControl?.sendActionsForControlEvents(UIControlEvents.ValueChanged)
            
            // 注册可重用的cell
            tableView.registerClass(JFStatusNormalCell.self, forCellReuseIdentifier: JFStatusCellIdentifier.NormalCell.rawValue)
            tableView.registerClass(JFStatusForwardCell.self, forCellReuseIdentifier: JFStatusCellIdentifier.ForwardCell.rawValue)
            
            // 去掉分割线
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            
            // 上拉控件
            tableView.tableFooterView = pullUpView
            
        }
        
    }
    
    /**
     显示下拉信息
     */
    private func showPullMessage(count: Int) {
        
        tipLabel.text = count == 0 ? "没有新的微博" : "加载了\(count)条微博"
        
        // 初始frame
        let srcFrame = tipLabel.frame
        
        // 动画显示、隐藏tipLabel
        UIView.animateWithDuration(0.75, animations: { () -> Void in
            self.tipLabel.frame.origin.y = self.navigationController!.navigationBar.frame.height
            }) { (_) -> Void in
                UIView.animateWithDuration(0.75, delay: 0.25, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
                    // 还原frame
                    self.tipLabel.frame = srcFrame
                    }, completion: nil)
        }
        
    }
    
    // MARK: - 懒加载控件
    /// 上拉菊花
    private lazy var pullUpView: UIActivityIndicatorView = {
        let indicator   = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        indicator.color = UIColor.grayColor()
        return indicator
    }()
    
    /// 提示Label
    private lazy var tipLabel: UILabel = {
        // Label高度
        let tipHeight = 44
        
        // 创建提示信息Label
        let label             = UILabel(frame: CGRect(x: 0, y: -20 - tipHeight, width: Int(kScreenW), height: tipHeight))
        label.backgroundColor = UIColor.orangeColor()
        label.textColor       = UIColor.whiteColor()
        label.font            = UIFont.systemFontOfSize(14)
        label.textAlignment   = NSTextAlignment.Center

        // 将提示信息Label 插入 导航条
        self.navigationController?.navigationBar.insertSubview(label, atIndex: 0)
        return label
    }()
    
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
        
        // 根据授权状态设置导航栏
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

        var since_id = statuses?.first?.id ?? 0
        var max_id = 0
        
        // 菊花在钻洞，表示正在上拉加载
        if pullUpView.isAnimating() {
            // 清空since_id
            since_id = 0
            
            // max_id 等于当前最小的微博id
            max_id = statuses?.last?.id ?? 0
        }
        
        JFStatus.loadStatus(since_id, max_id: max_id) { [weak self](list, error) -> () in
            
            // 停止刷新
            self?.refreshControl?.endRefreshing()
            self?.pullUpView.stopAnimating()
            
            // 加载失败
            if error != nil {
                JFProgressHUD.jf_showErrorWithStatus("网络不给力")
                return
            }
            
            // 获取返回的数据总数
            let count = list?.count ?? 0
            
            if since_id > 0 {
                
                // 提示下拉刷新了多少条数据
                self?.showPullMessage(count)
                
                // 下拉加载的数据拼接到已有的微博模型数组前面
                self?.statuses = list! + self!.statuses!
                
            } else if max_id > 0 {
                
                // 上拉加载的数据拼接到已有的微博模型数组后面
                self?.statuses = self!.statuses! + list!
            } else {
                
                self?.statuses = list
            }
            
            print(self?.statuses)

        }
    }
    
    /**
     第section组有多少行cell
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 第一个?表示statuses有值才返回statuses.count
        // ?? statuses == nil 时返回 0
        return statuses?.count ?? 0
    }
    
    /**
     创建每行cell
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // 获取微博模型
        let status = statuses?[indexPath.row]
        
        // 创建可重用的cell
        let cell = tableView.dequeueReusableCellWithIdentifier(JFStatusCellIdentifier.cellId(status!), forIndexPath: indexPath) as! JFStatusCell
        
        // 设置cell数据
        cell.status = status
        
        // 如果是最后一个cell，并且上拉没有动画。就上拉加载更多数据
        if indexPath.row == statuses!.count - 1 && !pullUpView.isAnimating() {
            // 上拉加载数据
            pullUpView.startAnimating()
            
            // 加载数据
            loadStatus()
        }
        
        return cell
    }
    
    /**
     选中某行cell
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消选中效果
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    
    /**
     返回cell行高
     */
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // 获取当前cell的微博模型
        let status = statuses![indexPath.row]
        
        // 先从模型里取，如果没有缓存再计算
        if let tempRowHeight = status.rowHeight {
            return tempRowHeight
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

