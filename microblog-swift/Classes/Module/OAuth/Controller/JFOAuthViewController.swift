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
    
    // 替换控制器的view
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航标题
        title = "新浪微博授权"
        
        // 加载授权界面
        webView.loadRequest(NSURLRequest(URL: JFNetworkTool.shareNetworkTool.oauthUrl()))
        
        // 设置导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: "cancelOAuth")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充密码", style: UIBarButtonItemStyle.Done, target: self, action: "autoFillUsernameAndPassword")
        
    }
    
    /**
     取消授权操作，返回主页
     */
    func cancelOAuth() {
        JFProgressHUD.jf_dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     自动填充用户名和密码
     */
    func autoFillUsernameAndPassword() {
        // --------------------- 这里需要改改改，不然就不能自动填充 ----------------------------
        webView.stringByEvaluatingJavaScriptFromString("document.getElementById('userId').value = '你的微博账号';" + "document.getElementById('passwd').value = '你的微博密码';")
    }
    
    // MARK: - UIWebViewDelegate
    /**
    开始加载
    */
    func webViewDidStartLoad(webView: UIWebView) {
        JFProgressHUD.jf_showWithStatus("正在加载")
    }
    
    /**
     加载完成
     */
    func webViewDidFinishLoad(webView: UIWebView) {
        JFProgressHUD.jf_dismiss()
    }
    
    /**
     栏架webView的请求操作，跟踪重定向URL，是否要加载
     */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 获取完整请求URL字符串
        let urlString = request.URL!.absoluteString
        
        // 判断前缀，如果不包含回调前缀则说明不是回调地址，正常加载请求
        if !urlString.hasPrefix(JFNetworkTool.shareNetworkTool.redirect_uri) {
            return true
        }
        
        // 点击了取消或授权后
        if let query = request.URL?.query {
            
            // 将请求参数转为 NSString
            let tempQuery = query as NSString
            
            // 点击授权后的固定前缀是 code=
            let codeString = "code="
            
            if tempQuery.hasPrefix(codeString) {
                
                // 参数前缀是 code= 则表示点击了授权，截取code
                let code = tempQuery.substringFromIndex(codeString.characters.count)
                
                // 根据 code 获取 access_token
                JFNetworkTool.shareNetworkTool.loadAccessToken(code, finished: { (result, error) -> () in
                    
                    if error != nil || result == nil {
                        self.netError("授权失败")
                    } else {
                        
                        // 保存用户信息 access_token
                        JFUserAccount.shareUserAccount.saveUserAccount(result!)
                        
                        // 加载用户信息
                        JFUserAccount.shareUserAccount.loadUserInfo({ (error) -> () in
                            
                            if error != nil {
                                self.netError("加载用户信息失败")
                            } else {
                                
                                // 关闭控制器
                                self.cancelOAuth()
                                
                                // 切换到欢迎控制器
                                UIApplication.sharedApplication().keyWindow?.rootViewController = JFWelcomeViewController()
                            }
                        })
                    }
                })
                
            } else {
                // 点击了取消
                cancelOAuth()
            }
        }
        return false
    }
    
    /**
     网络数据加载出错时提示
     */
    private func netError(errorMessage: String) {
        JFProgressHUD.jf_showErrorWithStatus(errorMessage)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.cancelOAuth()
        }
    }
    
    // MARK: - 懒加载
    private lazy var webView: UIWebView = {
        let web = UIWebView()
        web.delegate = self
        return web
    }()
    
}
