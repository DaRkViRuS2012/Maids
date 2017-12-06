//
//  FilterFeedsListCell.swift
//  Wardah
//
//  Created by Hani on 7/9/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import Foundation

class FilterFeedsListCell : UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    // MARK: View Cycle
    public func populateCelebrityCell() {
        filterNameLabel.text = "HOME_FILTER_MY_CELEBRITIES".localized
        // not selected cell
        filterNameLabel.font = AppFonts.normal
        checkImageView.image = UIImage.init(named: "filtersCheckOff")
        // check selection
        if DataStore.shared.me?.preferences?.isMyCelebrities ?? false {
            filterNameLabel.font = AppFonts.normalSemiBold
            checkImageView.image = UIImage.init(named: "filtersCheckOn")
        }
    }
    
    public func populateCell(category: Category) {
      //  filterNameLabel.text = category.name
        // not selected cell
        filterNameLabel.font = AppFonts.normal
        checkImageView.image = UIImage.init(named: "filtersCheckOff")
        // check selection
        if let categories = DataStore.shared.me?.preferences?.categories {
            if category.isExistIn(arr: categories) {
                filterNameLabel.font = AppFonts.normalSemiBold
                checkImageView.image = UIImage.init(named: "filtersCheckOn")
            }
        }
    }
}
