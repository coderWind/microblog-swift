//
//  JFProgressHUD.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/1.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import SVProgressHUD

/// 隔离SVProgressHUD
class JFProgressHUD: SVProgressHUD {
    
    /**
     显示错误提示
     
     - parameter string: 错误提示文字
     */
    class func jf_showErrorWithStatus(string: String!) {
        SVProgressHUD.showErrorWithStatus(string, maskType: SVProgressHUDMaskType.Black)
    }

    /**
     显示提示信息
     
     - parameter status: 需要显示的信息文字
     */
    class func jf_showWithStatus(status: String!) {
        SVProgressHUD.showWithStatus("status", maskType: SVProgressHUDMaskType.Black)
    }
    
    /**
     隐藏提示信息
     */
    class func jf_dismiss() {
        SVProgressHUD.dismiss()
    }
    
}
