//
//  JFError.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/30.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import Foundation

// MARK: - 自定义网络错误枚举
enum JFNetworkError: Int {
    
    // 空token
    case emptyToken = -1
    
    // 空uid
    case emptyUid = -2
    
    // 枚举可以定义属性
    var errorDescription: String {
        // 根据不同类型,返回不同的值
        switch self {
        case .emptyToken:
            return "token 为空"
        case .emptyUid:
            return "uid 为空"
        }
    }
    
    // 枚举可以定义方法
    // 返回根据当前枚举返回错误对象
    func error() -> NSError {
        return NSError(domain: "cn.itcast.error.network", code: rawValue, userInfo: ["errorDescription" : errorDescription])
    }
}