//
//  JFCommon.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

// 屏幕的bounds
let kScreenBounds = UIScreen.mainScreen().bounds

// 屏幕宽度
let kScreenW = kScreenBounds.size.width

// 屏幕高度
let kScreenH = kScreenBounds.size.height

// tabBar渲染颜色
let kOrangeColor = UIColor.orangeColor()

// 沙盒文档路径
let kSandDocumentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last!

// 保存用户信息的路径
let filePath = "\(kSandDocumentPath)/userAccount.data"

// 微博cell各种边距
let statusMargin: CGFloat = 12