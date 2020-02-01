//
//  ApplyCell.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/12/4.
//  Copyright © 2019 playplay. All rights reserved.
//

import UIKit

class ApplyCell: UICollectionViewCell {

       static var identifier: String = "applyCell"
                
           var cellImageView:UIImageView = {
        
               var iv = UIImageView()
               iv.contentMode = .scaleAspectFill
               iv.clipsToBounds = true
               iv.isUserInteractionEnabled = true
            
               return iv

           }()
        
//    var filter:Filter?
    
    var imageToShow:ImageShot? {
                didSet{
                    
                    //讓顯示都是小圖 , 讓真正的process在外面存擋 做一擋一
                 
                    guard let imageToShow = self.imageToShow else {return}
                   
                    cellImageView.image = imageToShow.image
                    
                }
            }
    
    
    var outputFilteredImage:UIImage?{
        didSet{
            
            guard let image = self.outputFilteredImage else {return}
            
            DispatchQueue.main.async {[weak self] in 
                self!.cellImageView.image = image
            }
        }
    }
    
//    var filterImageSetsTextures:FilteredImage?{
//        didSet{
//            if self.filterImageSetsTextures != nil {
//
//                let smallFilterImage = self.filterImageSetsTextures!.chainFilters(values: self.filter!.values)
//                DispatchQueue.main.async {[weak self] in
//                    self!.cellImageView.image = smallFilterImage
//                }
//
//
//            }
//        }
//    }

        override func awakeFromNib() {
            super.awakeFromNib()
            self.addSubview(cellImageView)
            cellImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
         
    }
        
        override func layoutSubviews() {
            super.layoutSubviews()
        }
    }
