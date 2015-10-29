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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景颜色
        view.backgroundColor = UIColor.whiteColor()
        
        // 添加头像
        view.addSubview(userIcon)
        // 添加名称
        view.addSubview(userName)
        
        // 约束头像
        userIcon.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width:100, height: 100))
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(80)
        }
        
        // 约束用户名称
        userName.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(userIcon.snp_bottom).offset(80)
        }
        
        // 添加动画
        let animation = CAKeyframeAnimation(keyPath: "position")
        let value1 = NSValue(CGPoint: CGPoint(x: kScreenW * 0.5, y: 80))
        let value2 = NSValue(CGPoint: CGPoint(x: kScreenW * 0.5, y: 250))
        animation.values = [value1, value2]
        animation.duration = 2
        animation.autoreverses = true
        animation.removedOnCompletion = false
        userIcon.layer.addAnimation(animation, forKey: "animation")
        
        // 进入主页
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            UIApplication.sharedApplication().keyWindow?.rootViewController = JFTabBarViewController()
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
        name.text = JFUserAccount.shareUserAccount.name
        return name
    }()
    
    
}

