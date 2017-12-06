//
//  ProductSearchViewController.swift
//  Wardah
//
//  Created by Nour  on 11/16/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class ProductSearchViewController: AbstractController {

    @IBOutlet weak var searchBarTextField: UITextField!
    
    let searchCellId = "searchCell"
    
    var latestSearchResults:[String] = []
    var searchResults:[String] = []
    var filteredSearchResults:[String] = []
    
    // latest Search
    @IBOutlet weak var latestSearchTableView: UITableView!
    @IBOutlet weak var latestSearchLabel: UILabel!
    @IBOutlet weak var latestsSearchView: UIView!
    
    
    
    // search Table View
    @IBOutlet weak var searchTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func customizeView() {
    
        // hide search tableView
        searchTableView.isHidden = true
        latestsSearchView.isHidden  = true
        // table view foorter view
        latestSearchTableView.tableFooterView = UIView()
        searchTableView.tableFooterView = UIView()
        
        // search text field
        searchBarTextField.searchBarStyle()
        
        
        self.showRightNavCloseButton = true

        loadLatestsSearchResults()
    }

    
    
    @IBAction func searchTextFiledChangeEditing(_ sender: UITextField) {
        
        let searchText = sender.text
        
        if (searchText?.isEmpty)!{
            searchTableView.isHidden = true
        }else{
        searchTableView.isHidden = false
        autoCompleteHandeler(word: searchText!)
        }
    }
    
    
    
    func autoCompleteHandeler(word:String){
        
        loadProductsBy(name: word)
        
    }
    
    func loadLatestsSearchResults(){
    latestSearchResults.append("Birthday gift baskets")
    latestSearchResults.append("Yellow roses")
    latestSearchResults.append("Office flowers")
    
    }
    
    
    // load product Collection View data
    func loadProductsBy(name:String){
        
        showActivityLoader(true)
        ApiManager.shared.getProductsBy(name: name, completionBlock: { (success, error) in
            if (success) {
                self.searchTableView.reloadData()
            }
            self.showActivityLoader(false)
        })
        
    }
    
    
    
    
    // handel search result
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        handelSearch()
        
        return true
    }
    
    
    @IBAction func searchButtonCliked(_ sender: UIBarButtonItem) {
        
        handelSearch()
    }
    
    
    func handelSearch(){
        self.searchBarTextField.resignFirstResponder()
        if let word = self.searchBarTextField.text,!word.isEmpty{
//        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
//            vc.searchProduct = word
//        self.navigationController?.pushViewController(vc, animated: true)
            ActionShowProducts.execute()
        }
    }
}


extension ProductSearchViewController:UITableViewDelegate,UITableViewDataSource{


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == latestSearchTableView{
            return min(3,latestSearchResults.count)
        }
        return AppConfig.currentProuductList.prouducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: searchCellId , for: indexPath)
        if tableView == latestSearchTableView{
            cell.textLabel?.text = latestSearchResults[indexPath.row]
        }else{
            cell.textLabel?.text = AppConfig.currentProuductList.prouducts[indexPath.row].title!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        self.searchBarTextField.resignFirstResponder()
        if tableView == latestSearchTableView{
            
        }else{
            let vc = AbstractController()
            vc.setNavBarTitle(title: AppConfig.currentProuductList.prouducts[indexPath.row].title!)
            vc.view.backgroundColor = .white
            vc.showNavBackButton = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}
