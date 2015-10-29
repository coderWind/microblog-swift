//
//  JFUserAccount.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

/// 保存用户信息的文件
let filePath = "\(kSandDocumentPath)/userAccount.data"

class JFUserAccount: NSObject, NSCoding {
    
    /// 用户名称
    var name: String?
    /// 用户头像地址 180 * 180
    var avatar_large: String?
    /// 用户access token
    var access_token: String?
    ///
    var remind_in: String?
    /// 用户uid
    var uid: String?
    // 过期日期
    var expiresDate: NSDate?
    // 基本数据类型不能定义可选
    var expires_in: NSTimeInterval = 0 {
        didSet {
            self.expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    // 是否授权成功
    var isAuth: Bool {
        get {
            // 判断是否授权成功
            if access_token != nil {
                return true
            } else {
                return false
            }
        }
    }
    
    /// 用户账号单例对象
    static let shareUserAccount: JFUserAccount = {
        // 从沙盒加载用户账号信息
        var userAccount = JFUserAccount()
        if let account = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) {
            // 判断账号是否过期
            if account.expiresDate!?.compare(NSDate()) ==  NSComparisonResult.OrderedDescending {
                print("加载到账户信息")
                userAccount = account as! JFUserAccount
            }
        }
        return userAccount
    }()
    
    // 防止外界初始化
    private override init() {}
    
    // 当字典的key在模型中没有对应的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // MARK: - 保存用户信息到沙盒
    /**
     保存用户信息到沙盒
     - parameter userAccount: 存储用户信息的字典
     */
    func saveUserAccount(userAccount: [String : AnyObject]) {
        // kvc 为单例对象赋值
        JFUserAccount.shareUserAccount.setValuesForKeysWithDictionary(userAccount)
        
        // 保存信息到指定文件
        if NSKeyedArchiver.archiveRootObject(self, toFile: filePath) {
            print("保存账号信息成功")
        } else {
            print("保存账号信息失败")
        }
    }
    
    // MARK: - 加载用户信息
    /// 加载用户信息
    func loadUserInfo(finish: ((error: NSError?) -> ())) {
        
        JFNetworkTool.shareNetworkTool.loadUserInfo { (result, error) -> () in
            
            // 如果加载用户信息失败就退出
            if error != nil || result == nil {
                finish(error: error)
                return
            }
            
            // 给用户信息对象属性赋值
            self.name = result!["name"] as? String
            self.avatar_large = result!["avatar_large"] as? String
            
            // 重新保存用户信息
            NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
            
            finish(error: nil)
        }
    }
    
    /**
    *  归档、解档
    */
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(expiresDate, forKey: "expiresDate")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
    }
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        expiresDate = aDecoder.decodeObjectForKey("expiresDate") as? NSDate
        uid = aDecoder.decodeObjectForKey("uid") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
    /// 打印对象时调用这个方法
    override var description: String {
        return "access_token=\(access_token),expires_in=\(expires_in),expiresDate=\(expiresDate),uid=\(uid),name=\(name),avatar_large=\(avatar_large)"
    }
    
}
