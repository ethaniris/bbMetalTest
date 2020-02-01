//
//  CardImageCell.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/10/26.
//  Copyright © 2019 playplay. All rights reserved.
//

import UIKit

protocol CardCellDelegate {
    func didSwipe(cell:CardCell)
    func didTapOnce(cell:CardCell)
    func didLongPress(cell:CardCell)
    func didCheck(cell:CardCell)
}

class CardCell: UICollectionViewCell {
    
    
    var indexPath:IndexPath?
    
    var cellCheckImageView:UIImageView = {
    
           var iv = UIImageView()
           iv.contentMode = .scaleAspectFit
           iv.isUserInteractionEnabled = true
           return iv

       }()
    
    
    
    var cellImageView:UIImageView = {
 
        var iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv

    }()
    
    
    var isSelectionMode:Bool?{
        
        didSet {
            if self.isSelectionMode! {
                //進入多選擇
                self.cellCheckImageView.isHidden = false
                singleTapGesture.removeTarget(self, action: #selector(tapOnce))
                singleTapGesture.addTarget(self, action: #selector(checkTick))
                
            } else {
                //跳出多選擇
                self.cellCheckImageView.isHidden = true
                singleTapGesture.removeTarget(self, action: #selector(checkTick))
                singleTapGesture.addTarget(self, action: #selector(tapOnce))
            }
        }
    }
    
        var imageToShow:ImageShot? {
            didSet{
    
                let smallImage = resizeImage(image: self.imageToShow!.image)
                cellImageView.image = smallImage
                
                let checkStatus = self.imageToShow!.isSelected
                if checkStatus {
                    self.cellCheckImageView.image = UIImage(named: "checked.png")
                } else {
                     self.cellCheckImageView.image = UIImage(named: "unchecked.png")
                }

                
            }
        }

    var cellDelegate: CardCellDelegate?
    
    let singleTapGesture = UITapGestureRecognizer()
    
    override func awakeFromNib() {
           super.awakeFromNib()
           self.backgroundColor = .clear
           self.addSubview(self.cellImageView)
        self.addSubview(self.cellCheckImageView)
        
        
        let swipeUpGesture = UISwipeGestureRecognizer()
        swipeUpGesture.direction = .up
        swipeUpGesture.addTarget(self, action:#selector(swipeUp))
        self.cellImageView.addGestureRecognizer(swipeUpGesture)
        
        singleTapGesture.numberOfTapsRequired = 1
        singleTapGesture.addTarget(self, action: #selector(tapOnce))
        self.cellImageView.addGestureRecognizer(singleTapGesture)
        
        let checkGesture = UITapGestureRecognizer()
        checkGesture.numberOfTapsRequired = 1
        checkGesture.addTarget(self, action: #selector(checkTick))
        self.cellCheckImageView.addGestureRecognizer(checkGesture)
        
        
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 1
        longPressGesture.addTarget(self, action: #selector(self.longPress(recognizer:)))
        self.cellImageView.addGestureRecognizer(longPressGesture)
        
       }
       
   
    override func layoutSubviews() {
           super.layoutSubviews()
           cellImageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        
           cellCheckImageView.anchor(top: self.topAnchor, leading: nil, bottom: nil, trailing: self.safeRightAnchor, padding: .init(top: 3, left: 0, bottom: 0, right: -3), size: .init(width: 20, height: 20))
       }
    
    @objc func swipeUp(){
        cellDelegate?.didSwipe(cell: self)
    }
    
    @objc func tapOnce(){
        cellDelegate?.didTapOnce(cell: self)
    }
    
    @objc func longPress(recognizer:UILongPressGestureRecognizer){
        
        
        if recognizer.state == .began {
        cellDelegate?.didLongPress(cell: self)
        }
    }
    
    @objc func checkTick(){
        cellDelegate?.didCheck(cell: self)
    }
}
