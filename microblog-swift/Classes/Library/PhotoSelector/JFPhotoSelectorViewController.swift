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
    
    /// 选择的图片
    var photos = [UIImage]()
    
    // 最大图片数量
    private let maxPhotoCount = 9
    
    /// 当前点击cell的indexPath
    private var currentIndexPath: NSIndexPath?
    
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
        
        // 背景颜色
        view.backgroundColor = UIColor.whiteColor()
        collectionView?.backgroundColor = UIColor.whiteColor()
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

// MARK: - <#Description#>
extension JFPhotoSelectorViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 1.photos.count < maxPhotoCount 显示 photos.count + 1
        // 2.photos.count = maxPhotoCount 显示 photos.count
        return photos.count < maxPhotoCount ? photos.count + 1 : photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellIdentifier, forIndexPath: indexPath) as! JFPhotoSelectorCell
        cell.cellDelegate = self
        
        // 如果有照片,设置cell显示image
        // 如果有照片,设置cell显示image
        if indexPath.item < photos.count {
            cell.image = photos[indexPath.row]
        } else {
            cell.image = nil
        }
        
        return cell
    }
}

// MARK: - JFPhotoSelectorCellDelegate 协议
extension JFPhotoSelectorViewController: JFPhotoSelectorCellDelegate {
    
    /// 添加图片
    func photoSelectorCellAddPhoto(cell: JFPhotoSelectorCell) {
        
        // 判断用户是否同意应用访问相册
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            print("用户不允许访问相册")
            return
        }
        
        // 弹出系统相册
        let picker = UIImagePickerController()
        
        // 设置代理
        picker.delegate = self
        
        // 将点击的cell的indexPath记录下来
        currentIndexPath = collectionView?.indexPathForCell(cell)
        
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    /// 删除图片
    func photoSelectorCellRemovePhoto(cell: JFPhotoSelectorCell) {
        
        // 获取cell的indexPath
        if let indexPath = collectionView?.indexPathForCell(cell) {
            // 删除 photos 数组中对应的 iamge
            photos.removeAtIndex(indexPath.item)
            
            // 刷新数据
            collectionView?.reloadData()
        }
        
    }
}

// MARK: - UIImagePickerControllerDelegate UINavigationControllerDelegate 协议.获取选取的图片
extension JFPhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 选中图片时调用, 一旦实现这个方法,需要主动关闭控制器
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // 点击加号按钮
        if currentIndexPath?.item == photos.count {
            // 将选中的图片添加到图片数组
            photos.append(image)
        } else {
            // 替换图片
            photos[currentIndexPath!.item] = image
        }
        
        // collectionView 刷新数据
        collectionView?.reloadData()
        
        // 关闭系统相册控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UIImage扩展,等比例缩小图片到指定的宽度
extension UIImage {
    
    /**
     等比例缩小图片到指定的宽度
     - parameter newWidth: 缩放后的宽度
     - newWidth 默认等于 300
     */
    func scaleImage(newWidth: CGFloat = 300) -> UIImage {
        // 如果图片宽度小于 newWidth, 直接返回
        if size.width < newWidth {
            return self
        }
        
        // 计算缩放好后的高度
        // newHeight / newWidth = height / width
        let newHeight = newWidth * size.height / size.width
        
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        // 将图片等比例缩放到 newSize
        
        // 开启图片上下文
        UIGraphicsBeginImageContext(newSize)
        
        // 绘图
        drawInRect(CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        
        // 获取绘制好的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭绘图上下文
        UIGraphicsEndImageContext()
        
        // 返回绘制好的新图
        return newImage
    }
    
    
}