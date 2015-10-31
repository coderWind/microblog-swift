//
//  JFUser.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFUser: NSObject {
    
    /// 用户UID
    var id: Int = 0
    
    /// 友好显示名称
    var name: String?
    
    /// 用户头衔地址 50 * 50
    var profile_image_url: String?
    
    // 计算型属性，返回用户头像URL
    var profileImageUrl: NSURL? {
        get {
            if let urlString = profile_image_url {
                return NSURL(string: urlString)
            }
            return nil
        }
    }
    
    /// 是否是微博认证用户， true 是
    var verified: Bool = false
    
    /// -1:没有认证  0:认证用户  2,3,5:企业认证  220:达人
    var verified_type: Int = -1
    
    // 计算型属性，返回认证类型图标
    var verifiedTypeImage: UIImage? {
        get {
            switch verified_type {
            case 0:
                return UIImage(named: "avatar_vip")
            case 2,3,5:
                return UIImage(named: "avatar_enterprise_vip")
            case 220:
                return UIImage(named: "avatar_grassroot")
            default:
                return nil
            }
        }
    }
    
    /// 会员等级 1-6
    var mbrank: Int = 0
    
    // 计算型属性，返回会员等级图标
    var mbrankImage: UIImage? {
        get {
            if mbrank > 0 && mbrank <= 6 {
                return UIImage(named: "common_icon_membership_level\(mbrank)")
            }
            return nil
        }
    }
    
    // 字典转模型
    init(dict: [String : AnyObject]) {
        super.init()
        
        // kvc赋值
        setValuesForKeysWithDictionary(dict)
    }
    
    // 字典中的key在模型中没有对应的属性时调用
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // 打印对象
    override var description: String {
        let properties = ["id", "name", "profile_image_url", "verified_type", "mbrank"]
        return "\n\tuser模型：\(dictionaryWithValuesForKeys(properties))"
    }
    
}
