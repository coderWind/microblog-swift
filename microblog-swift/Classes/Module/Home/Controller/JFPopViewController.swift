//
//  JFPopViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/27.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFPopViewController: UIViewController {
    
    // MARK: - 属性
    var lists = [["首页", "好友圈", "群微博", "我的微博", "新浪微博"],
        ["特别关注", "网络好友", "我的推荐", "明星", "科技", "兄弟连", "舞蹈", "傻逼", "企业", "我的朋友", "名人明星", "悄悄关注"],
        ["周边微博"]
    ]
    
    // tableview重用标识符
    let popoverIdentifier = "popoverCell"

    // MARK: - 视图声明周期
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景颜色透明
        view.backgroundColor = UIColor.clearColor()
        
        // 注册cell
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: popoverIdentifier)

        // 准备UI
        prepareUI()
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 添加背景图片
        view.addSubview(backgroundView)
        view.addSubview(tableView)
        
        // 约束子控件
        backgroundView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(view.snp_edges)
        }
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsets(top: 15, left: 12, bottom: -12, right: -12))
        }
        
    }
    
    // MARK: - 懒加载
    // 背景图片
    lazy var backgroundView: UIImageView = {
        let imageView = UIImageView()
        var image = UIImage(named: "popover_background")!
        image = image.resizableImageWithCapInsets(UIEdgeInsets(top: image.size.height * 0.5, left: image.size.width * 0.5 - 100, bottom: image.size.height * 0.5, right: image.size.width * 0.5 - 100), resizingMode: UIImageResizingMode.Stretch)
        imageView.image = image
        return imageView
    }()
    
    // tableview
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

}

// MARK: - UITableViewDataSource、UITableViewDelegate数据源、代理
extension JFPopViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return lists.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(popoverIdentifier)!
        cell.textLabel?.text = lists[indexPath.section][indexPath.row]
        return cell
    }
    
}
