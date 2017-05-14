//
//  ViewController.swift
//  MutSelectPhotoes
//
//  Created by 张江东 on 2017/5/14.
//  Copyright © 2017年 58kuaipai. All rights reserved.
//

import UIKit

fileprivate let resuID: String = "DemoCollectionViewCell"


class ViewController: UIViewController {
    
    var currentPage : Int = 0
     lazy var theIndexLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        self.view.addSubview(theIndexLabel)

        theIndexLabel.backgroundColor = UIColor.black
        theIndexLabel.textColor = UIColor.white
        theIndexLabel.textAlignment = .center
        theIndexLabel.frame = CGRect(x: 0, y: kJDScreenHeight - 40, width: 80, height: 30)
        theIndexLabel.centerX = kJDScreenWidth * 0.5

    }

    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kJDScreenWidth , height: kJDScreenHeight )
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kJDScreenWidth, height: kJDScreenHeight ), collectionViewLayout: layout)
        collectionView.register(DemoCollectionViewCell.self, forCellWithReuseIdentifier: resuID)
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.backgroundColor = UIColor.black
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        return collectionView
    }()
    

    
}



extension ViewController :UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resuID, for: indexPath as IndexPath) as! DemoCollectionViewCell
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        //不是这里错误
        currentPage = Int(scrollView.contentOffset.x / scrollView.width)
     theIndexLabel.text = "\(currentPage)"
        
    }
    
}



