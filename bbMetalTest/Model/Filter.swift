//
//  Filter.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/10/13.
//  Copyright © 2019 playplay. All rights reserved.
//

import Foundation
import BBMetalImage


class Filter {
    
    var filterName:String
    var values:[Float]
    var currentValue:Float?

    init(_filterName:String, _values:[Float], _currentValue:Float?) {
        self.filterName = _filterName
        self.values = _values
        self.currentValue = _currentValue

    }
    
}
