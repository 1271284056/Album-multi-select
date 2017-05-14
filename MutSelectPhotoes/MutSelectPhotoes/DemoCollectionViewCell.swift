//
//  DemoCollectionViewCell.swift
//  MutSelectPhotoes
//
//  Created by 张江东 on 2017/5/14.
//  Copyright © 2017年 58kuaipai. All rights reserved.
//

import UIKit

class DemoCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        
        backImg.frame = CGRect(x: 5, y: 5, width: kJDScreenWidth - 10, height: kJDScreenHeight-10 )
        
        self.contentView.addSubview(backImg)
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var backImg : UIImageView = {
        var img = UIImageView()
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleAspectFit
        //        img.backgroundColor = UIColor.black
        //        img.frame = baseImageRect
        img.image = UIImage(named: "blackall")
        return img
    }()
}
