//
//  FeatureCell.swift
//  Wardah
//
//  Created by Nour  on 11/14/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class FeatureCell: UICollectionViewCell {

    
    // FeatureProduct Model
    
    var product:Product?{
    
        didSet{
            guard let product = product else {
                return
            }
            if let price = product.price{
                priceLabel.text = "$\(price)"
            }
            if let discount = product.discount{
            offerLabel.text = "$\(discount)"
            offerLabel.addStrikeLine()
            }
            if let title = product.title{
                tilteLabel.text = title
            }
            productImageView.image = #imageLiteral(resourceName: "product")
        }
    
    }
    
    
    
    //MARK: Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var tilteLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    // set outlets
    func setupView(){
        tilteLabel.font = AppFonts.xBigBold
        priceLabel.font = AppFonts.big
        offerLabel.font = AppFonts.big
    }

}
