//
//  imageSliderView.swift
//  Wardah
//
//  Created by Nour  on 12/3/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class imageSliderView: AbstractNibView {

    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var CellId = "ProductImageCell"
    
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func customizeView() {
        super.customizeView()
        
        // collection view register cell
        let nib = UINib(nibName: CellId, bundle: nil)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: CellId)
        
        imagesCollectionView.isPagingEnabled = true
        // delegates
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
    }
}



// collection view methods

extension imageSliderView:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! ProductImageCell
//        
//        cell.image = AppConfig.currentProuductList.prouducts[indexPath.item]
        
        return cell
    }
    
    
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("x \(targetContentOffset.pointee.x)")
        let pagenumber = Int(abs(targetContentOffset.pointee.x) / self.frame.width)
        pageControl.currentPage = pagenumber
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}



extension imageSliderView:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: self.frame.width, height: self.frame.height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    
    
}
