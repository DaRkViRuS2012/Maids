//
//  FilterViewController.swift
//  Wardah
//
//  Created by Nour  on 11/22/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit
import RangeSeekSlider

class FilterViewController: AbstractController {

    
    //MARK: outlets
    // cells size
    struct sizeCellSize{
       static var width = 48
       static var hieght = 48
       static var selectedWidth = 48
       static var selectedHieght = 48
    }
    
    struct colorCellSize {
       static var width = 48
       static var hieght = 48
        static var selectedWidth = 58
        static var selectedHieght = 58
    }
    
    
    
    @IBOutlet weak var text: UITextField!
    // cells id
    let filterSizeCellId = "FilterSizeCell"
    let filterColorCellId = "FilterColorCell"
    let locationCellId = "selectableCell"
    // price View
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var priceTilteLabel: UILabel!
    @IBOutlet weak var priceRangeSlider: RangeSeekSlider!
    @IBOutlet weak var selectedRangeLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    
    var selectedMinPrice:Int{
    
        set{
            selectedRangeLabel.text = "$\(newValue) - $\(selectedMaxPrice)"
        }
        get{
            return Int(priceRangeSlider.selectedMinValue)
        }
    }
    
    
    var selectedMaxPrice:Int{
        
        set{
            selectedRangeLabel.text = "$\(selectedMinPrice) - $\(newValue)"
            
        }
        get{
            return Int(priceRangeSlider.selectedMaxValue)
        }
    }
        // set min and max price
    var minPrice = 25 {
        didSet{
            self.priceRangeSlider.minValue = CGFloat(minPrice)
            self.minLabel.text = "$\(minPrice)"
            self.selectedMinPrice = minPrice
            self.priceRangeSlider.selectedMinValue = CGFloat(minPrice)
        }
    }
    
    var maxPrice = 500{
        didSet{
            self.priceRangeSlider.maxValue = CGFloat(maxPrice)
            self.maxLabel.text = "$\(maxPrice)"
            self.selectedMaxPrice =  maxPrice
            self.priceRangeSlider.selectedMaxValue = CGFloat(maxPrice)
        }
    }
    
    //sizeView
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var sizeTitleLabel: UILabel!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    
    
    // Color View
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colotTitleLabel: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
   
    
    // Flower View
    @IBOutlet weak var flowerView: UIView!
    @IBOutlet weak var flowerTitleLabel: UILabel!
    @IBOutlet weak var flowerTextField: UITextField!
    
    
    //Florist View
    @IBOutlet weak var floristView: UIView!
    @IBOutlet weak var floristTitleLabel: UILabel!
    @IBOutlet weak var FloristTextField: UITextField!
    
    // Location View
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var locationTabelView: UITableView!
    
