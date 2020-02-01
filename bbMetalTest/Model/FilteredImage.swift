//
//  FilteredImage.swift
//  bbMetalTest
//
//  Created by Ethan on 2019/11/23.
//  Copyright © 2019 playplay. All rights reserved.
//

import Foundation
import BBMetalImage
import UIKit



class FilteredImage {
    
    var texture:MTLTexture

    
    private var brightFilter = BBMetalBrightnessFilter(brightness: 0)
    private var exposeFilter = BBMetalExposureFilter(exposure: 0)
    private var contrastFilter = BBMetalContrastFilter(contrast: 1)
    private var saturateFilter = BBMetalSaturationFilter(saturation: 1)
    private var gammaFilter = BBMetalGammaFilter(gamma: 1)
    private var hueFilter = BBMetalHueFilter(hue: 0)
    private var vibranceFilter = BBMetalVibranceFilter(vibrance: 0)
    private var whiteBalanceFilter = BBMetalWhiteBalanceFilter(temperature: 5000, tint: 0)
    private var monochromeFilter = BBMetalMonochromeFilter(color: BBMetalColor(red: 0.7, green: 0.6, blue: 0.5), intensity: 0)
    private var hazeFilter = BBMetalHazeFilter(distance: 0, slope: 0)
    private var sharpenFilter = BBMetalSharpenFilter(sharpeness: 0)
    private var redFilter = BBMetalRGBAFilter(red: 1, green: 1, blue: 1, alpha: 1)
    private var greenFilter = BBMetalRGBAFilter(red: 1, green: 1, blue: 1, alpha: 1)
    private var blueFilter = BBMetalRGBAFilter(red: 1, green: 1, blue: 1, alpha: 1)
    private var normalBlend = BBMetalNormalBlendFilter()
    
    private var imageSource: BBMetalStaticImageSource?
    
    var outputImage:UIImage?
    
    var valuesForAll:[Float] = [0,0,1,1,1,0,0,5000,0,0,0,255,255,255]
    
    init(_texture:MTLTexture) {
        self.texture = _texture
        
        imageSource = BBMetalStaticImageSource(texture: texture)
        //processImage()
        
        //outputImage = processImage()
    }
    public func processImage(){
        
        //var processedImage = UIImage()
        
        if imageSource?.consumers.count == 0 {
           
        
            imageSource?.add(consumer: brightFilter).add(consumer: exposeFilter).add(consumer: contrastFilter).add(consumer: saturateFilter).add(consumer: gammaFilter).add(consumer: hueFilter).add(consumer: vibranceFilter).add(consumer: whiteBalanceFilter).add(consumer: monochromeFilter).add(consumer: sharpenFilter).add(consumer: hazeFilter).add(consumer: redFilter).add(consumer: greenFilter).add(consumer: blueFilter)
             print("added consumers")
        } else {
            print("no consumers added")
        }
        //imageSource?.transmitTexture()
        //processedImage = (blueFilter.outputTexture?.bb_image)!
     
        //return processedImage
    }
    
    public func changeValue(filterIndex:Int, value:Float) -> UIImage{
        //設定給全修圖用
        valuesForAll[filterIndex] = value

        var processedImage = UIImage()
        switch filterIndex {
        case 0:
            brightFilter.brightness = value
        case 1:
            exposeFilter.exposure = value
        case 2:
            contrastFilter.contrast = value
        case 3:
            saturateFilter.saturation = value
        case 4:
            gammaFilter.gamma = value
        case 5:
            hueFilter.hue = value
        case 6:
            vibranceFilter.vibrance = value
        case 7:
            whiteBalanceFilter.temperature = value
        case 8:
            monochromeFilter.intensity = value
        case 9:
            hazeFilter.distance = value
        case 10:
            sharpenFilter.sharpeness = value
        case 11:
            redFilter.red = value / 255
        case 12:
            greenFilter.green = value / 255
        case 13:
            blueFilter.blue = value / 255

        default:
            break
        }
        imageSource?.transmitTexture()
        processedImage = (blueFilter.outputTexture?.bb_image)!
        outputImage = processedImage
        return processedImage
        
        
        
      
        
    }
    

    public func chainFilters(values:[Float]) -> UIImage{
       
         brightFilter = BBMetalBrightnessFilter(brightness: values[0])
         exposeFilter = BBMetalExposureFilter(exposure: values[1])
         contrastFilter = BBMetalContrastFilter(contrast: values[2])
        
         saturateFilter = BBMetalSaturationFilter(saturation: values[3])
         gammaFilter = BBMetalGammaFilter(gamma: values[4])
         hueFilter = BBMetalHueFilter(hue: values[5])
         vibranceFilter = BBMetalVibranceFilter(vibrance: values[6])
         whiteBalanceFilter = BBMetalWhiteBalanceFilter(temperature: values[7], tint: 0)
         monochromeFilter = BBMetalMonochromeFilter(color: BBMetalColor(red: 0.7, green: 0.6, blue: 0.5), intensity: values[8])
         hazeFilter = BBMetalHazeFilter(distance: values[9], slope: 0)
         sharpenFilter = BBMetalSharpenFilter(sharpeness: values[10])
         redFilter = BBMetalRGBAFilter(red: values[11]/255, green: 1, blue: 1, alpha: 1)
         greenFilter = BBMetalRGBAFilter(red: 1, green: values[12]/255, blue: 1, alpha: 1)
         blueFilter = BBMetalRGBAFilter(red: 1, green: 1, blue: values[13]/255, alpha: 1)
 

        imageSource?.add(consumer: brightFilter).add(consumer: exposeFilter).add(consumer: contrastFilter).add(consumer: saturateFilter).add(consumer: gammaFilter).add(consumer: hueFilter).add(consumer: vibranceFilter).add(consumer: whiteBalanceFilter).add(consumer: monochromeFilter).add(consumer: sharpenFilter).add(consumer: hazeFilter).add(consumer: redFilter).add(consumer: greenFilter).add(consumer: blueFilter).runSynchronously = true
        
        
        imageSource?.transmitTexture()
    
        outputImage = (blueFilter.outputTexture?.bb_image)!
        //releaseMemory()
        
        return outputImage!

    }
    
    public func releaseMemory(){
        print("release memory")
         //blueFilter.removeAllConsumers()
        //blueFilter.remove(source: imageSource!)
       
        imageSource?.removeAllConsumers()
        imageSource = nil
    }
    
    func combineColor(view:UIView)->UIImage{
        
        var processedImage = UIImage()
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }

        let colorTexture = image.bb_metalTexture
        let combineFilter = BBMetalLookupFilter(lookupTable: colorTexture!, intensity: 0.2)
        imageSource?.add(consumer: combineFilter)
        imageSource?.transmitTexture()
//
        processedImage = (combineFilter.outputTexture?.bb_image)!
        
        return processedImage
        
    }
    
    private func topBlendImage(withAlpha alpha: Float) -> UIImage {
        let image = UIImage(named: "tokyo.png")!
        if alpha == 1 { return image }
        return BBMetalRGBAFilter(alpha: alpha).filteredImage(with: image)!
    }

}
