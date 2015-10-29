//
//  JFCenterViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/26.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import ReactiveCocoa

class JFCenterViewController: UIViewController {
    
    // 底部子控件
    var centerCloseButton: UIButton!
    var centerSeparator: UIView!
    var leftButton: UIButton!
    var rightCloseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 添加子控件
        prepareUI()
        
        // 背景颜色
        view.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.95)
        UIApplication.sharedApplication().keyWindow?.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 抖动效果
        for item in contentView.subviews {
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                item.transform = CGAffineTransformMakeTranslation(0, -150 )
                }, completion: { (_) -> Void in
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        item.transform = CGAffineTransformMakeTranslation(0, -130)
                    })
            })
        }
        
        
    }
    
    // MARK: - 添加所有子控件,准备UI
    func prepareUI() {
        
        // 添加中间视图区
        view.addSubview(contentView)
        
        // 添加logo
        view.addSubview(topLogo)
        
        // 添加底部关闭条
        view.addSubview(bottomBar)
        
        // 约束中间视图
        contentView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(view.snp_centerY)
            make.left.equalTo(0)
            make.size.equalTo(CGSize(width: kScreenW * 2, height: kScreenH * 0.4))
        }
        
        // 约束logo
        topLogo.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(contentView.snp_top).offset(-50)
        }
        
        // 约束底部关闭条
        bottomBar.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(40)
        }
        
        // 添加中间视图的子控件
        addContentSubviews()
        
        // 添加底部关闭条的子控件
        addBottomSubviews()
    }
    
    // MARK: - 懒加载
    // 中间视图
    lazy var contentView: UIView = {
        let content = UIView()
        return content
    }()
    
    // logo
    lazy var topLogo: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "compose_slogan"))
        return logo
    }()
    
    // 底部关闭条
    lazy var bottomBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.whiteColor()
        
        return bar
    }()
    
}

// MARK: - 中间内容视图区域的控件管理
extension JFCenterViewController {
    
