//
//  Constants.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/12/8.
//  Copyright © 2019 playplay. All rights reserved.
//

import Foundation
import UIKit

public let yellowColor = "FFD43F"
public let darkGrayColor = "505050"
public func resizeImage(image: UIImage) -> UIImage {
    let widthInPixel: CGFloat = 160
    let widthInPoint = widthInPixel / UIScreen.main.scale
    let size = CGSize(width: widthInPoint, height:
        image.size.height * widthInPoint / image.size.width)
    let renderer = UIGraphicsImageRenderer(size: size)
    let newImage = renderer.image { (context) in
        image.draw(in: renderer.format.bounds)
    }
    
    return newImage
}

