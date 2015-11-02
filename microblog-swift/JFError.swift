//
//  JFError.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/30.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import Foundation

// MARK: - 自定义网络请求错误枚举
enum JFNetworkError: Int {
    
    // 空token
    case emptyToken = -1
    
    // 空uid
    case emptyUid = -2
    

    // 错误描述
    var errorDescription: String {
        switch self {
        case .emptyToken:
            return "token 为空"
        case .emptyUid:
            return "uid 为空"
        }
    }
    
    // 返回 NSError 对象
    func error() -> NSError {
        return NSError(domain: "cn.itcast.error.network", code: rawValue, userInfo: ["errorDescription" : errorDescription])
    }
}