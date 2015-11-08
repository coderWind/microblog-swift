//
//  JFStatusPictureView.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/31.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import SDWebImage

// 通知名称
let UICollectionViewCellDidSelectedPhotoNotification = "collectionViewCellSelectedNotification"

// 选中cell的索引
let UICollectionViewCellDidSelectedPhotoIndexKey = "collectionViewCellSelectedIndex"
// 选中cell的图片数组
let UICollectionViewCellDidSelectedPhotoUrlsKey = "collectionViewCellSelectedUrls"

class JFStatusPictureView: UICollectionView {
    
    /// 微博模型
    var status: JFStatus? {
        didSet {
            // 调用sizeToFit会自动调用view的sizeThatFits来重新计算view的size
            sizeToFit()
            
            // 刷新数据
            reloadData()

            // 背景颜色
            backgroundColor = status?.retweeted_status == nil ? UIColor.whiteColor() : UIColor(white: 0.9, alpha: 0.4)
        }
    }
    
    // 唯一标示符
    let identifier = "picCell"
    
    // collectionView流水布局
    private var pictureLayout = UICollectionViewFlowLayout()
    
    // MARK: - 重写构造方法，设置布局
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRectZero, collectionViewLayout: pictureLayout)
        
        // 注册cell
        registerClass(JFStatusPictureViewCell.self, forCellWithReuseIdentifier: identifier)
        
        // 设置数据源
        dataSource = self
        
        // 设置代理
        delegate = self
    }
    
    /**
     重新计算view的size
     
     - parameter size: 之前view的size
     
     - returns: 返回新的size
     */
    override func sizeThatFits(size: CGSize) -> CGSize {
        return calculateViewSize()
    }
    
    /**
     计算配图尺寸
     
     - returns: 返回配图的尺寸
     */
    func calculateViewSize() -> CGSize {
        
        let itemWidth: CGFloat = (kScreenW - 34) / 3
        // 每个item的大小
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        // 设置布局的itemSize
        pictureLayout.itemSize = itemSize
        pictureLayout.minimumInteritemSpacing = 0
        pictureLayout.minimumLineSpacing = 0
        
        // cell之间的间距
        let margin: CGFloat = 5
        
        // 最大列数
        let column = 3
        
        // 获取配图的数量
        let count = status?.pictureURLs?.count ?? 0
        
        // 无图
        if count == 0 {
            return CGSizeZero
        }
        
        // 一张图
        if count == 1 {
            
            var size = CGSize(width: 150, height: 120)
            
            // 获取图片URL地址
            let urlString = status?.pictureURLs?[0].absoluteString
            
            // 获取图片，有图片设置size为图片的size，没有则使用默认的
            if let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlString) {
                size = image.size
            }
            
            // 设置最小宽度
            if size.width < 40 {
                size.width = 40
            }
            
            pictureLayout.itemSize = size
            
            return size
        }
        
        // 超过一张图片设置间距
        pictureLayout.minimumInteritemSpacing = margin
        pictureLayout.minimumLineSpacing = margin
        
        // 四张图片
        if count == 4 {
            let width = 2 * itemWidth + margin
            return CGSize(width: width, height: width)
        }
        
        // 其他图片 ： 2, 3, 5, 6, 7, 8, 9
        // 公式： 行数 = (图片数量 + 列数 - 1) / 列数
        let row = (count + column - 1) / column
        
        // 计算宽度
        let width = (CGFloat(column) * itemWidth) + (CGFloat(column) - 1) * margin
        
        // 计算高度
        let height = (CGFloat(row) * itemWidth) + (CGFloat(row) - 1) * margin
        
        return CGSize(width: width, height: height)
        
    }
    
    // MARK: - 懒加载
    // 图片
    private lazy var iconView = UIImageView()
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension JFStatusPictureView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // 返回图片张数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return status?.pictureURLs?.count ?? 0
    }
    
    // 返回cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! JFStatusPictureViewCell
        
        // 设置cell数据
        cell.imageURL = status?.pictureURLs?[indexPath.item]
        
        return cell
    }
    
    // 选中某个cell时调用
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        guard let urls = status?.largePictureURLs else {
            print("url为空")
            return
        }
        
        // 选中图片的索引 和 图片URL数组
        let userInfo = [UICollectionViewCellDidSelectedPhotoIndexKey : indexPath.item, UICollectionViewCellDidSelectedPhotoUrlsKey : urls] as [NSObject : AnyObject]
        // 发送通知
        NSNotificationCenter.defaultCenter().postNotificationName(UICollectionViewCellDidSelectedPhotoNotification, object: nil, userInfo: userInfo)
        
    }
    
}



