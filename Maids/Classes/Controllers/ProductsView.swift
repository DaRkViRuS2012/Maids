//
//  ProductView.swift
//  Wardah
//
//  Created by Nour  on 11/20/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class ProductsView: AbstractNibView {

 
    @IBOutlet weak var productsTableView: UICollectionView!
    var productCellId = "productCell"
    
    override func customizeView() {
        super.customizeView()
        
        // collection view register cell
        let nib = UINib(nibName: productCellId, bundle: nil)
        productsTableView.register(nib, forCellWithReuseIdentifier: productCellId)
        
        // delegates
        productsTableView.delegate = self
        productsTableView.dataSource = self
    }
}



// collection view methods

extension ProductsView:UICollectionViewDataSource,UICollectionViewDelegate{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppConfig.currentProuductList.prouducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellId, for: indexPath) as! productCell
        
        cell.product = AppConfig.currentProuductList.prouducts[indexPath.item]
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = AppConfig.currentProuductList.prouducts[indexPath.item]
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.product = product
        ActionShowProductDetails.execute()
        
        }
    
}



extension ProductsView:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{

        return CGSize(width: (self.view.frame.width / 2) - 10, height: 254)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    
    
}
