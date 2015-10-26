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
        }
    }
    
    /**
    *  MARK: - JFhomeVisitorViewDelegate
    */
    func homeVisitorView(homeVisitorView: JFHomeVisitorView, didTappedRegisterButton registerButton: UIButton) {
        print("didTappedRegisterButton")
    }
    
    func homeVisitorView(homeVisitorView: JFHomeVisitorView, didTappedLoginButton loginButton: UIButton) {
        print("didTappedLoginButton")
    }
}
