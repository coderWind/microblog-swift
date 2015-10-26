//
//  JFOAuthViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import SVProgressHUD

class JFOAuthViewController: UIViewController, UIWebViewDelegate {
    
    lazy var webView: UIWebView = {
        let web = UIWebView()
        web.delegate = self
        return web
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "新浪微博授权"
        
        // 加载授权界面
        webView.loadRequest(NSURLRequest(URL: JFNetworkTool.shareNetworkTool.oauthUrl()))
        
        
    }
    
    // 替换控制器的view
    override func loadView() {
        view = webView
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: "cancelOAuth")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充密码", style: UIBarButtonItemStyle.Done, target: self, action: "autoFillUsernameAndPassword")
    }
    
    /**
     取消授权操作，返回主页
     */
    func cancelOAuth() {
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     自动填充用户名和密码
     */
    func autoFillUsernameAndPassword() {
        
    }
    
    /**
    *  MARK: - UIWebViewDelegate
    */
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    /**
     栏架webView的请求操作，跟踪重定向URL，是否要加载
     */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {

        let urlString = request.URL!.absoluteString
        
        // 如果不包含回调前缀则说明不是回调地址，加载URL
        if !urlString.hasPrefix(JFNetworkTool.shareNetworkTool.redirect_uri) {
            return true
        }
        
        // 判断后面是否跟有参数
        if let query = request.URL?.query {
//            code=cbf7002e420f3a8697cbec8536eb83a3
            let tempQuery = query as NSString
            let codeString = "code="
            
            if tempQuery.hasPrefix(codeString) {
                // 点击了授权
                let code = tempQuery.substringFromIndex(codeString.characters.count)
                
                // 根据code获取access_token
                JFNetworkTool.shareNetworkTool.loadAccessToken(code, finish: { (result, error) -> () in
                    
                    if result == nil || error != nil {
                        SVProgressHUD.showErrorWithStatus("授权失败")
                        dispatch_after(1, dispatch_get_main_queue(), { () -> Void in
                            // 这里没有处理。。。。。。。。。。。。。。。
                            self.cancelOAuth()
                            return
                        })
                    } else {
                        // 保存用户信息（access_token）
                        JFUserAccount.shareUserAccount().saveUserAccount(result!)
                        
                        JFUserAccount.shareUserAccount().loadUserInfo({ (error) -> () in
                            if error != nil {
                                self.netError()
                                return
                            }
                        })
                        // 切换到欢迎控制器
                        UIApplication.sharedApplication().keyWindow?.rootViewController = JFWelcomeViewController()
                        self.cancelOAuth()
                    }
                    
                })
                
                return false
                
            } else {
                // 点击了取消
                cancelOAuth()
                
                return false
            }
        }
        
        return true
    }
    
    /// 网络数据加载出错.提示
    private func netError() {
        SVProgressHUD.showErrorWithStatus("您的网络不给力")
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
            self.cancelOAuth()
        })
    }

}