    /**
     添加底部关闭条的按钮
     */
    func addBottomSubviews() {
        
        // 中间关闭按钮
        centerCloseButton = UIButton(type: UIButtonType.Custom)
        centerCloseButton.sizeToFit()
        centerCloseButton.setImage(UIImage(named: "tabbar_compose_background_icon_close"), forState: UIControlState.Normal)
        bottomBar.addSubview(centerCloseButton)
        centerCloseButton.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(bottomBar.snp_center)
        }
        centerCloseButton.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            self.dismissViewControllerAnimated(true, completion: nil)
            return RACSignal.empty()
        })
        
        // 像左按钮
        leftButton = UIButton(type: UIButtonType.Custom)
        leftButton.hidden = true
        leftButton.sizeToFit()
        leftButton.setImage(UIImage(named: "tabbar_compose_background_icon_return"), forState: UIControlState.Normal)
        bottomBar.addSubview(leftButton)
        leftButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(70)
            make.centerY.equalTo(bottomBar.snp_centerY)
        }
        leftButton.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            // 调用手势方法，返回到左边视图
            self.didSwipeedScreen()
            return RACSignal.empty()
        })
        
        // 中间分割线
        centerSeparator = UIView()
        centerSeparator.hidden = true
        centerSeparator.backgroundColor = UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 0.8)
        bottomBar.addSubview(centerSeparator)
        centerSeparator.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(bottomBar.snp_centerX)
            make.height.equalTo(bottomBar.snp_height)
            make.top.equalTo(0)
            make.width.equalTo(1)
        }
        
        // 右边的关闭按钮
        rightCloseButton = UIButton(type: UIButtonType.Custom)
        rightCloseButton.hidden = true
        rightCloseButton.sizeToFit()
        rightCloseButton.setImage(UIImage(named: "tabbar_compose_background_icon_close"), forState: UIControlState.Normal)
        bottomBar.addSubview(rightCloseButton)
        rightCloseButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-70)
            make.centerY.equalTo(bottomBar.snp_centerY)
        }
        rightCloseButton.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            self.dismissViewControllerAnimated(true, completion: nil)
            return RACSignal.empty()
        })
        
    }
    
    /**
     添加中间视图的子控件
     */
    func addContentSubviews() {
        
        // 文字
        let text = setupItemButton("文字", imageName: "tabbar_compose_idea")
        text.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            self.presentViewController(JFNavigationController(rootViewController: JFComposeViewController()), animated: true, completion: nil)
            return RACSignal.empty()
        })
        
        // 相册
        let album = setupItemButton("相册", imageName: "tabbar_compose_photo")
        album.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            
            
            return RACSignal.empty()
        })
        
        // 长微博
        let longMicroblog = setupItemButton("长微博", imageName: "tabbar_compose_weibo")
        longMicroblog.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            
            
            return RACSignal.empty()
        })
        
        // 好友圈
        let goodFriendCircle = setupItemButton("好友圈", imageName: "tabbar_compose_friend")
        goodFriendCircle.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            
            
            return RACSignal.empty()
        })
        
        // 微博相机
        let microblogCamera = setupItemButton("微博相机", imageName: "tabbar_compose_wbcamera")
        microblogCamera.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            
            
            return RACSignal.empty()
        })
        
        // 音乐
        let music = setupItemButton("音乐", imageName: "tabbar_compose_music")
        music.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            
            
            return RACSignal.empty()
        })
        
        // 签到
        let sign = setupItemButton("签到", imageName: "tabbar_compose_lbs")
        sign.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            
            
            return RACSignal.empty()
        })
        
        // 点评
        let conment = setupItemButton("点评", imageName: "tabbar_compose_review")
        conment.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            
            
            return RACSignal.empty()
        })
        
        // 更多
        let more = setupItemButton("更多", imageName: "tabbar_compose_more")
        more.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            // 点击更多后动画，右移视图
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                // 形变
                self.contentView.transform = CGAffineTransformMakeTranslation(-kScreenW, 0)
                // 修改底部子控件隐藏状态
                self.leftButton.hidden = false
                self.rightCloseButton.hidden = false
                self.centerCloseButton.hidden = true
                self.centerSeparator.hidden = false
            })
            
            // 添加全屏侧滑手势，左移视图
            let swipe = UISwipeGestureRecognizer(target: self, action: "didSwipeedScreen")
            swipe.direction = UISwipeGestureRecognizerDirection.Right
            self.view.addGestureRecognizer(swipe)
            
            return RACSignal.empty()
        })
        
        // 拍摄
        let takePicture = setupItemButton("拍摄", imageName: "tabbar_compose_camera")
        takePicture.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            
            
            return RACSignal.empty()
        })
        
        // 商品
        let goods = setupItemButton("商品", imageName: "tabbar_compose_envelope")
        goods.rac_command = RACCommand(signalBlock: { (_) -> RACSignal! in
            
            
            return RACSignal.empty()
        })
        
        // 布局
        // 每行六个
        let rowCount = 6
        let itemWidth = Int(kScreenW / 3)
        let itemHeight = Int(kScreenH * 0.4 * 0.5)
        // 遍历中间内容视图的子控件并布局
        for item in contentView.subviews {
            let itemLeft = Int(item.tag) % rowCount * itemWidth
            let itemTop = Int(item.tag) / rowCount * itemHeight + 150
            item.snp_makeConstraints(closure: { (make) -> Void in
                make.size.equalTo(CGSize(width: itemWidth, height: itemHeight))
                make.left.equalTo(itemLeft)
                make.top.equalTo(itemTop)
            })
        }
        
    }
    
    /**
     全屏侧滑手势
     */
    func didSwipeedScreen() {
        
        // 点击更多后动画，右移视图
        UIView.animateWithDuration(0.5) { () -> Void in
            // 形变
            self.contentView.transform = CGAffineTransformMakeTranslation(0, 0)
            // 修改底部子控件隐藏状态
            self.leftButton.hidden = true
            self.rightCloseButton.hidden = true
            self.centerCloseButton.hidden = false
            self.centerSeparator.hidden = true
        }
    }
    
    /**
     配置单个按钮
     
     - parameter title:     按钮标题
     - parameter imageName: 按钮图片名称
     
     - returns: 返回配置好的按钮
     */
    func setupItemButton(title: String, imageName: String) -> JFItemButton {
        let itemButton = JFItemButton(type: UIButtonType.Custom)
        itemButton.tag = contentView.subviews.count
        itemButton.titleLabel?.textAlignment = NSTextAlignment.Center
        itemButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        itemButton.setTitle(title, forState: UIControlState.Normal)
        itemButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        contentView.addSubview(itemButton)
        return itemButton
    }
    
    /**
     拦截系统dismissViewControllerAnimated方法
     */
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            for item in self.contentView.subviews {
                item.transform = CGAffineTransformMakeTranslation(0, 500)
            }
            }) { (_) -> Void in
                super.dismissViewControllerAnimated(false, completion: completion)
        }

    }
    
}
