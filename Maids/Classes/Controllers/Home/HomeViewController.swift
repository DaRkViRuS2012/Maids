//
//  HomeViewController.swift
//  Wardah
//
//  Created by Hani on 4/25/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import UIKit
import CarbonKit

class HomeViewController: AbstractController {
    
    // MARK: Properties
    
    // cells id 
    
    var featureCellId = "FeatureCell"
    var categoryCollectionViewCellId = "tabBarCell"
    
    // Header
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerCollectionView: UICollectionView!
    
    // lists
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    
    @IBOutlet weak var productView: ProductsView!
    
    
    
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get data
        loadFeatureProducts()
        loadCategories()
    }
  
    
    /// Customize view
    override func customizeView() {
        self.setNavBarTitle(title: "HOME_TITLE".localized)
        self.showNavSearchButton = true
        self.showNavFilterButton = true
        // set collection views pagging
        headerCollectionView.isPagingEnabled = true
        
        
        // header Collection register Cell
        let headerNib = UINib(nibName: featureCellId, bundle: nil)
        headerCollectionView.register(headerNib, forCellWithReuseIdentifier: featureCellId)
        
        // tabBar collectionView register Cell
        
        let tabBarNib = UINib(nibName: categoryCollectionViewCellId, bundle: nil)
        categoryCollectionView.register(tabBarNib, forCellWithReuseIdentifier: categoryCollectionViewCellId)
        
    }
    
    // load Feature Product Data
    func loadFeatureProducts(){
    
        if DataStore.shared.featureProducts.isEmpty{
            showActivityLoader(true)
        }
        
        ApiManager.shared.getFeature{ (success, error) in
            if (success) {
                self.headerCollectionView.reloadData()
            }
            self.showActivityLoader(false)
        }
        

    
    }
    
    
    
    // load Categories Collection View Data
    
    func loadCategories(){
        if DataStore.shared.categories.isEmpty{
            showActivityLoader(true)
        }
        
        ApiManager.shared.getCategories { (success, error) in
            if (success) {

                if DataStore.shared.categories.count > 0 {
                    self.loadProductsBy(categoryId: "\(DataStore.shared.categories[0].CId!)")
                }
                self.categoryCollectionView.reloadData()
                let index = IndexPath(item: 0, section: 0)
                self.categoryCollectionView.selectItem(at: index, animated: false, scrollPosition: [] )
                
            }
            self.showActivityLoader(false)
        }
       
    }
    
    
    // load product Collection View data
    func loadProductsBy(categoryId:String){
    
        if DataStore.shared.products.isEmpty{
            showActivityLoader(true)
        }
        ApiManager.shared.getProducts(category: categoryId, completionBlock: { (success, error) in
            if (success) {
                self.productView.productsTableView.reloadData()
            }
            self.showActivityLoader(false)
        })
        
    }
}


extension HomeViewController: UICollectionViewDataSource,UICollectionViewDelegate{


    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView{
            return DataStore.shared.featureProducts.count
        }
        
        if collectionView == categoryCollectionView{
            return DataStore.shared.categories.count
        }
        
       return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // header collection view cell
        if collectionView == headerCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: featureCellId, for: indexPath) as! FeatureCell
            cell.product = DataStore.shared.featureProducts[indexPath.item]
            return cell
        
        }
        
        
        // list collection view cell
        if collectionView == categoryCollectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCollectionViewCellId, for: indexPath) as! tabBarCell
            cell.categoryTitle = DataStore.shared.categories[indexPath.item].text!
        return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
        
            if let categoryId = DataStore.shared.categories[indexPath.item].CId{
                self.loadProductsBy(categoryId: "\(categoryId)")
            }
        }
    }

}

extension HomeViewController:UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == headerCollectionView{
            return CGSize(width: self.view.frame.width, height: self.headerView.frame.height)
        }
        
        if collectionView == categoryCollectionView{
            return CGSize(width: self.view.frame.width / 3, height: self.categoryCollectionView.frame.height)
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
   
        return 0
    }
    
    

}
