//
//  ProductDetailsViewController.swift
//  Wardah
//
//  Created by Nour  on 12/3/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class ProductDetailsViewController: AbstractController {

    var product:Product?
    // image slider view
    @IBOutlet weak var productImageSliderView: UIView!
    @IBOutlet weak var imageSlider: imageSliderView!
    @IBOutlet weak var productTagImage: UIImageView!
    
    
    // product title and price view
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productSubTilteLabel: UILabel!
    @IBOutlet weak var productOfferPriceLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    // product info 
    
    @IBOutlet weak var productInfoWebView: UIWebView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavBackButton = true
        self.navigationController?.navigationBar.isTranslucent = true
        
    }

    override func customizeView() {
        // set fonts
        productTitleLabel.font = AppFonts.big
        productSubTilteLabel.font = AppFonts.xBig
        productPriceLabel.font = AppFonts.big
        productOfferPriceLabel.font = AppFonts.big
        
        
        // set color
        productTitleLabel.textColor = AppColors.grayXDark
        productOfferPriceLabel.textColor = AppColors.gray
        
        
        productOfferPriceLabel.addStrikeLine()
        
        
        
        let productInfo:String = "Exquisite! Commanding! Imagine the overwhelming sense of abundance when your recipient opens the box to this splash of color. No lovelier statement can be made and these superb roses are hand-picked and dewy-fresh from the fields!"
        productInfoWebView.loadHTMLString(productInfo, baseURL: nil)
    }
    

}
