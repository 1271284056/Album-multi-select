//
//  BaseViewController.swift
//  hangge_1233
//
//  Created by 张江东 on 2017/5/8.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit
import Photos

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "起始界面"
        
        let rightItem = UIBarButtonItem(title: "相册", style: .plain, target:self, action: #selector(photo))
        
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    //push
    @objc private func photo(){
        
        let album = JDAlbumGroupController()
        
        album.selectImgsClosure1 = { (assets: [PHAsset]) in
            print(assets.count)
            
            for index in 0..<assets.count {
                let imgVi = UIImageView()
                imgVi.jiuFrame(index: index, column: 3, viW: 100, viH: 100, topMargin: 10)
                self.view.addSubview(imgVi)
                self.getLitImage(asset: assets[index], callback: { (image) in
                    imgVi.image = image

                })
            }
            
        }
        
        let nav = UINavigationController(rootViewController: album)
        self.present(nav, animated: true, completion: nil)
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

    
    //获取原图
    private func getOrangeImage(asset: PHAsset,callback: @escaping ImgCallBackType){
        //获取原图
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: PHImageManagerMaximumSize , contentMode: .aspectFill,
                                              options: nil, resultHandler: {
                                                (image, _: [AnyHashable : Any]?) in
                                                if image != nil{
                                                    callback(image)
                                                }
                                                
        })
        
    }


}
