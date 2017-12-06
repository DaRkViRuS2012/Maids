//
//  selectableCell.swift
//  Wardah
//
//  Created by Nour  on 11/27/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import UIKit

class selectableCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var checkImage: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        checkImage.isHidden = !selected

    }
    
}
