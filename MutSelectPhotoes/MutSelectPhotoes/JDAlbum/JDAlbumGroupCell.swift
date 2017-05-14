//
//  JDAlbumGroupCell.swift
//  MutSelectPhotoes
//
//  Created by 张江东 on 2017/5/9.
//  Copyright © 2017年 58kuaipai. All rights reserved.
//

import UIKit

class JDAlbumGroupCell: UITableViewCell {

    var headImage: UIImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40)) //评级
    var titleLb: UILabel = UILabel(frame: CGRect(x: 60, y: 0, width: 300, height: 50)) //车型

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLb.font = UIFont.systemFont(ofSize: 16)
        titleLb.textColor = UIColor.black
        titleLb.textAlignment = .left
        self.contentView.addSubview(titleLb)

        
        self.contentView.addSubview(headImage)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
//        bottomLine.frame = CGRect(x: 0, y: self.height-1, width: self.width, height: 1)
    }
}
