//
//  ImageShot.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/10/12.
//  Copyright © 2019 playplay. All rights reserved.
//

import Foundation
import BBMetalImage
import UIKit

class ImageShot {
    
    
    var image:UIImage
    var texture: MTLTexture
    var filterType: FilterType?
    var isSelected: Bool
    var smallTexture:MTLTexture

    init(_image:UIImage, _texture:MTLTexture, _filterType:FilterType?, _isSelected:Bool, _smallTexture:MTLTexture) {
        self.image = _image
        self.texture = _texture
        self.filterType = _filterType
        self.isSelected = _isSelected
        self.smallTexture = _smallTexture
        
    }

    
}
