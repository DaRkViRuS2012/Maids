//
//  ProductImageCell.swift
//  Wardah
//
//  Created by Nour  on 12/4/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class ProductImageCell: UICollectionViewCell {

    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var productImage:UIImage?{
    
        didSet{
            imageView.image = productImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
