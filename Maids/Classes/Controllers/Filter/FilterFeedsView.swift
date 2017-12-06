//
//  CustomHeaderView.swift
//  Wardah
//
//  Created by Hani on 2017-07-11.
//  Copyright © 2017
//

import UIKit

class FilterFeedsView: AbstractNibView {

    // MARK: Properties
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var friendsFeedButton: UIButton!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    // MARK: Data
    let filterFeedsListCell = "filterFeedsListCell"
    
    // MARK: View Cycle
    override public func customizeView() {
        super.customizeView()
        // set my friends feed button
        friendsFeedButton.backgroundColor = UIColor.white
        friendsFeedButton.setTitleColor(AppColors.grayXDark, for: .normal)
        friendsFeedButton.setTitleColor(AppColors.primary, for: .highlighted)
        friendsFeedButton.titleLabel?.font = AppFonts.normal
        friendsFeedButton.setTitle("HOME_FILTER_FRIENDS_FEED".localized, for: .normal)
        // set footer view
        footerView.backgroundColor = AppColors.grayXLight
        footerView.layer.masksToBounds = false
        footerView.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
        footerView.layer.shadowRadius = 2.0
        footerView.layer.shadowColor = UIColor.init(hexString: "#212022").cgColor
        footerView.layer.shadowOpacity = 0.3;
        // filters table view
        let cellNibFile = UINib(nibName: "FilterFeedsListCell", bundle: nil)
        filtersTableView.register(cellNibFile , forCellReuseIdentifier: filterFeedsListCell)
        // fill in data
        fillInData()
    }
    
    /// Fill in categories data
    func fillInData() {
        // get list of categories
        ApiManager.shared.getCategories { (isSuccess, error) in
            if isSuccess {
                self.refreshCategories()
            }
        }
    }
    
    /// Refresh categories list
    func refreshCategories() {
        self.filtersTableView.reloadData()
    }
    
    // MARK: Actions
    @IBAction func closeAction(_ sender: UIButton) {
        NotificationCenter.default.post(name: .notificationFilterClosed, object: nil)
    }
    
    @IBAction func friendsFeedAction(_ sender: UIButton) {
        // open friend's freed screen
        ActionShowFriendsFeed.execute()
    }
}

// MARK : UITableView Datasource, Delegate
extension FilterFeedsView : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.categories.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: filterFeedsListCell) as! FilterFeedsListCell
        cell.selectionStyle = .none
        // my celebrities cell
        if (indexPath.row == 0) {
            cell.populateCelebrityCell()
        } else {// categories cell
            cell.populateCell(category: DataStore.shared.categories[indexPath.row - 1])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // my celebrities cell
        if (indexPath.row == 0) {
            DataStore.shared.me?.preferences?.isMyCelebrities = !(DataStore.shared.me?.preferences?.isMyCelebrities ?? false)
        }
        else {// category cell
            let category = DataStore.shared.categories[indexPath.row - 1]
            if let categories = DataStore.shared.me?.preferences?.categories {
                // remove the category
                if category.isExistIn(arr: categories) {
                    DataStore.shared.me?.preferences?.categories = category.removeObjectById(arr: categories, id: category.id)
                } else {// add the category
                    DataStore.shared.me?.preferences?.categories?.append(category)
                }
                DataStore.shared.saveUser(notify: true)
            }
        }
        filtersTableView.reloadData()
    }
}
