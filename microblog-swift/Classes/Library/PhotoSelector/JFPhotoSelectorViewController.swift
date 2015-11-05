//
//  JFPhotoSelectorViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/5.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit

class JFPhotoSelectorViewController: UICollectionViewController {
    
    let photoCellIdentifier = "photoCell"
    
    /// collectionView 的流水布局
    private var layout = UICollectionViewFlowLayout()
    
    /// 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 准备collectionView
        prepareCollectionView()
        
    }
    
    /**
     准备collectionView
     */
    private func prepareCollectionView() {
        
        // 注册cell
        collectionView?.registerClass(JFPhotoSelectorCell.self, forCellWithReuseIdentifier: photoCellIdentifier)
        
        // 设置itemSize
        layout.itemSize = CGSize(width: 80, height: 80)
        
        // 设置间距
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }

}

extension JFPhotoSelectorViewController {
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellIdentifier, forIndexPath: indexPath) as! JFPhotoSelectorCell
        cell.cellDelegate = self
        return cell
    }
}

// MARK: - 扩展 CZPhotoSelectorViewController 实现 CZPhotoSelectorCellDelegate 协议
extension JFPhotoSelectorViewController: JFPhotoSelectorCellDelegate {
    /// 添加图片
    func photoSelectorCellAddPhoto() {
        print(__FUNCTION__)
    }
    
    /// 删除图片
    func photoSelectorCellRemovePhoto() {
        print(__FUNCTION__)
    }
}