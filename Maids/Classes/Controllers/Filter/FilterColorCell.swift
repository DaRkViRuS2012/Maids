//
//  FilterColorCell.swift
//  Wardah
//
//  Created by Nour  on 11/23/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit



class FilterColorCell: UICollectionViewCell {

    
    @IBOutlet weak var backGroundView: UIView?
    @IBOutlet weak var checkImage: UIImageView!
    
    
    
    
    override var isSelected: Bool{
    
        didSet{
        checkImage.isHidden = !isSelected

        self.makeRounded()
        }
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //backGroundView.makeRounded()
        checkImage.isHidden = true
       

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.makeRounded()
    }

}
