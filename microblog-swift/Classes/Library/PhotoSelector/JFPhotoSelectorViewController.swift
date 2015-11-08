//
//  JFPhotoSelectorViewController.swift
//  microblog-swift
//
//  Created by jianfeng on 15/11/5.
//  Copyright © 2015年 六阿哥. All rights reserved.
//

import UIKit
import ReactiveCocoa

// MARK: - 照片选择控制器
class JFPhotoSelectorViewController: UICollectionViewController {
    
    /// cell重用标示符
    private let photoCellIdentifier = "photoCell"
    
    /// 布局属性
    private var layout = UICollectionViewFlowLayout()
    
    /// 已选择的图片数组
    var photos = [UIImage]()
    
    // 最大图片数量
    private let maxPhotoCount = 9
    
    /// 记录当前点击cell的indexPath
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
    
    // MARK: - UICollectionViewDataSource数据源
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count < maxPhotoCount ? photos.count + 1 : photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoCellIdentifier, forIndexPath: indexPath) as! JFPhotoSelectorCell
        
        // 设置cell代理
        cell.cellDelegate = self
        
        // 如果有照片,设置cell显示image
        if indexPath.item < photos.count {
            cell.image = photos[indexPath.item]
        } else {
            cell.image = nil
        }
        
        return cell
    }

}

// MARK: - JFPhotoSelectorCellDelegate委托方法
extension JFPhotoSelectorViewController: JFPhotoSelectorCellDelegate {
    
    /// 添加图片
    func photoSelectorCellAddPhoto(cell: JFPhotoSelectorCell) {
        
        // 判断用户是否同意应用访问相册
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            print("用户不允许访问相册")
            return
        }
        
        let picker = UIImagePickerController()
        
        // 设置代理
        picker.delegate = self
        
        // 将点击的cell的indexPath记录下来
        currentIndexPath = collectionView?.indexPathForCell(cell)
        
        // 弹出系统相册
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

// MARK: - UIImagePickerControllerDelegate委托方法
extension JFPhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 选中图片时调用, 一旦实现这个方法,需要主动关闭控制器
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // 压缩图片
        let img = image.scaleImage()
        
        if currentIndexPath?.item < photos.count {
            // 点击了图片
            // 替换图片
            photos[currentIndexPath!.item] = img
        } else {
            // 点击了加号按钮
            // 将选中的图片添加到图片数组
            photos.append(img)
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
        
        // 如果图片宽度小于 newWidth, 不用缩小直接返回
        if size.width < newWidth {
            return self
        }
        
        // 计算缩放好后的高度
        // newHeight / newWidth = height / width
        let newHeight = newWidth * size.height / size.width
        // 新的尺寸
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

// MARK: - cell代理
protocol JFPhotoSelectorCellDelegate : NSObjectProtocol {
    
    // 加号按钮点击事件
    func photoSelectorCellAddPhoto(cell: JFPhotoSelectorCell)
    
    // 删除按钮点击时间
    func photoSelectorCellRemovePhoto(cell: JFPhotoSelectorCell)
}


// MARK: - 自定义cell
class JFPhotoSelectorCell: UICollectionViewCell {
    
    /// 显示的image
    var image: UIImage? {
        didSet {
            // 最后一个按钮就设置加号图片
            if image == nil {
                addButton.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
                addButton.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
            } else {
                addButton.setImage(image, forState: UIControlState.Normal)
            }
            
            // 如果是最后一个按钮不需要显示删除按钮
            removeButton.hidden = image == nil
        }
    }
    
    /// 代理属性
    weak var cellDelegate: JFPhotoSelectorCellDelegate?
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 准备UI
        prepareUI()
        
        // 背景颜色
        backgroundColor = UIColor.whiteColor()
    }
    
    /**
     准备UI
     */
    private func prepareUI() {
        
        // 添加子控件
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        // 约束子控件
        // 添加按钮
        addButton.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView.snp_edges)
        }
        
        // 删除按钮
        removeButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(addButton.snp_right)
            make.top.equalTo(addButton.snp_top)
        }
        
        // 按钮点击事件
        // 添加
        addButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.cellDelegate?.photoSelectorCellAddPhoto(self)
        }
        // 移除
        removeButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { (_) -> Void in
            self.cellDelegate?.photoSelectorCellRemovePhoto(self)
        }
        
    }
    
    // 懒加载
    // 加号按钮
    private lazy var addButton: UIButton = {
        let button = UIButton()
        // 设置按钮图片的填充模式
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        return button
    }()
    
    
    // 删除按钮
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "pic_delete"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "pic_delete_highlighted"), forState: UIControlState.Highlighted)
        return button
    }()
    
}
