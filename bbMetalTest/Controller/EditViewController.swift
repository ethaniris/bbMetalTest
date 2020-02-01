//
//  EditViewController.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/11/25.
//  Copyright © 2019 playplay. All rights reserved.
//

import UIKit
import BBMetalImage
import MetalKit
import NVActivityIndicatorView

class EditViewController: UIViewController, ApplyViewDelegate {
    
    enum mode{
        case photo
        case filter
        case adjust
        case select
    }
    var modeStatus = mode.photo
    
    enum selectionStatus {
        case allTrue
        case allFalse
        case notAll
    }
    var status = selectionStatus.notAll
    
    var imageZoomView:ImageZoomView!
    var bigImage: FilteredImage?
    //var singleImage:ImageShot?
    
    
    var isSelectionMode:Bool?{
        didSet {
            if !self.isSelectionMode! {
                imageCountLabel.text = ""
            }
        }
        
    }
    var isAllSelected:Bool = false
    
    lazy var selectAllBtn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.system)
        //btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(selectAllBtnClicked), for: .touchUpInside)
        //        btn.setTitle("選擇全部", for: .normal)
        btn.setBackgroundImage(UIImage(named: "selectAllBtn"), for: .normal)
        return btn
    }()
    
    lazy var trashBinBtn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.system)
        //btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(toTrashClicked), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "trashBin"), for: .normal)
        return btn
    }()
    
    lazy var undoBtn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.system)
        //btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(undoBtnClicked), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "undoBtn"), for: .normal)
        return btn
    }()
    
    lazy var processAllBtn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.system)
        //        btn.setTitle("全部套用", for: .normal)
        //        btn.setTitleColor(.black, for: .normal)
        let attr = NSAttributedString.init(string: "全部套用", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font:UIFont(name: "Helvetica Bold", size: 12)!])
        btn.setAttributedTitle(attr, for: .normal)
        //btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(processAllBtnClicked), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "processAllBtn"), for: .normal)
        return btn
    }()
    
    lazy var confirmBtn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.system)
        //        btn.setTitle("全部套用", for: .normal)
        //        btn.setTitleColor(.black, for: .normal)
        let attr = NSAttributedString.init(string: "確認修改", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font:UIFont(name: "Helvetica Bold", size: 12)!])
        btn.setAttributedTitle(attr, for: .normal)
        //btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(confirmClicked), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "confirmBtn"), for: .normal)
        return btn
    }()
    
    lazy var cancelBtn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.system)
        //        btn.setTitle("全部套用", for: .normal)
        //        btn.setTitleColor(.black, for: .normal)
        let attr = NSAttributedString.init(string: "取消", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font:UIFont(name: "Helvetica Bold", size: 12)!])
        btn.setAttributedTitle(attr, for: .normal)
        //btn.backgroundColor = .blue
        btn.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "cancelBtn"), for: .normal)
        return btn
    }()
    
    
    lazy var f1Btn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.system)
        //btn.backgroundColor = .blue
        //btn.addTarget(self, action: #selector(undoBtnClicked), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "f1on"), for: .normal)
        return btn
    }()
    lazy var f2Btn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.system)
        //btn.backgroundColor = .blue
        //btn.addTarget(self, action: #selector(undoBtnClicked), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "f2off"), for: .normal)
        return btn
    }()
    lazy var f3Btn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.system)
        //btn.backgroundColor = .blue
        //btn.addTarget(self, action: #selector(undoBtnClicked), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "f3off"), for: .normal)
        return btn
    }()
    lazy var f4Btn:UIButton = {
        var btn = UIButton(type: UIButton.ButtonType.system)
        //btn.backgroundColor = .blue
        //btn.addTarget(self, action: #selector(undoBtnClicked), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "f4off"), for: .normal)
        return btn
    }()
    
    
    var imageCountLabel:UILabel = {
        var lb = UILabel()
        lb.contentMode = .right
        return lb
    }()
    
    var backToCameraBtn: UIButton!
    
    var sliderValueForCells:[Float] = []
    
    var sliderTempValue:Float = 0
    
    @IBOutlet weak var groupPhotoCollectionView: UICollectionView!
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    var imageSets:[ImageShot]?
    var deletedImageSets:[ImageShot] = []
    @IBOutlet weak var adjustTableView: UITableView!
    
    var adjustFilters:[Filter] = []
    var defaultFilters:[Filter] = []
    //var filteredImages:[FilteredImage] = []
    //var filteredImages:[FilteredImage]?
    
    var outputFilteredImages:[UIImage]?
    
    
    let api = Fetch.shared
    
    var multiSelectionView:MultiSelectionView?
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    
    var changeRecords = [[Int:Float]]()
    
    lazy var stackView:UIStackView = {
        var sv = UIStackView()
        sv.axis = .horizontal
        return sv
    }()
    
    lazy var filterTypeStackView:UIStackView = {
        var sv = UIStackView()
        sv.axis = .horizontal
        return sv
    }()
    
    var selectedIndex = Int()
    var filterSelectedIndex:Int?
    var adjustDefaultValues = [Float]()
    
    
    var movingValues:[Float] = []
    var movingIndex:[Int] = []
    
    var allImagesSelectedStatus:[Bool] = []
    
    //
    //
    //    var applyControlView:ApplyControlView?
    //
    //    var processedImageView:UIImageView?
    
    
    var applyView:ApplyView?
    
    var indicator:NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        //setupFolderBtn()
    }
    
    
    func setupView(){

        isSelectionMode = false
        //singleImage = imageSets![0]
        
        imageSets![0].isSelected = true
        selectedIndex = 0
        //filterSelectedIndex = nil
        
        self.view.backgroundColor = .black
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height / 2.5)
        
        //指定給adjust用
        bigImage = FilteredImage(_texture: imageSets![0].texture)
        
        //imageZoomView = ImageZoomView(frame: frame, image: bigImage!.outputImage!)
        imageZoomView = ImageZoomView(frame: frame, image: imageSets![0].image)
        self.view.addSubview(imageZoomView)
        
        
        self.view.addSubview(selectAllBtn)
        
        selectAllBtn.anchor(top: imageZoomView.bottomAnchor, leading: nil, bottom: nil, trailing: self.view.safeRightAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: -20), size: .init(width: 35, height: 35))
        self.view.addSubview(trashBinBtn)
        trashBinBtn.anchor(top: selectAllBtn.topAnchor, leading: self.view.safeLeftAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0), size: .init(width: 35, height: 35))
        
        self.view.addSubview(imageCountLabel)
        imageCountLabel.translatesAutoresizingMaskIntoConstraints = false
        imageCountLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageCountLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30).isActive = true
        imageCountLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageCountLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //        imageCountLabel.anchor(top: imageZoomView.safeBottomAnchor, leading: nil, bottom: nil, trailing: imageZoomView.safeRightAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 100, height: 30))
        imageCountLabel.textColor = UIColor(hexString: yellowColor)
        
        
        adjustTableView.backgroundColor = .clear
        adjustTableView.delegate = self
        adjustTableView.dataSource = self
        
        adjustTableView.anchor(top: imageCountLabel.safeBottomAnchor, leading: self.view.safeLeftAnchor, bottom: nil, trailing: self.view.safeRightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: self.view.frame.width, height: self.view.frame.height / 3.5))
        
        stackView = UIStackView(arrangedSubviews: [cancelBtn,confirmBtn, processAllBtn])
        stackView.distribution = .fillEqually
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.spacing = 15
        
        self.view.addSubview(stackView)
        
        stackView.anchor(top: adjustTableView.bottomAnchor, leading: self.view.safeLeftAnchor, bottom: nil, trailing: self.view.safeRightAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: -10), size: .init(width: 200, height: 30))
        stackView.isHidden = true
        
        filterTypeStackView = UIStackView(arrangedSubviews: [f1Btn, f2Btn, f3Btn, f4Btn])
        filterTypeStackView.distribution = .fillEqually
        filterTypeStackView.isLayoutMarginsRelativeArrangement = true
        filterTypeStackView.spacing = 10
        self.view.addSubview(filterTypeStackView)
        filterTypeStackView.anchor(top: imageZoomView.bottomAnchor, leading: self.view.safeLeftAnchor, bottom: nil, trailing: self.view.safeRightAnchor, padding: .init(top: 50, left: 40, bottom: 0, right: -40), size: .init(width: self.view.frame.width - 80, height: 12))
        filterTypeStackView.isHidden = true
        
        filterCollectionView.backgroundColor = .clear
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.anchor(top: filterTypeStackView.bottomAnchor, leading: self.view.safeLeftAnchor, bottom: nil, trailing: self.view.safeRightAnchor, padding: .init(top: 30, left: 20, bottom: 0, right: -20), size: .init(width: self.view.frame.width - 40 , height: 140))
        
        groupPhotoCollectionView.delegate = self
        groupPhotoCollectionView.dataSource = self
        groupPhotoCollectionView.anchor(top: imageCountLabel.safeBottomAnchor, leading: self.view.safeLeftAnchor, bottom: nil, trailing: self.view.safeRightAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: -20), size: .init(width: self.view.frame.width - 40, height: self.view.frame.height / 3.5))
        groupPhotoCollectionView.backgroundColor = .black
        groupPhotoCollectionView.reloadData()
        
        //        self.view.addSubview(processAllBtn)
        //        processAllBtn.anchor(top: imageCountLabel.safeTopAnchor, leading: imageCountLabel.safeRightAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 15, bottom: 0, right: 0), size: .init(width: 100, height: 25))
        //        processAllBtn.isHidden = true
        
        self.view.addSubview(undoBtn)
        undoBtn.frame = CGRect(x: 20, y: self.view.frame.height / 2.5 + 10, width: 25, height: 25)
        undoBtn.isHidden = true
        
        indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 30), type: .ballSpinFadeLoader, color: UIColor(hexString: yellowColor), padding: nil)
        self.view.addSubview(indicator!)
        indicator?.center = self.view.center
        
        
        showGroupPhotoView()
        setupMultiSelectionView()
        
    }
