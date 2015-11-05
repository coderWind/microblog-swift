//
//  JFEmoticonLayout.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/4.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

// MARK: - 自定义布局类
class JFEmoticonLayout: UICollectionViewFlowLayout {
    
    /**
     布局前都会调用这个方法，可以在这设置布局参数
     */
    override func prepareLayout() {
        super.prepareLayout()
        
        // 计算每个item的宽、高
        let width = collectionView!.frame.width / 7.0
        let height = collectionView!.frame.height / 3.0
        
        // 设置每个item的尺寸
        itemSize = CGSize(width: width, height: height)
        
        // 设置每个item的间距
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        // 设置滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 隐藏滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        
        // 取消弹簧效果
        collectionView?.bounces = false
        collectionView?.alwaysBounceHorizontal = false
        
        // 分页效果
        collectionView?.pagingEnabled = true
        
    }

}
