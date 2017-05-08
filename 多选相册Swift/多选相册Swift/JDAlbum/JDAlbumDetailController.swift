//
//  JDAlbumDetailController.swift
//  多选相册Swift
//
//  Created by 张江东 on 2017/5/5.
//  Copyright © 2017年 58kuaipai. All rights reserved.
//

import UIKit
import Photos

class JDAlbumDetailController: UICollectionViewController {
    //选中的照片
    var selImageArrays: NSMutableArray = []
    
    var bottomVi: UIView = UIView(frame: CGRect(x: kJDScreenWidth - 50, y: kJDScreenHeight - 50, width: 50, height: 50))
    
    ///取得的资源结果，用了存放的PHAsset
    var assetsFetchResults:PHFetchResult<PHAsset>!
    
    ///缩略图大小
    var assetGridThumbnailSize:CGSize!
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    let numBtn = UIButton(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
    
    var selectImgsClosure2: (( _ assets: [PHAsset])->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(JDCollectionViewCell.self, forCellWithReuseIdentifier: "JDCollectionViewCell")
        self.collectionView?.backgroundColor = UIColor.white
        //则获取所有资源
        let allPhotosOptions = PHFetchOptions()
        //按照创建时间倒序排列
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                             ascending: false)]
        //只获取图片
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                 PHAssetMediaType.image.rawValue)
        //所有图片
//                assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image,
//                                                         options: allPhotosOptions)
        
        // 初始化和重置缓存
        self.imageManager = PHCachingImageManager()
        self.resetCachedAssets()
        
        let rightItem = UIBarButtonItem(title: "确定", style: .plain, target:self, action: #selector(done))
        
        self.navigationItem.rightBarButtonItem = rightItem
        
        bottomVi.backgroundColor = UIColor.clear
        
        self.view.addSubview(bottomVi)
        bottomVi.addSubview(numBtn)
        numBtn.setTitle("0", for: .normal)
        numBtn.setTitleColor(UIColor.white, for: .normal)
        numBtn.setBackGroundColor(color: UIColor.colorWithHex(hexColor: 0x59be6f), type: .normal)
        numBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        numBtn.layer.cornerRadius = 15
        numBtn.layer.masksToBounds = true
        numBtn.isUserInteractionEnabled = false

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //根据单元格的尺寸计算我们需要的缩略图大小
        let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSize(width:cellSize.width ,
                                        height:cellSize.height)
        
    }
    
    


    //push
    @objc private func done(){
        var imgs = [PHAsset]()
        
        for index in self.selImageArrays{
            let asset = self.assetsFetchResults[(index as! IndexPath).row]
            imgs.append(asset)
        }
        
        if imgs.count > 0 {
            if self.selectImgsClosure2 != nil{
                self.selectImgsClosure2?(imgs)
            }
        }

        
        self.dismiss(animated: true, completion: nil)

    }
    //重置缓存
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    // CollectionView行数
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults.count
    }
    
    // 获取单元格
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identify:String = "JDCollectionViewCell"
        
        let cell = (self.collectionView?.dequeueReusableCell(
            withReuseIdentifier: identify, for: indexPath))! as! JDCollectionViewCell
        cell.indexPa = indexPath
        
        let anima = CABasicAnimation()
        anima.keyPath = "transform.scale";
        anima.toValue = (1.3)
        anima.duration = 0.3
        
        cell.selectImgClosure = { (index, type) in
            if type == AddOrDelete.add {
                self.selImageArrays.add(index)
                self.numBtn.setTitle(String(self.selImageArrays.count), for: .normal)
                
                
                self.numBtn.layer.add(anima, forKey: nil)
                

            }else if type == AddOrDelete.delete{
                self.selImageArrays.remove(index)
                self.numBtn.setTitle(String(self.selImageArrays.count), for: .normal)
                self.numBtn.layer.add(anima, forKey: nil)

            }
        
        }
        
        if self.selImageArrays.contains(indexPath) {
            cell.selBtn.isSelected = true
            
            
        }else{
            cell.selBtn.isSelected = false

        }
        
        let asset = self.assetsFetchResults[indexPath.row]
        //获取缩略图
//        print("缩略图-->",assetGridThumbnailSize)
        self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize, contentMode: PHImageContentMode.aspectFill,
                                       options: nil) { (image, nfo) in
                                        cell.img.image = image
                                        
        }
        
        
        
        
     
        
        
        
        
        return cell
    }
    
    // 单元格点击响应
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
//        let myAsset = self.assetsFetchResults[indexPath.row]
        
//        PHImageManager.default().requestImage(for: myAsset,
//                                              targetSize: PHImageManagerMaximumSize , contentMode: .aspectFill,
//                                              options: nil, resultHandler: {
//                                                (image, _: [AnyHashable : Any]?) in
//                                 
//
//                                                
//        })
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

