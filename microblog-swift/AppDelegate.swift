//
//  AppDelegate.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/25.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置全局样式
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        // 创建window
        window = UIWindow(frame: kScreenBounds)
        
        // 设置window的根控制器
        defaultViewController()
        
        // 设置为主窗口并显示
        window?.makeKeyAndVisible()
        
        return true
    }
    
    /**
     设置主窗口的根控制器
     */
    func defaultViewController() {
        
        // 是否已经授权
        if JFUserAccount.shareUserAccount.isAuth {
            // 能进说明已经授权，再继续判断是否是新版本
            self.window?.rootViewController = isNewVersion() ? JFNewFeatureViewController() : JFWelcomeViewController()
        } else {
            // 没有授权则加载 主控制器
            self.window?.rootViewController = JFTabBarViewController()
        }
        
    }
    
    /**
     是否是新版本
     
     - returns: 返回true则表示当前版本是新版本
     */
    func isNewVersion() -> Bool {
        
        // 版本key
        let versionKey = kCFBundleVersionKey as String
        
        // 获取当前应用版本号
        let currentVersion = NSBundle.mainBundle().infoDictionary![versionKey] as? String
        
        // 获取沙盒中的版本号
        let sandBoxVersion = NSUserDefaults.standardUserDefaults().valueForKey(versionKey) as? String
        
        // 存储当前版本到沙盒
        NSUserDefaults.standardUserDefaults().setValue(currentVersion, forKey: versionKey)
        
        return currentVersion > sandBoxVersion
    }
    
}