    // apply Button
    @IBOutlet weak var applyButton: RNLoadingButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.minPrice = 25
        self.maxPrice = 500
    }

    
    override func customizeView() {
        super.customizeView()
        self.showNavCloseButton = true
        // setup price slider
        setup()
        
       // text fields style
        flowerTextField.appStyle()
        FloristTextField.appStyle()
        
        
        
        // add right button to text fields
        
            // flower text field right button
        flowerTextField.addIconButton(image: "chevron")
        addActionToTextFieldIconButton(flowerTextField, selector: #selector(goToFlowerView))
        
            // florist text field right button
        FloristTextField.addIconButton(image: "chevron")
        addActionToTextFieldIconButton(FloristTextField, selector: #selector(goToFloristView))
        
        
       
        // Set Text
        self.setNavBarTitle(title: "FILTER_TITLE".localized)
        
       
        // set Fonts 
        applyButton.titleLabel?.font = AppFonts.big
        
        
        applyButton.backgroundColor = AppColors.primary
        applyButton.setRoundedBorder()
        
        
        
        
        // allow multible selection 
        colorCollectionView.allowsMultipleSelection = true
        sizeCollectionView.allowsMultipleSelection = true
        
        // register uicollection view cells 
        let sizenib = UINib(nibName: filterSizeCellId, bundle: nil)
        sizeCollectionView.register(sizenib, forCellWithReuseIdentifier: filterSizeCellId)
        
     
        
        let colorNib = UINib(nibName: filterColorCellId, bundle: nil)
        colorCollectionView.register(colorNib, forCellWithReuseIdentifier: filterColorCellId)
        
        
        // register table View cells
        let locationnib = UINib(nibName: locationCellId, bundle: nil)
        locationTabelView.register(locationnib, forCellReuseIdentifier: locationCellId)
        
    }
    
    @IBAction func applySelection(_ sender: RNLoadingButton) {
    ActionShowProducts.execute()
    
    
    }
    
    
    // icon buttons actions
    
    func goToFlowerView(){
        let vc = AbstractController()
        vc.setNavBarTitle(title:"Flowers")
        vc.showNavBackButton = true
        vc.view.backgroundColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func goToFloristView(){
        let vc = AbstractController()
        vc.setNavBarTitle(title:"Florist")
        vc.showNavBackButton = true
        vc.view.backgroundColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // setup price slider
    private func setup() {
        // standard range slider
        priceRangeSlider.delegate = self
        priceRangeSlider.delegate = self
        priceRangeSlider.minDistance = CGFloat(minPrice)
        priceRangeSlider.step = 1
        priceRangeSlider.enableStep = true
        priceRangeSlider.handleColor = .white
        priceRangeSlider.handleDiameter = 24.0
        priceRangeSlider.selectedHandleDiameterMultiplier = 1.0
        priceRangeSlider.numberFormatter.numberStyle = .currency
        priceRangeSlider.numberFormatter.locale = Locale(identifier: "en_US")
        priceRangeSlider.numberFormatter.maximumFractionDigits = 2
    
    
    }
    
    
    
    //
    func addActionToTextFieldIconButton(_ textfiled:UITextField,selector:Selector){
    
        if AppConfig.currentLanguage == .arabic{
            let button = textfiled.leftView as! UIButton
            button.addTarget(self, action: selector, for: .touchUpInside)
        }else{
            let button = textfiled.rightView as! UIButton
            button.addTarget(self, action: selector, for: .touchUpInside)
        }
    }
    

 // disable TextFileds 
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

// implement uicollection view delegates
extension FilterViewController:UICollectionViewDelegate,UICollectionViewDataSource{


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sizeCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterSizeCellId, for: indexPath) as! FilterSizeCell
        
            return cell
        }
        
        if collectionView == colorCollectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterColorCellId, for: indexPath) as! FilterColorCell
        return cell
        }
        
        return UICollectionViewCell()

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sizeCollectionView {
            sizeCollectionView.performBatchUpdates(nil, completion: nil)
        }
        
        if collectionView == colorCollectionView {
            colorCollectionView.performBatchUpdates(nil, completion: nil)
        }
    }
    
    
}

extension FilterViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == sizeCollectionView{
            
            switch collectionView.indexPathsForSelectedItems?.first {
            case .some(indexPath):
               return CGSize(width: sizeCellSize.selectedWidth , height: sizeCellSize.selectedHieght)
                
            default:
               return CGSize(width: sizeCellSize.selectedWidth , height: sizeCellSize.selectedHieght)
            }
            
        }
        
        if collectionView == colorCollectionView{
            switch collectionView.indexPathsForSelectedItems?.first {
            case .some(indexPath):
                return CGSize(width: colorCellSize.width, height: colorCellSize.hieght)
            //     return CGSize(width: colorCellSize.selectedWidth, height: colorCellSize.selectedHieght)
                
            default:
                return CGSize(width: colorCellSize.width, height: colorCellSize.hieght)
                
            }
        
        }
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 16
    }
    
    
    
}



/// implement table view delegates


extension FilterViewController:UITableViewDelegate,UITableViewDataSource{



    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locationCellId, for: indexPath) as! selectableCell
        
        
        return cell
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }


}


extension FilterViewController: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        self.selectedMinPrice = Int(minValue)
        self.selectedMaxPrice = Int(maxValue)
    }
    

    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}
