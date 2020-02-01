//
//  TrashCell.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/12/8.
//  Copyright © 2019 playplay. All rights reserved.
//

import UIKit

protocol TrashCellDelegate {
    
}

class TrashCell: UICollectionViewCell {
    
    lazy var deletedImageView:UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var delegate:TrashCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 10
        
        self.addSubview(deletedImageView)
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        deletedImageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)

    }
}
