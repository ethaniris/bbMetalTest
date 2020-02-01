//
//  ApplyView.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/12/6.
//  Copyright © 2019 playplay. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MetalKit
import BBMetalImage


protocol ApplyViewDelegate {
    func saveAllChanges(_imageSets:[ImageShot])
}

class ApplyView: UIView{
    
    
    var delegate: ApplyViewDelegate?
    
    var processedImageView = UIImageView()
    var imageSets:[ImageShot]?
    var filterImageSetsTextures:[FilteredImage]?
    var outputFilteredSmallImages:[UIImage]?
    
    var bigImageTextures:[FilteredImage]?
    var filterSets:[Filter]?
    var values:[Float]?
    var indicator:NVActivityIndicatorView?
    
    let darkGrayColor = "505050"
    var index:Int = 0
    
    lazy var titleLabel:UILabel = {
        var lb = UILabel()
        lb.font = UIFont(name: "Helvetica Bold", size: 14)
        
        lb.textColor = UIColor(hexString: darkGrayColor)
        lb.text = "套用至所有照片？"
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var okBtn:UIButton = {
        var btn = UIButton()
        btn.setBackgroundImage(UIImage(named:"applyAllBtn"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("確認", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 12)
        btn.addTarget(self, action: #selector(processAll), for: .touchUpInside)
        return btn
    }()
    
    lazy var cancelBtn:UIButton = {
        var btn = UIButton()
        btn.setBackgroundImage(UIImage(named:"cancelBtn"), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel!.font = UIFont(name: "Helvetica Bold", size: 12)
        btn.addTarget(self, action: #selector(quit), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var stackView:UIStackView = {
        var sv = UIStackView()
        sv.axis = .horizontal
        return sv
    }()
    
    
    @IBOutlet weak var applyCollectionView: UICollectionView!
    var bgView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("ApplyView", owner: self, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(frame:CGRect, _imageSets:[ImageShot], _values:[Float]) {
        self.init(frame:frame)
        self.imageSets = _imageSets
        self.values = _values
        
        setupView()
    }
    
    func setupView(){
        
        let yellowColor = "FFD43F"
        let applyViewFrame = CGRect(x: 0, y: self.frame.height * 3 / 4, width: self.frame.width, height: self.frame.height / 3)
        bgView.frame = applyViewFrame
        bgView.backgroundColor = UIColor(hexString: yellowColor)
        self.addSubview(bgView)
        bgView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        titleLabel.safeTopAnchor.constraint(equalTo: bgView.safeTopAnchor, constant: 5).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        indicator = NVActivityIndicatorView(frame: .zero, type: .ballPulse, color: UIColor(hexString: darkGrayColor), padding: nil)
        bgView.addSubview(indicator!)
        
        indicator!.translatesAutoresizingMaskIntoConstraints = false
        indicator!.centerXAnchor.constraint(equalTo: bgView.centerXAnchor).isActive = true
        indicator!.safeTopAnchor.constraint(equalTo: bgView.safeTopAnchor, constant: 5).isActive = true
        indicator!.widthAnchor.constraint(equalToConstant: 150).isActive = true
        indicator!.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        let nib = UINib(nibName:"ApplyCell", bundle:nil)
        applyCollectionView.register(nib, forCellWithReuseIdentifier: ApplyCell.identifier)
        applyCollectionView.backgroundColor = .clear
        applyCollectionView.delegate = self
        applyCollectionView.dataSource = self
        bgView.addSubview(applyCollectionView)
        
        stackView = UIStackView(arrangedSubviews: [cancelBtn,okBtn])
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.spacing = 15
        bgView.addSubview(stackView)
        stackView.anchor(top: applyCollectionView.safeBottomAnchor, leading: bgView.safeLeftAnchor, bottom: nil, trailing: bgView.safeRightAnchor, padding: .init(top: 3, left: 70, bottom: -3, right: -70), size: .init(width: self.frame.width - 140, height: 30))
        
        applyCollectionView.anchor(top: titleLabel.safeBottomAnchor, leading: bgView.safeLeftAnchor, bottom: nil, trailing: bgView.safeRightAnchor, padding: .init(top: 3, left: 5, bottom: 0, right: -5), size: .init(width: self.frame.width - 10, height: 65))
        
        let pFrame = CGRect(x: 0, y: 50, width: self.frame.width * 3 / 4, height: self.frame.height / 1.7)
        self.addSubview(processedImageView)
        processedImageView.frame = pFrame
        processedImageView.center.x = self.center.x
        processedImageView.layer.cornerRadius = 20
        //processedImageView.backgroundColor = .red
        processedImageView.contentMode = .scaleAspectFit
        
    }
    
    @objc func quit(){
        self.removeFromSuperview()
    }
    
    
    @objc func processAll(){
        titleLabel.isHidden = true
        DispatchQueue.main.async {[weak self] in
            self!.indicator?.startAnimating()
        }
        
        saveAll()
        
    }
    
    private func saveAll(){
        
        
        //        let semaphore = DispatchSemaphore(value: 0)
        //        let queue = DispatchQueue.global()
        //
        //        for index in 0..<imageSets!.count {
        //            queue.async {[weak self] in
        //                if semaphore.wait(timeout: .now()) == .success {
        //
        //
        //
        //                    let bigFilteredImage = FilteredImage(_texture: self!.imageSets![index].texture)
        //
        //                    let bigImage = bigFilteredImage.chainFilters(values: self!.values!)
        //                                  let smallImage = resizeImage(image: bigImage)
        //                                  let bigImageShot = ImageShot(_image: bigImage, _texture: bigImage.bb_metalTexture!, _filterType: nil, _isSelected: false, _smallTexture: smallImage.bb_metalTexture!)
        //
        //                                  //存檔
        //                    self!.imageSets![index] = bigImageShot
        //                    print("index processed:\(index)")
        //                    semaphore.signal()
        //                }
        //            }
        //        }
        //
        //        processAll()
        
        //save every big images from index 0
        
        let bigFilteredImage = FilteredImage(_texture: imageSets![index].texture)
        
        let bigImage = bigFilteredImage.chainFilters(values: values!)
        let smallImage = resizeImage(image: bigImage)
        let bigImageShot = ImageShot(_image: bigImage, _texture: bigImage.bb_metalTexture!, _filterType: nil, _isSelected: false, _smallTexture: smallImage.bb_metalTexture!)
        
        //存檔
        imageSets![index] = bigImageShot
        
        //bigFilteredImage.releaseMemory()
        
        print("存第\(index + 1)張")
        
        // index += 1
        index += 1
        
        //判斷是否在再做
        if index < imageSets!.count {
            return saveAll()
            
        } else {
            
            index = 0
            processAllUI()
            
        }
    }
    
    
    private func processAllUI(){
        titleLabel.isHidden = true
        indicator?.startAnimating()
        
        let groupQueue = DispatchGroup()
        
        let _  = DispatchQueue.global(qos: .userInitiated)
        
        var outputTempFilteredImages = [UIImage]()
        
        DispatchQueue.concurrentPerform(iterations: imageSets!.count) {[weak self] (index) in
            let smallImageTexture = self?.imageSets![index].smallTexture
            let smallFilterImage = FilteredImage(_texture: smallImageTexture!)
            //tempFilteredImages.append(smallFilterImage)
            
            groupQueue.enter()
            let outputSmallImage = smallFilterImage.chainFilters(values: (self?.values!)!)
            groupQueue.leave()
            
            outputTempFilteredImages.append(outputSmallImage)
            
        }
        self.outputFilteredSmallImages = outputTempFilteredImages
        
        groupQueue.notify(queue: DispatchQueue.main) {[weak self] in
             self?.indicator?.stopAnimating()
                           self?.applyCollectionView.reloadData()
            self?.delegate?.saveAllChanges(_imageSets: (self?.imageSets!)!)
        }
        
        
    }
    
    
    private func processAllUI2(){
        
        let myDataQueue = DispatchQueue(label: "DataQueue",
                                        qos: .userInitiated,
                                        attributes: .concurrent,
                                        autoreleaseFrequency: .workItem,
                                        target: nil)
        titleLabel.isHidden = true
        indicator?.startAnimating()
        
        // .barrier flag 告訴佇列，這個特定工作項目需要在沒有其他平行執行的項目時執行
        myDataQueue.async(flags: .barrier) {[weak self] in
            //var tempFilters = [Filter]()
            //var tempFilteredImages = [FilteredImage]()
            var outputTempFilteredImages = [UIImage]()
            
            for i in 0 ..< self!.imageSets!.count{
                
                //做一組一樣value的filter
                //                        let newFilter = Filter(_filterName: "temp", _values: self!.values!, _currentValue: 0)
                //                        tempFilters.append(newFilter)
                
                //做小圖供改變
                
                let smallImageTexture = self!.imageSets![i].smallTexture
                let smallFilterImage = FilteredImage(_texture: smallImageTexture)
                //tempFilteredImages.append(smallFilterImage)
                
                let outputSmallImage = smallFilterImage.chainFilters(values: self!.values!)
                outputTempFilteredImages.append(outputSmallImage)
                
                //smallFilterImage.releaseMemory()
                
            }
            
            //self!.filterSets = tempFilters
            
            self!.outputFilteredSmallImages = outputTempFilteredImages
            //self!.filterImageSetsTextures = tempFilteredImages
            
            DispatchQueue.main.async {[weak self] in
                
                self!.indicator?.stopAnimating()
                self!.applyCollectionView.reloadData()
                self!.delegate?.saveAllChanges(_imageSets: self!.imageSets!)
                
            }
        }
    }
}

extension ApplyView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSets?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApplyCell.identifier, for: indexPath) as! ApplyCell
        //顯示小圖
        
        //cell.filter = filterSets?[indexPath.item]
        //cell.filterImageSetsTextures = filterImageSetsTextures?[indexPath.item]
        
        cell.outputFilteredImage = outputFilteredSmallImages?[indexPath.item]
        cell.imageToShow = imageSets?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let processedImage = imageSets?[indexPath.item]
        processedImageView.image = processedImage?.image
        
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 65, height: 65)
        
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
        
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 6
    }
    
}
