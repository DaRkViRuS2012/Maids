//
//  TextFeedsListCell.swift
//  Wardah
//
//  Created by Hani on 7/9/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import UIKit

class TextFeedsListCell : UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var textFeedsListView:TextFeedsListView!
    
    func populate(story: Story, isExpanded: Bool) {
        // populate text feed list
        textFeedsListView.populate(story: story, isExpanded: isExpanded)
    }
}
