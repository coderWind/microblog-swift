//
//  JFHomeVisitorView.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import ReactiveCocoa
import SnapKit

class JFHomeVisitorView: UIView {
    
    // 代理信号
    var delegateSignal: RACSubject?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 背景颜色
        backgroundColor = UIColor(white: 237 / 255, alpha: 1)
        
        // 准备UI
        prepareUI()
        
        // 开始旋转
        startRotationAnimation()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     开始旋转
     */
    private func startRotationAnimation() {
        // 创建动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = 2 * M_PI
        animation.duration = 20
        animation.repeatCount = MAXFLOAT
        // 如果不加切换控制器会退出后就停止动画了
        animation.removedOnCompletion = false
        rotateView.layer.addAnimation(animation, forKey: "homeAnimation")
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        print("访客视图")
        
        // 添加子控件
        addSubview(rotateView)
        addSubview(shadowView)
        addSubview(houseView)
        addSubview(tipLabel)
        addSubview(registerButton)
        addSubview(loginButton)

        // MARK: - 约束布局子控件
        // 转轮
        rotateView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.snp_center)
        }
 
        // 遮罩
        shadowView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(rotateView.snp_center)
        }

        // 房子
        houseView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(rotateView)
        }

        // 提示
        tipLabel.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(rotateView.snp_centerX)
            make.top.equalTo(rotateView.snp_bottom).offset(16)
            make.width.equalTo(240)
        }
        
        // 注册
        registerButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(tipLabel.snp_left)
            make.top.equalTo(tipLabel.snp_bottom).offset(32)
            make.size.equalTo(CGSizeMake(100, 30))
        }
        
        // 登录
        loginButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(tipLabel.snp_right)
            make.top.equalTo(tipLabel.snp_bottom).offset(32)
            make.size.equalTo(CGSizeMake(100, 30))
        }
        
        // 注册按钮点击事件
        registerButton.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            // 订阅者不为空就发送信号
            if self.delegateSignal != nil {
                self.delegateSignal?.sendNext(nil)
            }
            return RACSignal.empty()
        })
        
        // 登录按钮点击事件
        loginButton.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            // 订阅者不为空就发送信号
            if self.delegateSignal != nil {
                self.delegateSignal?.sendNext(nil)
            }
            return RACSignal.empty()
        })
        
        //MARK: - RAC通知
        // 进入后台
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIApplicationDidEnterBackgroundNotification, object: nil).subscribeNext({ (_) -> Void in
            
            // 记录暂停时间
            let pauseTime = self.rotateView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
            
            // 设置动画速度为0
            self.rotateView.layer.speed = 0
            // 设置动画偏移时间
            self.rotateView.layer.timeOffset = pauseTime
            
        })
        // 进入前台
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UIApplicationDidBecomeActiveNotification, object: nil).subscribeNext({ (_) -> Void in
            
            // 获取暂停时间
            let pauseTime = self.rotateView.layer.timeOffset
    
            // 设置动画速度为1
            self.rotateView.layer.speed = 1
            self.rotateView.layer.timeOffset = 0
            self.rotateView.layer.beginTime = 0
            let timeSincePause = self.rotateView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pauseTime
            self.rotateView.layer.beginTime = timeSincePause
        })
        
    }
    
    // MARK: - 懒加载
    /// 转轮图片
    private lazy var rotateView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.image = UIImage(named: "visitordiscover_feed_image_smallicon")
        
        return imageView
    }()
    
    /// 转轮遮罩
    private lazy var shadowView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.image = UIImage(named: "visitordiscover_feed_mask_smallicon")
        
        return imageView
    }()
    
    /// 首页小房子图片
    private lazy var houseView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.image = UIImage(named: "visitordiscover_feed_image_house")
        
        return imageView
    }()
    
    /// 提示文字
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.textColor = UIColor.lightGrayColor()
        label.text = "关注一些人，回这里看看有什么惊喜"
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(14)
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 注册按钮
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.sizeToFit()
        button.setTitle("注册", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        return button
    }()
    
    /// 登录按钮
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: UIButtonType.Custom)
        button.sizeToFit()
        button.setTitle("登录", forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        return button
    }()

}
