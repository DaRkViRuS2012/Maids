//
//  ProductsView.swift
//  Wardah
//
//  Created by Nour  on 11/19/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class ProductsViewController: AbstractController {

    @IBOutlet weak var producstView: ProductsView!
    
    var searchProduct:String?
    
    override func viewDidLoad() {
    
        if let _ = searchProduct{
            self.setNavBarTitle(title: searchProduct!)
        }
        self.setNavBarTitle(title: "Products")
        self.showNavCloseButton = true
        
       
    }
    
}
