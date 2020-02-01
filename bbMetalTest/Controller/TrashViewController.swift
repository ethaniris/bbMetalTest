//
//  TrashViewController.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/12/8.
//  Copyright © 2019 playplay. All rights reserved.
//

import UIKit

class TrashViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var trashCollectoinView: UICollectionView!
    lazy var clearAllBtn:UIButton = {
       var btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "processAllBtn"), for: .normal)
        btn.setTitle("清空", for: .normal)
        btn.setTitleColor(UIColor(hexString: darkGrayColor), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Helvetica Bold", size: 16)
        return btn
    }()
    
    lazy var returnBtn:UIButton = {
       var btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "returnBtn"), for: .normal)
        btn.addTarget(self, action: #selector(returnClicked), for: .touchUpInside)
        return btn
    }()
    
    var deletedImages:[ImageShot]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trashCollectoinView.delegate = self
        trashCollectoinView.dataSource = self
        
        trashCollectoinView.anchor(top: self.view.safeTopAnchor, leading: self.view.safeLeftAnchor, bottom: self.view.safeBottomAnchor, trailing: self.view.safeRightAnchor, padding: .init(top: 80, left: 10, bottom: -100, right: -10), size: .zero)
        self.navigationController?.navigationItem.title = "Trash Bin"
        
        self.view.addSubview(clearAllBtn)
        clearAllBtn.anchor(top: self.view.safeTopAnchor, leading: nil, bottom: nil, trailing: self.view.safeRightAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: -20), size: .init(width: 100, height: 30))
        
        self.view.addSubview(returnBtn)
        returnBtn.anchor(top: self.view.safeTopAnchor, leading: self.view.safeLeftAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0), size: .init(width: 35, height: 35))
    }
    

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return deletedImages?.count ?? 0
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trashCell", for: indexPath) as! TrashCell
    
  
    cell.deletedImageView.image = deletedImages![indexPath.item].image

    
    return cell
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    @objc func returnClicked(){
        self.dismiss(animated: true, completion: nil)
    }
}
