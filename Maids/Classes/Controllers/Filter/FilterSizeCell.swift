//
//  FilterSizeCell.swift
//  Wardah
//
//  Created by Nour  on 11/23/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class FilterSizeCell: UICollectionViewCell {

    // outlets
    
    
    
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var sizeLabel: UILabel!
    
    
    override var isSelected: Bool{
    
        didSet{
            backGroundView.backgroundColor = isSelected ? AppColors.grayXDark : AppColors.Lightgray
            sizeLabel.textColor = isSelected ? UIColor.white : AppColors.grayXDark
        }
    
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // make back gorung rounded
        backGroundView.makeRounded()
        
        // set colors
        backGroundView.backgroundColor = AppColors.Lightgray
        sizeLabel.textColor = AppColors.grayXDark
        
        
        // set fonts
        sizeLabel.font = AppFonts.bigSemiBold
        
    }

}
