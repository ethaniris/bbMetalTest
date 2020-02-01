//
//  multiSelectionView.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/11/2.
//  Copyright © 2019 playplay. All rights reserved.
//

import UIKit

class MultiSelectionView: UIView {
    
    
    
    lazy var returnBtn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setBackgroundImage(UIImage(named: "returnBtn"), for: .normal)
        
        return btn
    }()
    
    lazy var filterBtn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setBackgroundImage(UIImage(named: "filterBtn"), for: .normal)
        
        return btn
    }()
    
    lazy var deleteBtn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setBackgroundImage(UIImage(named: "deleteBtn"), for: .normal)
        
        return btn
    }()
//    lazy var selectAllBtn:UIButton = {
//        var btn = UIButton(type: UIButton.ButtonType.custom)
//        btn.setBackgroundImage(UIImage(named: "selectAllBtn"), for: .normal)
//        
//        return btn
//    }()
    lazy var adjustBtn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setBackgroundImage(UIImage(named: "adjustAllBtn"), for: .normal)
        
        return btn
    }()
    
    lazy var selectedSaveBtn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.custom)
        btn.setBackgroundImage(UIImage(named: "selectedSaveBtn"), for: .normal)
        return btn
        
    }()
    

    lazy var stackView:UIStackView = {
       var sv = UIStackView()
        sv.axis = .horizontal
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView(){
                
        stackView = UIStackView(arrangedSubviews: [returnBtn,filterBtn,adjustBtn,deleteBtn,selectedSaveBtn])
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 30
        stackView.layoutMargins = UIEdgeInsets(top: 32, left: 30, bottom: 30, right: 30)
        
        self.addSubview(stackView)
    }

}
