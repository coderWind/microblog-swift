//
//  JFNetworkTool.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import AFNetworking

/// 网络回调闭包
typealias NetFinishedCallBack = ((result: [String: AnyObject]?, error: NSError?) -> ())

class JFNetworkTool: NSObject {
    
    /// AFN
    private var afnManager: AFHTTPSessionManager
    
    /// 创建单例
    static let shareNetworkTool: JFNetworkTool = JFNetworkTool()
    
    override init() {
        let baseUrl = NSURL(string: "https://api.weibo.com/")
        afnManager = AFHTTPSessionManager(baseURL: baseUrl)
        afnManager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/json", "text/javascript", "text/plain") as Set<NSObject>
        
        super.init()
    }
    
    /// MARK: - OAuth授权
    private let client_id = "3574168239"
    private let app_secret = "3f7cc901506fd3c1c3255a78398ed340"
    let redirect_uri = "https://api.weibo.com/oauth2/default.html"
    let grant_type = "authorization_code"
    
    /**
     获取授权的URL
     */
    func oauthUrl() -> NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        return NSURL(string: urlString)!
    }
    
    /**
     根据code加载access_token，并返回给调用者
     
     - parameter code:   code
     - parameter finish: 完成回调
     */
    func loadAccessToken(code: String, finish: NetFinishedCallBack) {
        
        // 请求参数
        let parameters = [
            "client_id" : client_id,
            "client_secret" : app_secret,
            "grant_type" : grant_type,
            "code" : code,
            "redirect_uri" : redirect_uri
        ]
        
        // 发送POST请求，获取access_token并返回给调用者
        afnManager.POST("https://api.weibo.com/oauth2/access_token", parameters: parameters, success: { (_, responseObject) -> Void in
            // 将结果传递给调用者
            finish(result: responseObject as? [String : AnyObject], error: nil)
            }) { (_, error) -> Void in
                // 将结果传递给调用者
                finish(result: nil, error: error)
        }
    }

    /**
    加载用户数据,负责获取数据.不处理数据
    
    - parameter finish: 完成回调
    */
    func loadUserInfo(finish: NetFinishedCallBack) {
        // 判断access token是否存在
        if JFUserAccount.shareUserAccount().access_token == nil {
            print("没有access_token")
            return
        }
        
        // 判断uid是否存在
        if JFUserAccount.shareUserAccount().uid == nil {
            print("没有uid")
            return
        }
        
        let urlString = "2/users/show.json"
        let params = ["access_token": JFUserAccount.shareUserAccount().access_token!, "uid": JFUserAccount.shareUserAccount().uid!]
        
        afnManager.GET(urlString, parameters: params, success: { (_, result) -> Void in
            
            finish(result: result as? [String: AnyObject], error: nil)
            }) { (_, error) -> Void in
                
                finish(result: nil, error: error)
        }
    }
    
    /**
     GET请求
     
     - parameter urlString:  URL字符串
     - parameter parameters: 参数字典
     - parameter finish:     完成回调
     */
    func requestGET(urlString: String, parameters: [String: AnyObject], finish: NetFinishedCallBack) {
        afnManager.GET(urlString, parameters: parameters, success: { (_, result) -> Void in
            // 将请求结果传给调用者
            finish(result: result as? [String: AnyObject], error: nil)
            
            }) { (_, error) -> Void in
                print("error = \(error)")
                finish(result: nil, error: error)
        }
    }
    
}