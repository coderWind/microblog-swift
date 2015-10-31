//
//  JFStatusPictureView.swift
//  microblog-swift
//
//  Created by jianfeng on 15/10/31.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFStatusPictureView: UICollectionView {
    
    /// 微博模型
    var status: JFStatus? {
        didSet {
            // 调用sizeToFit会自动调用view的sizeThatFits来重新计算view的size
            sizeToFit()
            
            // 刷新数据
            reloadData()
        }
    }
    
    // collectionView流水布局
    private var pictureLayout = UICollectionViewFlowLayout()
    
    // MARK: - 重写构造方法，添加流水布局
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: pictureLayout)
        
        // 注册cell
        registerClass(JFStatusPictureViewCell.self, forCellWithReuseIdentifier: "picCell")
        
        // 设置数据源
        dataSource = self
        
        // 背景颜色
        backgroundColor = status?.retweeted_status == nil ? UIColor.whiteColor() : UIColor(white: 0.9, alpha: 0.4)
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
        
        // 每个item的大小
        let itemSize = CGSize(width: 90, height: 90)
        
        // 设置布局的itemSize
        pictureLayout.itemSize = itemSize
        pictureLayout.minimumInteritemSpacing = 0
        pictureLayout.minimumLineSpacing = 0
        
        // cell之间的间距
        let margin: CGFloat = 10
        
        // 最大列数
        let column = 3
        
        // 获取配图的数量
        let count = status?.pictureURLs?.count ?? 0
        
        // 根据配图数量计算配图尺寸
        // 无图
        if count == 0 {
            return CGSizeZero
        }
        
        // 一张图
        if count == 1 {
            let size = CGSize(width: 150, height: 120)
            pictureLayout.itemSize = size
            return size
        }
        
        // 超过一张图片设置间距
        pictureLayout.minimumInteritemSpacing = margin
        pictureLayout.minimumLineSpacing = margin
        
        // 四张图片
        if count == 4 {
            let width = 2 * itemSize.width + margin
            return CGSize(width: width, height: width)
        }
        
        // 其他图片 ： 2, 3, 5, 6, 7, 8, 9
        // 公式： 行数 = (图片数量 + 列数 - 1) / 列数
        let row = (count + column - 1) / column
        
        // 计算宽度
        let width = (CGFloat(column) * itemSize.width) + (CGFloat(column) - 1) * margin
        
        // 计算高度
        let height = (CGFloat(row) * itemSize.height) + (CGFloat(row) - 1) * margin
        
        return CGSize(width: width, height: height)
        
    }
    
    // MARK: - 懒加载
    // 图片
    private lazy var iconView = UIImageView()
    
}

// MARK: - UICollectionViewDataSource
extension JFStatusPictureView: UICollectionViewDataSource {
    
    // 返回图片张数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return status?.pictureURLs?.count ?? 0
    }
    
    // 返回cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("picCell", forIndexPath: indexPath) as! JFStatusPictureViewCell
        
        // 设置cell数据
        cell.imageURL = status?.pictureURLs?[indexPath.item]
        
        return cell
    }
    
}



