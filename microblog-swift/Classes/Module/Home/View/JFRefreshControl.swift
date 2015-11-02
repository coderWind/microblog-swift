//
//  JFRefreshControl.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/2.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFRefreshControl: UIRefreshControl {
    
    // 是否正在旋转
    private var rotateFlag = false

    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 隐藏菊花
        tintColor = UIColor.clearColor()
        
        // 准备UI
        prepareUI()
    }
    
    // 覆盖父类frame属性
    override var frame: CGRect {
        didSet {
            
            if frame.origin.y > 0 {
                return
            }
            
            // 判断是否正在刷新
            if refreshing {
                // 开始刷新动画
                startLoading()
            }
            
            if frame.origin.y < -60 && !rotateFlag {
                rotateFlag = true
                rotateStartRefreshView(rotateFlag)
            } else if frame.origin.y > -60 && rotateFlag {
                rotateFlag = false
                rotateStartRefreshView(rotateFlag)
            }
        }
    }
    
    /**
     开始刷新动画
     */
    func rotateStartRefreshView(rotationFlag: Bool) {
        UIView.animateWithDuration(0.25) { () -> Void in
            // 箭头旋转
            self.pullRefreshView.transform = rotationFlag ? CGAffineTransformMakeRotation(CGFloat(M_PI - 0.01)) : CGAffineTransformIdentity
        }
    }
    
    /**
     开始加载动画
     */
    func startLoading() {
        
        // 隐藏pullBgView
        pullBgView.hidden = true
        
        // 动画的key
        let animationKey = "loadingAnimation"
        
        // 正在执行动画就直接返回
        if let _ = startRefreshView.layer.animationForKey(animationKey) {
            return
        }
        
        // 创建动画
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = M_PI * 2
        animation.duration = 0.5
        animation.repeatCount = MAXFLOAT
        animation.removedOnCompletion = false
        
        // 添加动画
        startRefreshView.layer.addAnimation(animation, forKey: animationKey)
    }
    
    /**
     停止动画
     */
    func stopLoading() {
        
        // 取消隐藏
        pullBgView.hidden = false
        
        // 移除动画
        startRefreshView.layer.removeAllAnimations()
    }
    
    /**
     重写父类停止结束刷新方法，停止动画
     */
    override func endRefreshing() {
        super.endRefreshing()
        
        // 停止动画
        stopLoading()
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 添加子控件
        addSubview(startRefreshView)
        addSubview(startRefreshLabel)
        addSubview(pullBgView)
        pullBgView.addSubview(pullRefreshView)
        pullBgView.addSubview(pullFrefreshLabel)
        
        // 约束子控件
        // 开始刷新图标
        startRefreshView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(125)
        }
        
        // 开始刷新文字
        startRefreshLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(170)
        }
        
        // 下拉刷新背景view
        pullBgView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self.snp_edges)
        }
        
        // 下拉刷新图标
        pullRefreshView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(125)
        }
        
        // 下拉刷新文字
        pullFrefreshLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(170)
            make.centerY.equalTo(self.snp_centerY)
        }

    }
    
    // MARK: - 懒加载
    /// 正在加载图标
    lazy var startRefreshView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.image = UIImage(named: "userinfo_tableview_loading")
        return imageView
    }()
    
    /// 开始刷新数据
    lazy var startRefreshLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.grayColor()
        label.text = "加载中......"
        return label
    }()
    
    /// 下拉刷新父view
    lazy var pullBgView: UIView = {
        let view = UIView()
        view.sizeToFit()
        view.backgroundColor = UIColor.whiteColor()
        return view
    }()
    
    /// 下拉刷新图标
    lazy var pullRefreshView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.image = UIImage(named: "tableview_pull_refresh")
        return imageView
    }()
    
    /// 下拉刷新文字
    lazy var pullFrefreshLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = UIFont.systemFontOfSize(15)
        label.textColor = UIColor.grayColor()
        label.text = "下拉刷新"
        return label
    }()
    
}
