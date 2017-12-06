//
//  productCell.swift
//  Wardah
//
//  Created by Nour  on 11/14/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class productCell: UICollectionViewCell {

    
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTilteLabel: UILabel!
    @IBOutlet weak var productPriceLable: UILabel!
    @IBOutlet weak var producltDiscountLable: UILabel!
    
    
    
    var product:Product?{
    
        didSet{
            guard let product = product else {
                return
            }
            
            if let title = product.title{
                productTilteLabel.text = title
            }
            if let price = product.products{
                productPriceLable.text = "\(price)"
            }
            
            if let discount = product.discount{
                if discount > 0 {
                    producltDiscountLable.text  = "\(discount)"
                   
                }else{
                producltDiscountLable.text = ""
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
         producltDiscountLable.addStrikeLine()
        // Initialization code
    }

}
