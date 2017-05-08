//
//  JDCollectionViewCell.swift
//  多选相册Swift
//
//  Created by 张江东 on 2017/5/8.
//  Copyright © 2017年 58kuaipai. All rights reserved.
//

import UIKit

enum AddOrDelete {
    case add
    case delete
}


class JDCollectionViewCell: UICollectionViewCell {
    
    var addType: AddOrDelete = .add //增加或者删除
    
    var indexPa: IndexPath?
    var selBtn: UIButton = UIButton()
    
    var selectImgClosure: (( _ indexPath: IndexPath,_ type: AddOrDelete)->())?

    let img = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        img.contentMode = .scaleAspectFill
        img.layer.masksToBounds = true
        self.contentView.addSubview(img)
        
        self.contentView.addSubview(selBtn)
        selBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        selBtn.setImage(UIImage(named: "1"), for: .normal)
        selBtn.setImage(UIImage(named: "2"), for: .selected)
        
    }
    
    @objc private func btnClick(btn: UIButton){
        if btn.isSelected == true { //原来选中
            btn.isSelected = false
            self.addType = .delete
            if self.selectImgClosure != nil {
                self.selectImgClosure?(indexPa!,addType)
            }
            
        }else{ //原来没选中
            btn.isSelected = true
            self.addType = .add
            
            //小动画
            let anima = CABasicAnimation()
            anima.keyPath = "transform.scale";
            anima.toValue = (1.3)
            anima.duration = 0.3
            btn.layer.add(anima, forKey: nil)
            
            
            if self.selectImgClosure != nil {
                self.selectImgClosure?(indexPa!,addType)
            }
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.frame = CGRect(x: 0, y: 0, width: self.width, height: self.height)
        selBtn.frame = CGRect(x: self.width/2, y: 0, width: self.width/2, height: self.height/2)
    }
    
}
