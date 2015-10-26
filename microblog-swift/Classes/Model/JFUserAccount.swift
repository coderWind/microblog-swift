//
//  JFUserAccount.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFUserAccount: NSObject {
    
    // 是否授权成功
    var isAuth: Bool {
        get {
            
            // 判断是否授权
            
            return false
        }
    }
    
    // 创建用户单例
    static func shareUserAccount() -> JFUserAccount {
        struct Singleton {
            static var onceToken: dispatch_once_t = 0
            static var single: JFUserAccount?
        }
        dispatch_once(&Singleton.onceToken){
            Singleton.single = shareUserAccount()
            
            // 加载沙盒用户账号信息
            
        }
        return Singleton.single!
    }
    
    private override init() {}

}
