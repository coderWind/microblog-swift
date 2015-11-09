//
//  JFPhotoBrowserViewCell.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/7.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

// MARK: - JFPhotoBrowserCell协议
protocol JFPhotoBrowserCellDelegate: NSObjectProtocol {
    
    /// 关闭Modal出来的视图
    func dismiss()
    
    /// 缩小时需要设置透明度的view
    func viewForTransparent() -> UIView
}

class JFPhotoBrowserViewCell: UICollectionViewCell {
    
    /// 最小缩放
    let JFPhotoBrowserCellMinimumZoomScale: CGFloat = 0.5
    
    /// 过渡动画代理
    weak var transitionDelegate: JFPhotoBrowserCellDelegate?
    
    // 模型
    var model: JFPhotoBrowserModel?
    
    /// 图片URL
    var imageUrl: NSURL? {
        didSet {
            
            guard let imgUrl = imageUrl else {
                print("url有问题")
                return
            }
            
            // 重置cell各种属性，防止复用
            resetScrollView()
            
            // 菊花开始钻洞
            loadIndicator.startAnimating()
            
            // 下载图片
            imgView.sd_setImageWithURL(imgUrl) { (image, error, _, _) -> Void in
                
                // 菊花停止钻洞
                self.loadIndicator.stopAnimating()
                
                // 缩放图片
                let imageSize = self.resizeImage(image)
                
                // 图片布局
                if imageSize.height > kScreenH {
                    
                    // 长度才能滚动
                    self.scrollView.contentSize = imageSize
                    self.imgView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
                    
                } else {
                    
                    // y方向偏移
                    let offestY = (self.scrollView.bounds.height - imageSize.height) * 0.5
                    
                    // 设置imageView的frame
                    self.imgView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
                    
                    // 不能使用 frame 来布局imageView的位置.在缩放后会停在origin的位置.无法显示完整
                    self.scrollView.contentInset = UIEdgeInsets(top: offestY, left: 0, bottom: offestY, right: 0)
                }
                
            }
        }
    }
    
    /**
     根据屏幕尺寸缩放图片
     */
    func resizeImage(image: UIImage) -> CGSize {
        
        // 原始尺寸
        let size = image.size
        
        // 如果图片宽度大于了屏幕宽度就要等比缩放到屏幕宽度
        if size.width > kScreenW {
            // 缩放后的宽度 / 缩放后的高度 = 原始宽度 / 原始高度
            let imageWidth = kScreenW
            let imageHeight = imageWidth / (size.width / size.height)
            return CGSize(width: imageWidth, height: imageHeight)
        } else {
            return size
        }
    }
    
    /// 重置scrollView的一些属性,防止因为cell复用导致cell图片显示的不对
    private func resetScrollView() {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentSize = CGSizeZero
        scrollView.contentOffset = CGPointZero
        imgView.transform = CGAffineTransformIdentity
    }
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 准备UI
        prepareUI()
        
        // 缩放比例
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        
        // 代理
        scrollView.delegate = self
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imgView)
        contentView.addSubview(loadIndicator)
        
        // 约束子控件
        scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        loadIndicator.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(contentView.snp_center)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
    }
    
    // MARK: - 懒加载
    // 内容区域
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    // 图片
    lazy var imgView: JFImageView = {
        let imgView = JFImageView()
        imgView.contentMode = UIViewContentMode.ScaleAspectFill
        return imgView
    }()
    
    // 菊花
    private lazy var loadIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)

}

// MARK: - UIScrollViewDelegate 代理方法
extension JFPhotoBrowserViewCell: UIScrollViewDelegate {
    
    // 需要缩放的view
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
    // 滚动中调用，使图片居中
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        // 获取需要设置透明度的view
        let view = transitionDelegate?.viewForTransparent()
        
        // 设置透明度
        if imgView.transform.a < 1 {
            view?.alpha = imgView.transform.a * 0.7 - 0.2
        } else {
            view?.alpha = 1
        }
        
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {

        // 使 imageView显示在中间位置
        var offestX = (scrollView.bounds.width - imgView.frame.width) * 0.5
        var offestY = (scrollView.bounds.height - imgView.frame.height) * 0.5
        
        // 当offestX < 0 时, 让 offestX = 0
        offestX = offestX < 0 ? 0 : offestX
        offestY = offestY < 0 ? 0 : offestY
        
        // 添加动画,动画到中间
        UIView.animateWithDuration(0.25) { () -> Void in
            scrollView.contentInset = UIEdgeInsets(top: offestY, left: offestX, bottom: offestY, right: offestX)
        }
     
    }
    
}
