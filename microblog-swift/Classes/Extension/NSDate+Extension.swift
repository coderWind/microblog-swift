//
//  NSDate+Extension.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/1.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import Foundation

extension NSDate {
    
    /**
     将新浪日期转成系统日期 如:2015-05-24 04:12:00 +0000
     - parameter string: 新浪日期
     - returns: 系统日期
     */
    class func sinaDateToDate(string: String) -> NSDate? {
        // 创建datefromatter
        let df = NSDateFormatter()
        
        // 设置地区
        df.locale = NSLocale(localeIdentifier: "en")
        
        // 设置日期格式
        df.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        return df.dateFromString(string)
    }
    
    ///  返回日期描述字符串
    ///
    ///     格式如下
    ///     -   刚刚(一分钟内)
    ///     -   X分钟前(一小时内)
    ///     -   X小时前(当天)
    ///     -   昨天 HH:mm(昨天)
    ///     -   MM-dd HH:mm(一年内)
    ///     -   yyyy-MM-dd HH:mm(更早期)
    func dateDescription() -> String {
        
        // 在ios中处理日期使用calendar
        let calendar = NSCalendar.currentCalendar()
        
        // 判断是否是今天
        if calendar.isDateInToday(self) {
            
            // 获取self和当前日期相差的秒数
            let delta = Int(NSDate().timeIntervalSinceDate(self))
            
            if delta < 60 {
                return "刚刚"
            }
            
            if delta < 60 * 60 {
                return "\(delta / 60) 分钟前"
            }
            return "\(delta / 3600) 小时前"
        }
        
        var fmtString = "HH:mm"
        
        // 判断是否是昨天
        if calendar.isDateInYesterday(self) {
            
            fmtString = "昨天 \(fmtString)"
            
        } else {
            
            // 比较年份
            let result = calendar.compareDate(self, toDate: NSDate(), toUnitGranularity: NSCalendarUnit.Year)
            
            if result == NSComparisonResult.OrderedSame {
                
                // 同一年
                fmtString = "MM-dd \(fmtString)"
                
            } else {
                
                // 更早期
                fmtString = "yyyy-MM-dd \(fmtString)"
            }
        }
        
        // 创建NSDateFormatter
        let fmt = NSDateFormatter()
        
        fmt.locale = NSLocale(localeIdentifier: "en")
        fmt.dateFormat = fmtString
        
        return fmt.stringFromDate(self)
    }
}