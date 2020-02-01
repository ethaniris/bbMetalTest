//
//  ViewController.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/10/6.
//  Copyright © 2019 playplay. All rights reserved.
//

import UIKit
import BBMetalImage
import MetalKit



class ViewController: UIViewController{
    
    
    
    @IBOutlet weak var cameraClickedBtn: UIButton!

    
    // Hold camera
    var camera: BBMetalCamera!
    
    var tempTextures:[MTLTexture] = []
    
    var imageSets:[ImageShot] = []

    var filters:[Filter] = []
    
    
    var typeSet:FilterType?
    
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let api = Fetch()
    var metalView = BBMetalView()
    //    var zoomTexture: MTLTexture?
    //    var zoomFilter: FilterType?
    
    var isSelectionMode:Bool = false
    var isAllSelected:Bool = false
    
    
    var folderBtn: UIButton!
    var isFolderOpen: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupFolderBtn()
        simulatorTestLoading()
       //setupCamera()
        
        
    }
    
    
    //simulator Test
    
    func simulatorTestLoading(){
        
        cameraClickedBtn.anchor(top: folderBtn.topAnchor, leading: folderBtn.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0), size: .init(width: 250, height: 50))

        
        //create bg
        let frame = UIScreen.main.bounds
        let bgView = UIImageView(frame: frame)
        bgView.layer.zPosition = -1
        bgView.contentMode = .scaleAspectFill
        self.view.addSubview(bgView)
        bgView.image = UIImage(named: "3.png")
        self.view.bringSubviewToFront(bgView)

            
            for i in 1 ..< 8 {
                
                let bigImage = UIImage(named: "\(i).png")!
                
                let smallImage = resizeImage(image: UIImage(named:"\(i).png")!)

                let image = ImageShot(_image: bigImage,_texture: bigImage.bb_metalTexture!, _filterType: nil, _isSelected: false, _smallTexture: smallImage.bb_metalTexture!)
                
                imageSets.append(image)
            }
        for i in 1 ..< 8 {
            
            let bigImage = UIImage(named: "\(i).png")!
            
            let smallImage = resizeImage(image: UIImage(named:"\(i).png")!)

            let image = ImageShot(_image: bigImage,_texture: bigImage.bb_metalTexture!, _filterType: nil, _isSelected: false, _smallTexture: smallImage.bb_metalTexture!)
            
            imageSets.append(image)
        }
        for i in 1 ..< 8 {
            
            let bigImage = UIImage(named: "\(i).png")!
            
            let smallImage = resizeImage(image: UIImage(named:"\(i).png")!)

            let image = ImageShot(_image: bigImage,_texture: bigImage.bb_metalTexture!, _filterType: nil, _isSelected: false, _smallTexture: smallImage.bb_metalTexture!)
            
            imageSets.append(image)
        }
        

            
    }
    

    
    
    func setupCamera() {
                
//        cameraClickedBtn.anchor(top: nil, leading: self.view.safeLeftAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 55))
        
        cameraClickedBtn.anchor(top: folderBtn.topAnchor, leading: folderBtn.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0), size: .init(width: 250, height: 50))
        
        cameraClickedBtn.addTarget(self, action: #selector(self.cameraClicked), for: .touchUpInside)
        
        // Set up camera to capture image
        // Set `canTakePhoto` to true and set `photoDelegate` to nonnull
        
        camera = BBMetalCamera(sessionPreset: .hd1920x1080)!
        camera.canTakePhoto = true
        camera.photoDelegate = self
    
        // Set up metal view to display image
        //let frame = CGRect(x: 0, y: height / 5, width: width, height: height / 2)
        let frame = UIScreen.main.bounds
        metalView = BBMetalView(frame: frame)
        view.addSubview(metalView)
        
        // Set up filter chain
        camera.add(consumer: metalView)
        
        // Start capturing
        camera.start()
        
        //self.view.bringSubviewToFront(saveBtn)
        self.view.bringSubviewToFront(cameraClickedBtn)
        self.view.bringSubviewToFront(folderBtn)

        
    }
    
    @objc func cameraClicked(){
        camera.takePhoto()
    }
    
    
    func setupFolderBtn(){
        //folderButton
        folderBtn = UIButton(type: UIButton.ButtonType.custom)
        //        folderBtn.frame = CGRect(x: cardCollectionView.frame.maxX, y: cardCollectionView.frame.minY, width: 25, height: cardCollectionView.frame.height)
        folderBtn.setBackgroundImage(UIImage(named: "openFolderBtn"), for: .normal)
        self.view.addSubview(folderBtn)
                folderBtn.anchor(top: nil, leading: self.view.safeLeftAnchor, bottom: self.view.safeBottomAnchor, trailing: nil, padding: .init(top: 0, left: 10, bottom: -10, right: 0), size: .init(width: 50, height: 50))
        folderBtn.addTarget(self, action: #selector(self.folderBtnClicked), for: .touchUpInside)
    }

    
    @objc func folderBtnClicked(){
        
        performSegue(withIdentifier: "toEditView", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditView" {
            
            //camera.stop()
            
            if let destineVC = segue.destination as? EditViewController {
            
                destineVC.imageSets = imageSets
                destineVC.modalPresentationStyle = .fullScreen
                  
                  if #available(iOS 13.0, *) {
                      destineVC.isModalInPresentation = false
                  } else {
                      // Fallback on earlier versions
                  }
            }
        }
    }
    
    func resizeImage(image: UIImage) -> UIImage {
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
    
    deinit {
        print("viewcontroller deinit")
    }
    
    
}


extension ViewController: BBMetalCameraPhotoDelegate {
    
    // BBMetalCameraPhotoDelegate
    func camera(_ camera: BBMetalCamera, didOutput texture: MTLTexture) {
        // Do something to the photo texture
        // Note: the `texture` is the original photo which is not filtered even though there are filters in the filter chain
        
        let takenImage = texture.bb_image
        let smallImage = resizeImage(image: takenImage!)
        
        let tempImage = ImageShot(_image: takenImage!,_texture: texture, _filterType: nil, _isSelected: false,_smallTexture: smallImage.bb_metalTexture!)
       
        imageSets.append(tempImage)
        
    }
    
    func camera(_ camera: BBMetalCamera, didFail error: Error) {
    }
    
}





extension UIView{
    
    func fillSupervivew(){
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView){
        
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
            
        }
        
        if let leading = leading {
            
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
            
        }
        
        if let bottom = bottom {
            
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
            
        }
        if let trailing = trailing {
            
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
            
        }
        
        if size.width != 0 {
            
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
            
        }
        
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
            
        }
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leadingAnchor
        }else {
            return self.leadingAnchor
        }
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.trailingAnchor
        }else {
            return self.trailingAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
    
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        //   if (hexString.hasPrefix("#")) {
        //     scanner.scanLocation = 1
        //   }
        
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
