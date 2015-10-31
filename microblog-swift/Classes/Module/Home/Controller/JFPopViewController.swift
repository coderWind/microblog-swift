//
//  JFPopViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/27.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFPopViewController: UITableViewController {
    
    var content: [String] = ["首页", "好友圈", "群微博", "我的微博", "新浪微博"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // 背景颜色
        view.backgroundColor = UIColor(red: 30/255.0, green: 32/255.0, blue: 40/255.0, alpha: 0.6)
        
        // 取消分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    
    }

}
