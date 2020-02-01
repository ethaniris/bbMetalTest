//
//  MultiBtnView.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/11/2.
//  Copyright © 2019 playplay. All rights reserved.
//

import UIKit

class MultiBtnView: UIStackView {
    
    
    lazy var returnBtn:UIButton = {
       var btn = UIButton()
        btn.backgroundColor = .red
        btn.frame.size = CGSize(width: 100, height: 100)
        return btn
    }()
    lazy var deleteBtn:UIButton = {
       var btn = UIButton()
        btn.backgroundColor = .orange
        btn.frame.size = CGSize(width: 100, height: 100)

        return btn
    }()
    lazy var selectAllBtn:UIButton = {
       var btn = UIButton()
        btn.backgroundColor = .yellow
        btn.frame.size = CGSize(width: 100, height: 100)

        return btn
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.arrangedSubviews = [returnBtn, deleteBtn, selectAllBtn]
            self.axis = .horizontal
            self.alignment = .fill
            self.distribution = .fillEqually
            self.backgroundColor = .red
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