//    func setupFolderBtn(){
//
//        backToCameraBtn = UIButton(type: UIButton.ButtonType.system)
//
//        backToCameraBtn.setBackgroundImage(UIImage(named: "openCameraBtn"), for: .normal)
//
//        self.view.addSubview(backToCameraBtn)
//
//        backToCameraBtn.anchor(top: nil, leading: self.view.safeLeftAnchor, bottom: self.view.safeBottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: -10, right: 0), size: .init(width: 50, height: 50))
//
//        backToCameraBtn.addTarget(self, action: #selector(self.backToCameraBtnClicked), for: .touchUpInside)
//    }
    
    
    func processFilteredImages(){
        
        indicator?.startAnimating()
        //filteredImages?.removeAll(keepingCapacity: false)
        outputFilteredImages?.removeAll(keepingCapacity: false)
        
        let myDataQueue = DispatchQueue(label: "DataQueue",
                                        qos: .userInitiated,
                                        attributes: .concurrent,
                                        autoreleaseFrequency: .workItem,
                                        target: nil)
        
        // .barrier flag 告訴佇列，這個特定工作項目需要在沒有其他平行執行的項目時執行
        myDataQueue.async(flags: .barrier) {[weak self] in
            
            //var tempFilteredImages = [FilteredImage]()
            var tempOutputFilterImage = [UIImage]()
            
            //顯示小圖
            for filter in self!.defaultFilters {
                let smallTexture = self!.imageSets![self!.selectedIndex].smallTexture
                let filterImage = FilteredImage(_texture:smallTexture)
                
                
                let outputFilterImage = filterImage.chainFilters(values: filter.values)
          
                //filterImage.releaseMemory()
                tempOutputFilterImage.append(outputFilterImage)
                //tempFilteredImages.append(filterImage)
            }
            
            self!.outputFilteredImages = tempOutputFilterImage
            //self!.filteredImages = tempFilteredImages
            
            DispatchQueue.main.async {[weak self] in
                
                self!.filterTypeStackView.isHidden = false
                self!.filterCollectionView.reloadData()
                self!.indicator?.stopAnimating()
            }
        }

    }
    deinit {
        print("edit view deinit")
    }
    
    
    func displaySaveBtnCount(){
        //算儲存數量
        var imageToSaveCount:Int = 0
        
        for image in imageSets! {
            if image.isSelected {
                imageToSaveCount += 1
            }
        }
        //multiSelectionView?.selectedSaveBtn.setTitle("\(imageToSaveCount)", for: .normal)
        
        imageCountLabel.text = "已選擇\(imageToSaveCount)張照片"
    }
    
    @objc func showGroupPhotoView(){
        modeStatus = .photo
        trashBinBtn.isHidden = false
        filterCollectionView.isHidden = true
        adjustTableView.isHidden = true
        groupPhotoCollectionView.isHidden = false
        
    }
    
    @objc func backToCameraBtnClicked(){
        for image in imageSets!{
            image.isSelected = false
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupMultiSelectionView(){
        
        //hide camera and save btn
        
        let frame = CGRect()
        multiSelectionView = MultiSelectionView(frame: frame)
        self.view.addSubview(multiSelectionView!)
        self.view.bringSubviewToFront(multiSelectionView!)
        
        
        multiSelectionView?.anchor(top: nil, leading: self.view.safeLeftAnchor, bottom: self.view.safeBottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0), size: .init(width: width, height: 100))
        
        
        multiSelectionView?.stackView.fillSupervivew()
        
        multiSelectionView?.returnBtn.addTarget(self, action: #selector(self.returnBtnClicked), for: .touchUpInside)
        multiSelectionView?.deleteBtn.addTarget(self, action: #selector(self.deleteAlert), for: .touchUpInside)
        //multiSelectionView?.selectAllBtn.addTarget(self, action: #selector(self.selectAllBtnClicked), for: .touchUpInside)
        multiSelectionView?.adjustBtn.addTarget(self, action: #selector(self.showAdjustView), for: .touchUpInside)
        multiSelectionView?.filterBtn.addTarget(self, action:#selector(self.showFilterView), for: .touchUpInside)
        
        multiSelectionView?.selectedSaveBtn.titleLabel?.textColor = .white
        multiSelectionView?.selectedSaveBtn.titleLabel?.textAlignment = .center
        multiSelectionView?.selectedSaveBtn.addTarget(self, action: #selector(self.selectedSaveBtnClicked), for: .touchUpInside)
        
    }
    
    func checkSelectionStatus(){
        
        var counter:Int = 0
        for image in imageSets! {
            if image.isSelected {
                counter += 1
            }
            if counter == imageSets!.count {
                status = selectionStatus.allTrue
            } else if counter == 0 {
                status = selectionStatus.allFalse
            } else {
                status = selectionStatus.notAll
            }
        }
        
        switch  status {
        case .allTrue:
            
            selectAllBtn.setBackgroundImage(UIImage(named: "unselectAllBtn.png"), for: .normal)
            isAllSelected = true
        case .allFalse:
            
            selectAllBtn.setBackgroundImage(UIImage(named: "selectAllBtn.png"), for: .normal)
            isAllSelected = false
        case .notAll:
            selectAllBtn.setBackgroundImage(UIImage(named: "selectAllBtn.png"), for: .normal)
            isAllSelected = false
            
            break
            
        }
    }

}


extension EditViewController: UICollectionViewDelegate, UICollectionViewDataSource,CardCellDelegate {
    func didSwipe(cell: CardCell) {
        
        //guard let indexPath = groupPhotoCollectionView.indexPath(for: cell) else{return}
    }
    
    func didTapOnce(cell: CardCell) {
        guard let indexPath = groupPhotoCollectionView.indexPath(for: cell) else{return}
        
        
        let selectedImage = imageSets![indexPath.item]
        selectedIndex = indexPath.item
        
        bigImage = FilteredImage(_texture: selectedImage.texture)
        
        imageZoomView.imageView.image = selectedImage.image
        
        if !isSelectionMode!{
            for image in imageSets!{
                image.isSelected = false
            }
            imageSets![indexPath.item].isSelected = true
            groupPhotoCollectionView.reloadData()
        }
    }
    
    func didLongPress(cell: CardCell) {
        guard let indexPath = groupPhotoCollectionView.indexPath(for: cell) else{return}
        modeStatus = .select
        isAllSelected = false
        isSelectionMode = true
        
        imageSets![indexPath.row].isSelected = true
        groupPhotoCollectionView.reloadData()
        
        //        filterBtn.isEnabled = false
        //        adjustBtn.isEnabled = false
        //
        //        filterBtn.setTitle("", for: .normal)
        //        adjustBtn.setTitle("", for: .normal)
        
        displaySaveBtnCount()
    }
    
    
    
    func didCheck(cell: CardCell) {
        guard let indexPath = groupPhotoCollectionView.indexPath(for: cell) else{return}
        
        
        imageSets![indexPath.row].isSelected = !imageSets![indexPath.row].isSelected
        groupPhotoCollectionView.reloadData()
        checkSelectionStatus()
        displaySaveBtnCount()
        
        
        //沒有圖就顯示圖
        //if imageZoomView.imageView.image == UIImage(){
        imageZoomView.imageView.image = imageSets![indexPath.row].image
        selectedIndex = indexPath.row
        //}
        
        var isDisplayImage = false
        
        //沒有選擇到的圖就黑
        for image in imageSets! {
            
            if image.isSelected{
                isDisplayImage = true
                break
            }
        }
        
        if !isDisplayImage {
            imageZoomView.imageView.image = UIImage()
        }
        
        //若取消掉有選到的圖 就找第一個圖為顯示圖, 沒圖就黑
        var counters:[Bool] = []
        if !imageSets![selectedIndex].isSelected{
            for image in imageSets!{
                counters.append(image.isSelected)
            }
            if counters.contains(true) {
                for i in 0 ..< counters.count {
                    if counters[i] == true {
                        imageZoomView.imageView.image = imageSets![i].image
                        selectedIndex = i
                        break
                    }
                }
                
            } else {
                imageZoomView.imageView.image = UIImage()
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == groupPhotoCollectionView {
            
            return imageSets?.count ?? 0
        } else {
            return defaultFilters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == groupPhotoCollectionView {
            let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: indexPath) as! CardCell
            
            cardCell.isSelectionMode = isSelectionMode
            
            cardCell.imageToShow = imageSets![indexPath.row]
            
            cardCell.cellDelegate = self
            
            if imageSets![indexPath.row].isSelected {
                cardCell.cellImageView.layer.borderColor = UIColor(hexString: yellowColor).cgColor
                cardCell.cellImageView.layer.borderWidth = 2
            }
            else {
                cardCell.cellImageView.layer.borderColor = UIColor.clear.cgColor
                cardCell.cellImageView.layer.borderWidth = 0
            }
            
            cardCell.cellImageView.layer.cornerRadius = 5
            
            return cardCell
            
        } else {
            
            let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FiltersCell
            
            filterCell.filter = defaultFilters[indexPath.item]
            //filterCell.image = filteredImages?[indexPath.item]
            filterCell.outputImage = outputFilteredImages![indexPath.item]
            
            return filterCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == filterCollectionView {
            //chain values
            filterSelectedIndex = indexPath.item
            
            
            //處理大圖顯示
//            let bigSizeImageTexture = imageSets![selectedIndex].texture
//            let bigFilterImage = FilteredImage(_texture: bigSizeImageTexture)
            bigImage = FilteredImage(_texture: imageSets![selectedIndex].texture)
            
            let outputImage = bigImage?.chainFilters(values: defaultFilters[filterSelectedIndex!].values)
            
            imageZoomView.imageView.image = outputImage
            stackView.isHidden = false
        }
    }
}


extension EditViewController: UICollectionViewDelegateFlowLayout{
    
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if collectionView == filterCollectionView {
            return CGSize(width: 90, height: 140)
        } else {
            return CGSize(width: 90, height: 90)
        }
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 10
        
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
}

extension EditViewController: UITableViewDelegate, UITableViewDataSource, AdjustCellDelegate {
    
    
    func getLastValue(){
        
        if movingValues.count > 0 {
            let lastValue = movingValues.last
            changeRecords.append([movingIndex.last!:lastValue!])
            movingValues.removeAll(keepingCapacity: false)
            movingIndex.removeAll(keepingCapacity: false)
            
            stackView.isHidden = false
            undoBtn.isHidden = false
            
            
        } else {
            
            print("first time")
        }
        
    }
    
    func didSlide(cell: AdjustCell, value: Float) {
        guard let indexPath = adjustTableView.indexPath(for: cell) else{return}
        
        movingValues.append(value)
        sliderValueForCells[indexPath.row] = value
        sliderTempValue = value
        movingIndex.append(indexPath.row)
        
        
        let middleValue = (adjustFilters[indexPath.row].values[0] + adjustFilters[indexPath.row].values[1]) / 2
        let allValue = adjustFilters[indexPath.row].values[1] - adjustFilters[indexPath.row].values[0]
        let unitValue =  allValue / 2
        
        if value ==  0 {
            sliderTempValue = middleValue
        } else if value < 0 {
            sliderTempValue = middleValue - unitValue * -value } else if value > 0 {
            sliderTempValue = middleValue + unitValue * value }
        
        adjustFilters[indexPath.row].currentValue = sliderTempValue
        
        
        let processedImage = bigImage?.changeValue(filterIndex: indexPath.row, value: sliderTempValue)
        
        
        imageZoomView?.imageView.image = processedImage
        
        adjustTableView.reloadData()
        stackView.isHidden = false
        undoBtn.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adjustFilters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adjustCell = tableView.dequeueReusableCell(withIdentifier: "adjustCell", for: indexPath) as! AdjustCell
        adjustCell.filter = adjustFilters[indexPath.row]
        adjustCell.filterSlider?.value = sliderValueForCells[indexPath.row]
        adjustCell.cellDelegate = self
        return adjustCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

//multi Button Function
extension EditViewController:UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "title"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return"text here"
    }
    
    
    @objc func showAdjustView(){
        
        if modeStatus != .adjust {
            
            //假如filter有設定
            if filterSelectedIndex != nil {
                
                exitAlert(mode: .adjust)
                
                
            } else {
            
            
               bigImage?.processImage()
            
                filterTypeStackView.isHidden = true
                modeStatus = .adjust
            
            selectAllBtn.isHidden = true
            //undoBtn.isHidden = false
            api.start(_list: .adjustList) {[weak self] (fetchFilters) in
                self!.adjustFilters = fetchFilters
                self!.sliderValueForCells = Array(repeating: 0, count: self!.adjustFilters.count)
                self!.adjustTableView.reloadData()
            }
            
            
            adjustDefaultValues.removeAll(keepingCapacity: false)
            //抓預設值, 之後回復可以用
            for adjustFilter in adjustFilters {
                adjustDefaultValues.append(adjustFilter.currentValue!)
            }
            
//            print("values:\(adjustDefaultValues)")
            
            trashBinBtn.isHidden = true
            adjustTableView.isHidden = false
            filterCollectionView.isHidden = true
            groupPhotoCollectionView.isHidden = true
            }
        }
    }
    
    
    @objc func showFilterView(){
        
        if modeStatus != .filter {
        
        //就算是.adjust 值沒有變也可以直接跳到filter
        if changeRecords.count > 0 || movingValues.count > 0{
            exitAlert(mode: .filter)
        }
        else {
            
            modeStatus = .filter
           
            api.start(_list: .filterList) {[weak self] (fetchFilters) in
                self!.defaultFilters = fetchFilters
                self!.processFilteredImages()
            
            }
            if isSelectionMode! {
                stackView.isHidden = false
            }
            
            trashBinBtn.isHidden = true
            selectAllBtn.isHidden = true
            filterCollectionView.isHidden = false
            adjustTableView.isHidden = true
            groupPhotoCollectionView.isHidden = true
        }
        }
    }
    
    
    @objc func returnBtnClicked(){
        
        //.adjust而且有跳調整過的狀態
        if changeRecords.count > 0 || movingValues.count > 0{

            if movingValues.count > 0 {
            changeRecords.append([movingIndex.last!:movingValues.last!])
            movingValues.removeAll(keepingCapacity: false)
            movingIndex.removeAll(keepingCapacity: false)
            }
            
            exitAlert(mode: .photo)
            
        } else if filterSelectedIndex != nil {
            
             //假如有選擇filter
            print("filter changed")
            
            exitAlert(mode: .photo)
        } else{
            
            //目前為共同的跳出功能


            selectedIndex = 0
            filterSelectedIndex = nil
            
            stackView.isHidden = true
            undoBtn.isHidden = true
            
            selectAllBtn.isHidden = false
            changeRecords.removeAll(keepingCapacity: false)
            
            //隱藏check
            isSelectionMode = false
            
            for image in imageSets!{
                image.isSelected = false
            }
            imageSets![0].isSelected = true
            
            bigImage = FilteredImage(_texture: imageSets![0].texture)
            imageZoomView.imageView.image = imageSets![0].image
            
            checkSelectionStatus()
            
            groupPhotoCollectionView.reloadData()
            
            switch modeStatus {
            case .adjust,.select:
                showGroupPhotoView()
                
            case .filter:
                filterTypeStackView.isHidden = true
                defaultFilters.removeAll(keepingCapacity: false)
                //filteredImages?.removeAll(keepingCapacity: false)
                outputFilteredImages?.removeAll(keepingCapacity: false)
                
                //filterCollectionView.reloadData()
                showGroupPhotoView()
                
            case .photo:
                self.dismiss(animated: true, completion: nil)
            }
            }
        
        
    }
    
    func deleteFunc(completion: @escaping () -> ()){
        var tempImageSets:[ImageShot] = []
        var currentIndex = Int()
        
        //留下沒選到的, 指定好下一個的index
        for i in 0 ..< imageSets!.count {
            
            if !imageSets![i].isSelected {
                //images to be left
                tempImageSets.append(imageSets![i])
            } else {
                                
                //新增到刪除的照片
                deletedImageSets.append(imageSets![i])
                
                if !isSelectionMode! {
                    
                    currentIndex = i
                }
            }
        }
        
        //設定給圖的array
        imageSets = tempImageSets
        
        //顯示新的圖
        var firstImage:ImageShot!
        if imageSets!.count > 0 {
            if isSelectionMode! {
                firstImage = imageSets![0]
            } else {
                if currentIndex > 0 {
                    currentIndex -= 1
                }
                firstImage = imageSets![currentIndex]
            }
            firstImage.isSelected = true
            bigImage = FilteredImage(_texture: firstImage.image.bb_metalTexture!)
            imageZoomView.imageView.image = firstImage.image
        } else {
            //沒有大圖了
            
        }
        
        checkSelectionStatus()
        groupPhotoCollectionView.reloadData()
        
        switch modeStatus{
            
        case .filter:
            filterSelectedIndex = nil
         returnBtnClicked()
        case .adjust:
            movingIndex.removeAll(keepingCapacity: false)
            movingValues.removeAll(keepingCapacity: false)
            changeRecords.removeAll(keepingCapacity: false)
            returnBtnClicked()
        case .select:
            showGroupPhotoView()
        
        default:
            break
        }
        
        
        
//        if isSelectionMode! {
//            returnBtnClicked()
//        } else {
//            showGroupPhotoView()
//        }
        completion()
        
    }
    
    @objc func processAllBtnClicked(){
        
        let aFrame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height / 1.3)
        var valuesToPass = [Float]()
        switch modeStatus {
        case .filter:
            valuesToPass = defaultFilters[filterSelectedIndex!].values
        case .adjust:
            valuesToPass = bigImage!.valuesForAll
        //print(valuesToPass)
        default:
            break
        }
        
//        let currentImage = imageZoomView.imageView.image
//        let currentImageTexture = currentImage?.bb_metalTexture
//        let smallcurrentImageTexture = resizeImage(image: currentImage!).bb_metalTexture
//        let currentImageShot = ImageShot(_image: currentImage!, _texture: currentImageTexture!, _filterType: nil, _isSelected: false, _smallTexture: smallcurrentImageTexture!)
        

        
        applyView = ApplyView(frame: aFrame, _imageSets: imageSets!, _values: valuesToPass)
        applyView?.delegate = self
        
        self.view.addSubview(applyView!)
    }
    
    func saveAllChanges(_imageSets:[ImageShot]){
        
        switch modeStatus {
        case .filter:
            print("filter all photos")
            
            imageSets = _imageSets
            let bigImageToEdit = imageSets![selectedIndex]
            bigImage = FilteredImage(_texture: bigImageToEdit.texture)
            
            showAlert(title: "套用成功", message: "", isCompletion: true)
            stackView.isHidden = true
            filterSelectedIndex = nil
            processFilteredImages()
            
        case .adjust:
            
            print("adjust all photos")
            imageSets = _imageSets
            bigImage = FilteredImage(_texture: imageSets![selectedIndex].texture)
            bigImage?.processImage()
            
            showAlert(title: "套用成功", message: "", isCompletion: true)
            
            changeRecords.removeAll(keepingCapacity: false)
            movingIndex.removeAll(keepingCapacity: false)
            movingValues.removeAll(keepingCapacity: false)
            
            
            undoBtn.isHidden = true
            stackView.isHidden = true
            sliderValueForCells = Array(repeating: 0, count: adjustFilters.count)
            for i in 0 ..< adjustFilters.count{
                adjustFilters[i].currentValue = adjustDefaultValues[i]
            }
            
            adjustTableView.reloadData()
            
        default:
            break
        }
        
        
        
        
    }
    
    
    @objc func selectAllBtnClicked(){
        print("select all")
        
        showGroupPhotoView()
        isSelectionMode = true
        
        if isAllSelected == false {
            for image in imageSets!{
                image.isSelected = true
            }
            selectAllBtn.setBackgroundImage(UIImage(named:"unselectAllBtn.png"), for: .normal)
            isAllSelected = true
            imageZoomView.imageView.image = imageSets![0].image
            selectedIndex = 0
            filterSelectedIndex = nil
            
        } else {
            
            for image in imageSets!{
                image.isSelected = false
            }
            selectAllBtn.setBackgroundImage(UIImage(named:"selectAllBtn.png"), for: .normal)
            isAllSelected = false
            
            imageZoomView.imageView.image = UIImage()
            
        }
        displaySaveBtnCount()
        groupPhotoCollectionView.reloadData()
        modeStatus = .select
        
    }
    
    @objc func undoBtnClicked(){
        if movingValues.count > 0 {
            changeRecords.append([movingIndex.last!:movingValues.last!])
            movingValues.removeAll(keepingCapacity: false)
            movingIndex.removeAll(keepingCapacity: false)
        }
        //抓最後一組
        let undoDict = changeRecords.last
        //蒐集所有紀錄裡相同Key
        var numberGets = [Float]()
        //計算出前一組與最後一組的差別
        var valueDif = Float()
        //1. 如果沒有別組就抓default 2.有別組就抓前一組
        for (k,v) in undoDict!{
            let newChangeRecords = changeRecords.dropLast()
            if newChangeRecords.count == 0 {
                valueDif = v
            } else {
                for d in newChangeRecords {
                    for (sk,sv) in d {
                        if sk == k {
                            numberGets.append(sv)
                        }
                    }
                }
                if numberGets.count == 0 {
                    valueDif = v
                } else {
                    let preValue = numberGets.last
                    valueDif = v - preValue!
                }
            }
            sliderValueForCells[k] -= valueDif
            sliderTempValue -= valueDif
            
            let allValue = adjustFilters[k].values[1] - adjustFilters[k].values[0]
            let unitValue =  allValue / 2
            
            adjustFilters[k].currentValue! -= valueDif * unitValue
            //print("final:\(adjustFilters[k].currentValue!)")
            
            changeRecords.removeLast()
            
            let processedImage = bigImage?.changeValue(filterIndex: k, value: adjustFilters[k].currentValue!)
            
            imageZoomView?.imageView.image = processedImage
            
            adjustTableView.reloadData()
        }
        
        if changeRecords.count == 0 {    
            undoBtn.isHidden = true
            stackView.isHidden = true
            
        }
    }
    @objc func cancelClicked(){
        
        switch modeStatus{
        case .filter:
            imageZoomView?.imageView.image = imageSets![selectedIndex].image
            showAlert(title: "取消調整", message: "", isCompletion: false)
            filterSelectedIndex = nil
            stackView.isHidden = true
            filterCollectionView.reloadData()
            
        case .adjust:
            imageZoomView?.imageView.image = imageSets![selectedIndex].image
            
            showAlert(title: "取消調整", message: "", isCompletion: false)
            changeRecords.removeAll(keepingCapacity: false)
            movingIndex.removeAll(keepingCapacity: false)
            movingValues.removeAll(keepingCapacity: false)
            
            undoBtn.isHidden = true
            
            stackView.isHidden = true
            
            sliderValueForCells = Array(repeating: 0, count: adjustFilters.count)
            for i in 0 ..< adjustFilters.count{
                adjustFilters[i].currentValue = adjustDefaultValues[i]
            }
            
            
            adjustTableView.reloadData()
        default:
            break
            
        }
    }
    
    @objc func confirmClicked(){

        let imageToSave = (imageZoomView?.imageView.image!)!
        let smallImage = resizeImage(image: imageToSave)
        
        let bigImageShot = ImageShot(_image: imageToSave, _texture: imageToSave.bb_metalTexture!, _filterType: nil, _isSelected: false, _smallTexture: smallImage.bb_metalTexture!)
        
        //要這樣才能正常的調整大圖, if you need to call bigImage
        bigImage = FilteredImage(_texture: bigImageShot.texture)
        
        //save image
        imageSets![selectedIndex] = bigImageShot
        showAlert(title: "儲存成功", message: "", isCompletion: false)
        
        stackView.isHidden = true
        
        
        
        switch modeStatus {
        case . filter:
            
            filterSelectedIndex = nil
            processFilteredImages()
        case .adjust:
        

            changeRecords.removeAll(keepingCapacity: false)
            undoBtn.isHidden = true
            stackView.isHidden = true
            
            movingIndex.removeAll(keepingCapacity: false)
            movingValues.removeAll(keepingCapacity: false)
            
            sliderValueForCells = Array(repeating: 0, count: adjustFilters.count)
            for i in 0 ..< adjustFilters.count{
                adjustFilters[i].currentValue = adjustDefaultValues[i]
            }
            
            adjustTableView.reloadData()
            
        default:
            break
        }
        
    }
    
    @objc func toTrashClicked(){
        print("to trash bin")
        performSegue(withIdentifier: "toTrashVc", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "toTrashVc" {
            if let destineVC = segue.destination as? TrashViewController{
                destineVC.modalPresentationStyle = .fullScreen
                destineVC.deletedImages = deletedImageSets
                
                if #available(iOS 13.0, *) {
                    destineVC.isModalInPresentation = false
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        
        
    }
    
    
    @objc func selectedSaveBtnClicked(){
        
        print("save clicked")
        let image = imageZoomView.imageView.image!
        let image2 = imageSets![2].image
        
        let avc = UIActivityViewController(activityItems: [image,image2], applicationActivities: nil)
        avc.completionWithItemsHandler = {[weak self](activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?)in
        }
        present(avc, animated: true)
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlert(title: "儲存失敗", message: error.localizedDescription, isCompletion: false)
        } else {
            showAlert(title: "Saved!", message: "Your image has been saved to your photos.", isCompletion: false)
        }
    }
    
    
    
    
    @objc func deleteAlert(){
        let ac = UIAlertController(title: "", message: "確定丟到垃圾桶？", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "刪除", style: .destructive) {[weak self] (＿) in
            self!.deleteFunc {[weak self] in
                self!.showAlert(title: "", message: "已丟到垃圾桶", isCompletion: false)
            }
        }
        ac.addAction(okAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    
    func exitAlert(mode:mode){
        let ac = UIAlertController(title: "尚未儲存", message: "要儲存修改圖片的設定嗎?", preferredStyle: .actionSheet)
        let continueAction = UIAlertAction(title: "繼續設定", style: .default, handler: nil)
        
        ac.addAction(continueAction)
        
        let okAction = UIAlertAction(title: "儲存設定", style: .default) {[weak self] (＿) in
            //            self!.activityIndicator.startAnimating()
            //            self!.view.isUserInteractionEnabled = false
            
            self!.confirmClicked()
            //self!.modeStatus = .filter
            
            switch mode{
            case .photo:
                self!.returnBtnClicked()
            case .filter:
                self!.showFilterView()
            case . adjust:
                self!.showAdjustView()
            default:
                break
            }
            
        }
        ac.addAction(okAction)
        let cancelAction = UIAlertAction(title: "放棄設定", style: .destructive) {[weak self] (_) in
            
            self!.leaveWithoutSaving()
            
            switch mode{
            case .photo:
                self!.returnBtnClicked()
            case .filter:
                self!.showFilterView()
          
            case . adjust:
               
                self!.showAdjustView()
            default:
                break
            }
            
        }
        
        ac.addAction(cancelAction)
        
        present(ac, animated: true)
    }
    
    func leaveWithoutSaving(){
        //set ui
        imageZoomView?.imageView.image = imageSets![selectedIndex].image
        
        
        switch modeStatus {
        case .filter:
            filterSelectedIndex = nil
        case .adjust:
            undoBtn.isHidden = true
            changeRecords.removeAll(keepingCapacity: false)
            movingValues.removeAll(keepingCapacity: false)
            movingIndex.removeAll(keepingCapacity: false)
            sliderValueForCells = Array(repeating: 0, count: adjustFilters.count)
                   for i in 0 ..< adjustFilters.count{
                       adjustFilters[i].currentValue = adjustDefaultValues[i]
                   }
                   
            adjustTableView.reloadData()
        default:
            break
            
        }

        stackView.isHidden = true

    }
    
    func showAlert(title: String, message: String, isCompletion:Bool){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {[weak self] (_) in
            if isCompletion{
                self!.applyView!.isHidden = true
            }
        }))
        
        present(ac, animated: true)
        
    }
}



