//
//  FilterSlider.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/10/20.
//  Copyright © 2019 playplay. All rights reserved.
//

import UIKit
import BBMetalImage

class FilterSlider: UISlider {

    
    var texture:MTLTexture?
    var filterType: FilterType?

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, _filterType: FilterType?) {
        self.init(frame: frame)
        
        self.filterType = _filterType

        tintColor = #colorLiteral(red: 0.9691699147, green: 0.8090624213, blue: 0.2438488007, alpha: 1)
        value = 0
        minimumValue = -1
        maximumValue = 1
        isContinuous = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
