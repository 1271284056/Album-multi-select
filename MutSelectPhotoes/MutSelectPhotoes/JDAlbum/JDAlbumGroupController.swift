//
//  ViewController.swift
//  多选相册Swift
//
//  Created by 张江东 on 2017/5/5.
//  Copyright © 2017年 58kuaipai. All rights reserved.
//

import UIKit
import Photos

//相簿列表项
class AlbumItem {
    //相簿名称
    var title:String?
    //相簿内的资源集合
    var fetchResult: PHFetchResult<AnyObject>
    
    init(title:String?,fetchResult:PHFetchResult<AnyObject>){
        self.title = title
        self.fetchResult = fetchResult
    }
}

class JDAlbumGroupController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
        
    private let kViewControllerId = "JDAlbumGroupControllerId"
    var selectImgsClosure1: (( _ assets: [PHAsset])->())?

    //相簿列表项集合
    var items:[AlbumItem] = [AlbumItem]()
    let tableVi = UITableView(frame: CGRect(x: 0, y: 0, width: kJDScreenWidth, height: kJDScreenHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false

        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            self.dismiss(animated: true, completion: nil)
        }
        setTableView()
        self.tableVi.register(JDAlbumGroupCell.self, forCellReuseIdentifier: kViewControllerId)
        
        // 列出所有系统的智能相册
        let smartOptions = PHFetchOptions()
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                  subtype: PHAssetCollectionSubtype.albumRegular,
                                                                  options: smartOptions)
        self.convertCollection(collection: smartAlbums as! PHFetchResult<AnyObject>)
        
        //列出所有用户创建的相册
        let userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        self.convertCollection(collection: userCollections as! PHFetchResult<AnyObject>)
        
        //相册按包含的照片数量排序（降序）
        self.items.sort { (item1, item2) -> Bool in
            return item1.fetchResult.count > item2.fetchResult.count
        }
    }
    
    private func setTableView(){
        self.view.addSubview(tableVi)
        tableVi.delegate = self
        tableVi.dataSource = self
        
        self.navigationItem.title = "相册"
        let rightItem = UIBarButtonItem(title: "取消", style: .plain, target:self, action: #selector(cancle))
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    //push
    @objc private func cancle(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //转化处理获取到的相簿
    private func convertCollection(collection:PHFetchResult<AnyObject>){
        
        for i in 0..<collection.count{
            //获取出相簿内的图片
            let resultsOptions = PHFetchOptions()
            resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                               ascending: false)]
            resultsOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                   PHAssetMediaType.image.rawValue)
            guard let c = collection[i] as? PHAssetCollection else { return }
            let assetsFetchResult = PHAsset.fetchAssets(in: c ,
                                                        options: resultsOptions)
            //没有图片的空相簿不显示
            if assetsFetchResult.count > 0{
                items.append(AlbumItem(title: c.localizedTitle, fetchResult: assetsFetchResult as! PHFetchResult<AnyObject>))
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kViewControllerId, for: indexPath as IndexPath) as! JDAlbumGroupCell
        
        let item = self.items[indexPath.row]
        if item.title == "Camera Roll" {
            item.title = "我的相册"
        }else if (item.title == "Recently Added"){
            item.title = "最近添加"
        }else if(item.title == "Recently Deleted"){
            item.title = "最近删除"
        }
        
        let first: PHAsset = item.fetchResult[0] as! PHAsset
        self.getLitImage(asset: first) { (image) in
            cell.headImage.image = image
        }
        cell.titleLb.text = "\(item.title ?? "") (\(item.fetchResult.count))"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //获取选中的相簿信息
        let item = self.items[indexPath.row]
        let layout = UICollectionViewFlowLayout()
        let lieshu: CGFloat = 4
        let margin: CGFloat = 3
        layout.itemSize = CGSize(width: (kJDScreenWidth - (lieshu + 1)*margin)/lieshu  , height: (kJDScreenWidth - (lieshu + 1)*margin)/lieshu )
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.scrollDirection = .vertical;
        
        let collectionViewController = JDAlbumDetailController(collectionViewLayout: layout)
        collectionViewController.selectImgsClosure2 = { (assets: [PHAsset]) in
            if self.selectImgsClosure1 != nil {
                self.selectImgsClosure1?(assets)
            }
        }
        
        collectionViewController.title = item.title
        //传递相簿内的图片资源
        if let x = item.fetchResult.firstObject, x is PHAsset{
            collectionViewController.assetsFetchResults = item.fetchResult as! PHFetchResult<PHAsset>
            self.navigationController?.pushViewController(collectionViewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    typealias ImgCallBackType = (UIImage?)->()
    //获取缩略图
    private func getLitImage(asset: PHAsset,callback: @escaping ImgCallBackType){
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: CGSize(width: 100, height: 100) , contentMode: .aspectFill,
                                              options: nil, resultHandler: {
                                                (image, _: [AnyHashable : Any]?) in
                                                if image != nil{
                                                    callback(image)
                                                }
                                                
        })
        
    }
    
    
}

