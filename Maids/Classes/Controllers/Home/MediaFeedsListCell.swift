//
//  MediaFeedsListCell.swift
//  Wardah
//
//  Created by Hani on 7/9/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import UIKit

class MediaFeedsListCell : UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var mediaFeedsListView:MediaFeedsListView!
    
    func showControlButtons(show:Bool){
        mediaFeedsListView.showControlButtons(show: show)
    }
    
    func populate(story:Story, isExpanded: Bool) {
        // populate video feed list
        mediaFeedsListView.populate(story: story, isExpanded: isExpanded)
    }
}
