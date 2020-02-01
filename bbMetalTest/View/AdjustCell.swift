//
//  AdjustCell.swift
//  
//
//  Created by Ethan on 2019/11/10.
//

import UIKit

protocol AdjustCellDelegate {
    func didSlide(cell:AdjustCell, value:Float)
    func getLastValue()
}

class AdjustCell: UITableViewCell {
    
    var indexPath:IndexPath?
    var cellDelegate: AdjustCellDelegate?
    
    var filter:Filter? {
           didSet{
               
            guard let filter = filter else {return}
            adjustNameLabel.text = filter.filterName
            //filterSlider?.filterType = filter.filterType
            valueLabel.text = "\(filter.currentValue!)"
            
        }
       }

    var adjustNameLabel:UILabel = {
       var lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont(name: "Helvetica", size: 12)
        lb.text = "Contrast"
        return lb
        
    }()
    var valueLabel:UILabel = {
       var lb = UILabel()
        lb.textColor = .white
        lb.font = UIFont(name: "Helvetica", size: 12)
        lb.text = "Contrast"
        lb.textAlignment = .right
        return lb
        
        
    }()
    
    var filterSlider:FilterSlider?
    
    let width = UIScreen.main.bounds.width
    
    
    
    static var identifier = "adjustCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        self.backgroundColor = .black
        self.frame.size.width = width
        self.frame.size.height = 100

        //adjustNameLabel.backgroundColor = .blue
        adjustNameLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width / 2, height: self.frame.height / 3)
        self.addSubview(adjustNameLabel)
        
        valueLabel.frame = CGRect(x: self.frame.width / 2, y: 0, width: self.frame.width / 2, height: self.frame.height / 3)
        //valueLabel.backgroundColor = .red
        self.addSubview(valueLabel)
        
        setupFilterSlider()
 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFilterSlider(){
        
        let sliderFrame = CGRect(x: 0, y: self.frame.height / 3, width: self.frame.width, height: self.frame.height / 2)
     
        filterSlider = FilterSlider(frame: sliderFrame, _filterType: nil)
        filterSlider!.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        self.addSubview(filterSlider!)
    }


    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            
            switch touchEvent.phase {

            case .began:
                cellDelegate?.getLastValue()

            case .moved:

                 cellDelegate?.didSlide(cell: self, value:filterSlider!.value)
            default:
                break
            }
        }
    }

}
