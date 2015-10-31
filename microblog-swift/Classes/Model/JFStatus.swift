//
//  JFStatus.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFStatus: NSObject {
    
    // 转发微博
    var retweeted_status: JFStatus?
    
    /// 缓存cell行高
    var rowHeight: CGFloat?
    
    /// 用户模型
    var user: JFUser?
    
    /// 微博创建时间
    var created_at: String?
    /// 微博ID
    var id: Int = 0
    /// 微博信息内容
    var text: String?
    /// 微博来源
    var source: String?
    
    /// 图片地址数组
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            // 判断pic_urls 是否有值,没有值直接返回
            let count = pic_urls?.count ?? 0
            if count == 0 {
                return
            }
            
            // 有值,遍历将pic_urls 里的string转成NSURL存放在pictureURLs数组里面
            storePictureURLs = [NSURL]()
            
            for dict in pic_urls! {
                // 取出 字典中的值
                let value = dict["thumbnail_pic"] as! String
                storePictureURLs?.append(NSURL(string: value)!)
            }
        }
    }
    
    // 存储原创微博对应的pic_urls里面对象的URL
    var storePictureURLs: [NSURL]?
    
    /// 存储型属性,存储的是pic_urls里面对应的URL
    var pictureURLs: [NSURL]? {
        return retweeted_status == nil ? storePictureURLs : retweeted_status?.storePictureURLs
    }
    
    // 重写构造方法，为属性赋值
    init(dict: [String : AnyObject]) {
        super.init()
        
        // kvc赋值
        setValuesForKeysWithDictionary(dict)
    }
    
    // 处理字典的key与模型属性不对应问题
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // 在kvc字典转模型时，user属性特殊处理
    override func setValue(value: AnyObject?, forKey key: String) {
        
        // 如果是user属性
        if key == "user" {
            if let dict = value as? [String : AnyObject] {
                // 字典转模型
                user = JFUser(dict: dict)
            }
            return
        }
        
        // 如果设置retweeted_status属性，先转模型再赋值
        if key == "retweeted_status" {
            if let dict = value as? [String : AnyObject] {
                retweeted_status = JFStatus(dict: dict)
            }
            return
        }
        
        // 调用父类方法
        super.setValue(value, forKey: key)
    }
    
    /**
     加载微博数据并转模型
     
     - parameter finished: 完成回调
     - parameter list: 模型数组
     - parameter error: 错误
     */
    class func loadStatus(finished: (list: [JFStatus]?, error: NSError?) -> ()) {
        JFNetworkTool.shareNetworkTool.loadStatus { (result, error) -> () in
            // 判断是否有错误
            if error != nil {
                print("加载微博数据出错:\(error!)")
            }
            
            // 获取返回数据里的微博数据
            if let array = result?["statuses"] as? [[String : AnyObject]] {
                
                // 创建模型数组
                var list = [JFStatus]()
                
                for dict in array {
                    // 字典转模型并添加到模型数组中
                    list.append(JFStatus(dict: dict))
                }
                
                // 回调数据
                finished(list: list, error: nil)
            } else {
                // 没有加载到数据
                finished(list: nil, error: nil)
            }
        }
    }
    
    // 重写打印方法，用于调试
    override var description: String {
        let properties = ["created_at", "id", "text", "source", "pic_urls", "user"]
        return "微博模型:\n\t\(dictionaryWithValuesForKeys(properties))"
    }
    
}
