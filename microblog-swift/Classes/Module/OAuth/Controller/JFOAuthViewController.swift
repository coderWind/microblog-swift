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
        
        title = "新浪微博授权"
        
        // 加载授权界面
        webView.loadRequest(NSURLRequest(URL: JFNetworkTool.shareNetworkTool.oauthUrl()))
        
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
        // --------------------- 这里需要改改改，不然就不能自动填充 ----------------------------
        webView.stringByEvaluatingJavaScriptFromString("document.getElementById('userId').value = '你的微博账号';" + "document.getElementById('passwd').value = '你的微博密码';")
    }
    
    /**
     *  MARK: - UIWebViewDelegate
     */
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showWithStatus("加载授权界面", maskType: SVProgressHUDMaskType.Black)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    /**
     栏架webView的请求操作，跟踪重定向URL，是否要加载
     */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let urlString = request.URL!.absoluteString
        
        // 如果不包含回调前缀则说明不是回调地址，正常加载URL
        if !urlString.hasPrefix(JFNetworkTool.shareNetworkTool.redirect_uri) {
            return true
        }
        
        // 点击了取消或授权后
        if let query = request.URL?.query {
            let tempQuery = query as NSString
            let codeString = "code="
            
            if tempQuery.hasPrefix(codeString) {
                // 参数前缀是code=则表示点击了授权，截取code
                let code = tempQuery.substringFromIndex(codeString.characters.count)
                
                // 根据code获取access_token
                JFNetworkTool.shareNetworkTool.loadAccessToken(code, finish: { (result, error) -> () in
                    
                    if error != nil || result == nil {
                        self.netError("获取access_token失败")
                    } else {
                        // 保存用户信息（access_token）
                        JFUserAccount.shareUserAccount.saveUserAccount(result!)
                        
                        // 加载用户信息
                        JFUserAccount.shareUserAccount.loadUserInfo({ (error) -> () in
                            if error != nil {
                                self.netError("加载用户信息错误")
                            } else {
                                // 切换到欢迎控制器
                                UIApplication.sharedApplication().keyWindow?.rootViewController = JFWelcomeViewController()
                                self.cancelOAuth()
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
        SVProgressHUD.showErrorWithStatus(errorMessage, maskType: SVProgressHUDMaskType.Black)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.cancelOAuth()
        }
    }
    
    // MARK: - 懒加载
    lazy var webView: UIWebView = {
        let web = UIWebView()
        web.delegate = self
        return web
    }()
    
}
