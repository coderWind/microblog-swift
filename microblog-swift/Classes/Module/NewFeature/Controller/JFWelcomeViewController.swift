//
//  JFWelcomeViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/27.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import SDWebImage

class JFWelcomeViewController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 更新约束
        userIcon.snp_updateConstraints { (make) -> Void in
            make.bottom.equalTo(-(kScreenH - 160))
        }
        
        // 动画移动头像
        UIView.animateWithDuration(1.0, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            // 更新布局
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                // 动画渐变显示文字
                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    self.userName.alpha = 1
                    }, completion: { (_) -> Void in
                        // 进入主页
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
                            UIApplication.sharedApplication().keyWindow?.rootViewController = JFTabBarViewController()
                        }
                })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景颜色
        view.backgroundColor = UIColor(patternImage: UIImage(named: "new_background")!)
        
        // 添加头像
        view.addSubview(userIcon)
        // 添加名称
        view.addSubview(userName)
        
        // 约束头像
        userIcon.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width:100, height: 100))
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(-160)
        }
        
        // 约束用户名称
        userName.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(userIcon.snp_centerX)
            make.top.equalTo(userIcon.snp_bottom).offset(10)
        }
    
    }
    
    /// MARK: - 懒加载
    /// 用户头像
    lazy var userIcon: UIImageView = {
        let iconView = UIImageView()
        // 加载用户头像
        iconView.sd_setImageWithURL(NSURL(string: JFUserAccount.shareUserAccount.avatar_large!))
        iconView.layer.cornerRadius = 50
        iconView.clipsToBounds = true
        return iconView
    }()
    
    /// 用户名称
    lazy var userName: UILabel = {
        let name = UILabel()
        name.alpha = 0
        name.text = "欢迎回来!\(JFUserAccount.shareUserAccount.name!)"
        return name
    }()
    
    
}

