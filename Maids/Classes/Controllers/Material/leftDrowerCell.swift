//
//  leftDrowerCell.swift
//  shefaa
//
//  Created by Nour  on 8/22/17.
//  Copyright © 2017 Nour . All rights reserved.
//

import UIKit
import Material
class leftDrowerCell: TableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var badge: UILabel!
    
    var badgeNum:String?{
        didSet{
            guard let badgeNum = badgeNum else {
                return
            }
            
            if badgeNum == "0"{
                badge.isHidden = true
            }else{
                badge.text = badgeNum
                badge.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
