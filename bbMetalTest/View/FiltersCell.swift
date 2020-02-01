//
//  FiltersCellCollectionViewCell.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/11/6.
//  Copyright © 2019 playplay. All rights reserved.
//

import UIKit

class FiltersCell: UICollectionViewCell {
    var filter:Filter? {
           didSet{
               
               guard let filter = filter else {return}
               filterNameLabel.text = filter.filterName
           }
       }

//        var image:FilteredImage? {
//
//        didSet {
//
//            guard let image = image else {return}
//            let filterImage = image.chainFilters(values: self.filter!.values)
//
//            filterImageView.image = filterImage
//
//        }
//    }
    
        var outputImage:UIImage? {

        didSet {
            
            guard let image = outputImage else {return}
            filterImageView.image = image
            
        }
    }

    
    static var identifier: String = "filterCell"
  
    var filterImageView:UIImageView = {
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var filterNameLabel:UILabel = {
       var lb = UILabel()
       
       lb.textColor = .white
       lb.font = UIFont(name: "Helvetica Bold", size: 14)
       lb.adjustsFontSizeToFitWidth = true
        lb.textAlignment = .center
       return lb
        
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        filterImageView.frame = CGRect(x: 5, y: 10, width: 70, height: 70)
        self.addSubview(filterImageView)

        filterNameLabel.frame = CGRect(x: 5, y: 80, width: 70, height: 60)        
        self.addSubview(filterNameLabel)
                
    }

}
