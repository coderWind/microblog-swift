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
    
    var access_token: String?
    var remind_in: String?
    var uid: String?
    // 过期时间
    var expiresDate: NSDate?
    var expires_in: NSTimeInterval = 0 {
        didSet {
            self.expiresDate = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    
    // 当字典的key在模型中没有对应的属性
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
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
    
    // 创建用户单例对象
    static func shareUserAccount() -> JFUserAccount {
        struct Singleton {
            static var onceToken: dispatch_once_t = 0
            static var single: JFUserAccount?
        }
        dispatch_once(&Singleton.onceToken,{
            Singleton.single = JFUserAccount()
            
            // 从沙盒加载用户账号信息
            let userAccount = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath)
            if let account = userAccount {
                
                if account.expiresDate?!.compare(NSDate()) ==  NSComparisonResult.OrderedDescending {
                    print("加载到账户信息")
                    Singleton.single = account as? JFUserAccount
                }
                
            } else {
                print("加载沙盒用户数据失败")
            }
            
        })
        return Singleton.single!
    }
    // 防止外界初始化
    private override init() {}
    
    // MARK: - 加载用户信息
    /// 加载用户信息,负责处理数据
    func loadUserInfo(finish: ((error: NSError?) -> ())) {
        JFNetworkTool.shareNetworkTool.loadUserInfo { (result, error) -> () in
            if error != nil || result == nil {
                finish(error: error)
                return
            }
            
            self.name = result!["name"] as? String
            self.avatar_large = result!["avatar_large"] as? String
            
            // 保存信息
            NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
            
            finish(error: nil)
        }
    }
    
    /**
     保存用户信息到沙盒
     
     - parameter userAccount: 存储用户信息的字典
     */
    func saveUserAccount(userAccount: [String : AnyObject]) {
        // kvc 为单例对象赋值
        JFUserAccount.shareUserAccount().setValuesForKeysWithDictionary(userAccount)
        
        // 保存信息到指定文件
        if NSKeyedArchiver.archiveRootObject(self, toFile: filePath) {
            print("保存账号信息成功")
        } else {
            print("保存账号信息失败")
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
    
}
