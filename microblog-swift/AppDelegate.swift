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
        setupKeyWindowOfRootViewController()
//        window?.rootViewController = JFWelcomeViewController()
        
        // 设置为主窗口并显示
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: - 设置主窗口的根控制器
    func setupKeyWindowOfRootViewController() {
        
        // 是否已经授权，授权成功才显示新特性（第一次安装应用不显示）
        if JFUserAccount.shareUserAccount.isAuth {
            // 版本key
            let versionKey = kCFBundleVersionKey as String
            
            // 获取当前应用版本号
            let currentVersion = NSBundle.mainBundle().infoDictionary![versionKey] as? String
            
            // 获取沙盒中的版本号
            let sandBoxVersion = NSUserDefaults.standardUserDefaults().valueForKey(versionKey) as? String
            
            if currentVersion != sandBoxVersion {
                // 不等于说明是新版本，或者是第一次运行呈现，加载新特性控制器
                self.window?.rootViewController = JFNewFeatureViewController()
                
                // 存储版本到沙盒
                NSUserDefaults.standardUserDefaults().setValue(currentVersion, forKey: versionKey)
                
            } else {
                
                // 版本相等则直接加载首页
                self.window?.rootViewController = JFWelcomeViewController()
            }
        } else {
            self.window?.rootViewController = JFTabBarViewController()
        }
        
    }
    
}

