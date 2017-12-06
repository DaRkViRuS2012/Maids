//
//  tabBarCell.swift
//  Wardah
//
//  Created by Nour  on 11/14/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class tabBarCell: UICollectionViewCell {

    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    var categoryTitle:String = ""{
    
        didSet{
            categoryTitleLabel.text = categoryTitle
            
        }
    
    }
    
    override var isHighlighted: Bool{
    
        didSet{
            self.categoryTitleLabel.textColor = isHighlighted ? .black : .gray
        }
    }
    
    override var isSelected: Bool{
        didSet{
            self.categoryTitleLabel.textColor = isSelected ? .black : .gray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryTitleLabel.textColor = .gray
    }

}
