//
//  JFHomeViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFHomeViewController: UIViewController,JFhomeVisitorViewDelegate {

    /**
     MARK:- 视图声明周期类
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    /**
      根据登录状态加载不同的view
     */
    override func loadView() {
        
        if JFUserAccount.shareUserAccount().isAuth {
            // 已经授权就调用父类加载视图方法
            super.loadView()
        } else {
            // 未授权就加载访客视图
            let visitor = JFHomeVisitorView()
            visitor.delegate = self
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
    
    /**
    *  MARK: - JFhomeVisitorViewDelegate
    */
    func homeVisitorView(homeVisitorView: JFHomeVisitorView, didTappedRegisterButton registerButton: UIButton) {
        loadOAuthViewController()
    }
    
    func homeVisitorView(homeVisitorView: JFHomeVisitorView, didTappedLoginButton loginButton: UIButton) {
        loadOAuthViewController()
    }
}
