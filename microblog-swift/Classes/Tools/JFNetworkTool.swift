//
//  JFNetworkTool.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import AFNetworking

/// 网络回调闭包别名
typealias NetFinishedCallBack = ((result: [String : AnyObject]?, error: NSError?) -> ())

// MARK: - 网络工具类
class JFNetworkTool: NSObject {
    
    /// 创建网络请求单例
    static let shareNetworkTool = JFNetworkTool()
    
    /// AFN网络请求对象
    private var afnManager: AFHTTPSessionManager
    
    /**
     重写初始化方法
     */
    override init() {
        afnManager = AFHTTPSessionManager(baseURL: NSURL(string: "https://api.weibo.com"))
        afnManager.responseSerializer.acceptableContentTypes?.insert("text/plain")
    }
    
    // MARK: - OAuth授权信息
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
    
}

// MARK: - 发送网络请求
extension JFNetworkTool {
    
    /**
     根据code加载access_token，并返回给调用者
     
     - parameter code:   code码
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
        requestPOST("oauth2/access_token", parameters: parameters, finish: finish)
    }
    
    /**
     加载用户数据,负责获取数据,不处理数据
     
     - parameter finish: 完成回调
     */
    func loadUserInfo(finish: NetFinishedCallBack) {
        
        // 判断access_token和uid是否已经存在
        if JFUserAccount.shareUserAccount.access_token == nil || JFUserAccount.shareUserAccount.uid == nil {
            // 不存在就不继续执行
            return
        }
        
        let urlString = "2/users/show.json"
        let params = ["access_token": JFUserAccount.shareUserAccount.access_token!, "uid": JFUserAccount.shareUserAccount.uid!]
        
        // 发送get请求，加载用户数据
        requestGET(urlString, parameters: params, finish: finish)
    }
}

// MARK: - 封装GET、POST请求
extension JFNetworkTool {
    
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
                finish(result: nil, error: error)
        }
    }
    
    /**
     POST请求
     
     - parameter urlString:  URL字符串
     - parameter parameters: 参数字典
     - parameter finish:     完成回调
     */
    func requestPOST(urlString: String, parameters: [String: AnyObject], finish: NetFinishedCallBack) {
        afnManager.GET(urlString, parameters: parameters, success: { (_, result) -> Void in
            // 将请求结果传给调用者
            finish(result: result as? [String: AnyObject], error: nil)
            }) { (_, error) -> Void in
                finish(result: nil, error: error)
        }
    }
}