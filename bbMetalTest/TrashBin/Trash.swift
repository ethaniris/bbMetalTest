//
//  Trash.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/12/18.
//  Copyright © 2019 playplay. All rights reserved.
//


//12.22 讓所有的小圖都先處理完再顯示到cell裡. 然後試著release掉memory, 不過現在發現filtered完的image 再次要adjust的時候大圖又回到之前的大圖


//12.22 processImage的位置讓跳轉到filter / adjust 的時候大圖錯誤 或無法調整

//
//        var tempFilteredImages = [FilteredImage]()
//
//        for image in imageSets! {
//                let filterImage = FilteredImage(_texture:image.texture)
//
//                                tempFilteredImages.append(filterImage)
//                                   }
//
//        imageSets = tempFilteredImages
//
//
//
//
//        filterTypeStackView.isHidden = false
//        filterCollectionView.reloadData()
//        indicator?.stopAnimating()





//            let myDataQueue = DispatchQueue(label: "DataQueue",
//                                            qos: .userInitiated,
//                                            attributes: .concurrent,
//                                            autoreleaseFrequency: .workItem,
//                                            target: nil)

//            // .barrier flag 告訴佇列，這個特定工作項目需要在沒有其他平行執行的項目時執行
//        myDataQueue.async(flags: .barrier) {[weak self] in
//
//            var tempFilteredImages = [FilteredImage]()
//
//            for _ in self!.defaultFilters{
//                let filterImage = FilteredImage(_texture: self!.imageSets![self!.selectedIndex].texture)
//                    //tempImage = filterImage.chainFilters(values: filter.values)
//
//                    //tempFilteredImages.append(filterImage.outputImage!)
//                tempFilteredImages.append(filterImage)
//                   }
//
//            self!.filteredImages = tempFilteredImages
//
//                DispatchQueue.main.async {[weak self] in
//
//                    self!.filterTypeStackView.isHidden = false
//                    self!.filterCollectionView.reloadData()
//                    self!.indicator?.stopAnimating()
//            }
//        }


//        brightFilter.brightness = values[0]
//        exposeFilter.exposure = values[1]
//        contrastFilter.contrast = values[2]
//        saturateFilter.saturation = values[3]
//        gammaFilter.gamma = values[4]
//        hueFilter.hue = values[5]
//        vibranceFilter.vibrance = values[6]
//        whiteBalanceFilter.temperature = values[7]
//        monochromeFilter.intensity = values[8]
//        hazeFilter.distance = values[9]
//        sharpenFilter.sharpeness = values[10]
//        redFilter.red = values[11] / 255
//        greenFilter.green = values[12] / 255
//        blueFilter.blue = values[13] / 255


/*
 
 extension UIImageView
 {
     func downloadFrom(link:String?, contentMode mode: UIView.ContentMode)
     {
         contentMode = mode
         if link == ""
         {
             self.image = UIImage(named: "avatar.png")
             return
         }
         if let url = NSURL(string: link!)
         {
             //print("\nstart download: \(url.lastPathComponent!)")
             URLSession.shared.dataTask(with: url as URL, completionHandler: { [weak self] (data, _, error) -> Void in
                 guard let data = data, error == nil else {
                     //      print("\nerror on download \(String(describing: error))")
                     return
                 }
                 
                 DispatchQueue.main.async() { () -> Void in
                     //    print("\ndownload completed \(url.lastPathComponent!)")
                     self?.image = UIImage(data: data)
                 }
             }).resume()
         }
         else
         {
             self.image = UIImage(named: "avatar.png")
         }
         
     }
 }
 */




//存擋時留存用
//            var processedImage = [ImageShot]()
//
//            for image in self!.imageSets!{
//               print("processing all pics")
//                //let filterImage = FilteredImage(_texture: image.image.bb_metalTexture!)
//                let filterImage = FilteredImage(_texture: image.texture).chainFilters(values: self!.values!)
//
//                let filterImageShot = ImageShot(_image: filterImage, _texture: filterImage.bb_metalTexture!, _filterType: nil, _isSelected: false, _smallTexture: filterImage.bb_metalTexture!)
//                processedImage.append(filterImageShot)
//            }
            
//            self!.imageSets = processedImage
