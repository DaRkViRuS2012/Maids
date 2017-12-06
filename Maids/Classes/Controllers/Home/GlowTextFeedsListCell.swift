//
//  GlowTextFeedsListCell.swift
//  Wardah
//
//  Created by Hani on 7/9/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import UIKit

class GlowTextFeedsListCell : TextFeedsListCell {
    
    // MARK: Properties
    @IBOutlet weak var headerView:UIView!
    @IBOutlet weak var actorLabel:UILabel!
    @IBOutlet weak var actorButton:UIButton!
    @IBOutlet weak var profileImageView:UIImageViewWithMask!
    @IBOutlet weak var actionIcon:UIImageView!
    @IBOutlet weak var actionSeparetor1:GradientView!
    @IBOutlet weak var actionSeparetor2:GradientView!
    
    func populate(story:Story, isExpanded: Bool, action: StoryType) {
        // populate video feed list
        textFeedsListView.populate(story: story, isExpanded: isExpanded)
        // header
        headerView.backgroundColor = AppColors.grayXLight
        headerView.layer.masksToBounds = false
        headerView.layer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
        headerView.layer.shadowRadius = 2.0
        headerView.layer.shadowColor = UIColor.init(hexString: "#212022").cgColor
        headerView.layer.shadowOpacity = 0.3;
        // actor info
        profileImageView.sd_setImage(with: URL(string: story.actor?.profilePic ?? ""), placeholderImage: UIImage(named: "profileMask"))
        let actorName = story.actor?.fullName ?? "-"
        var actorString = "-"
        // like action
        if action == .like {
            // separators
            actionIcon.image = UIImage(named: "storyGlowAction")
            actionSeparetor1.startColor = AppColors.primary
            actionSeparetor1.endColor = AppColors.secondary
            actionSeparetor1.horizontalMode = false
            actionSeparetor2.startColor = AppColors.secondary
            actionSeparetor2.endColor = AppColors.primary
            if AppConfig.currentLanguage == .arabic {
                actionSeparetor2.startColor = AppColors.primary
                actionSeparetor2.endColor = AppColors.secondary
            }
            actionSeparetor2.horizontalMode = true
            // glowed action
            actorString = String(format: "POST_DETAILS_USER_GLOWED".localized, actorName)
            if let count = story.actorsCount, count > 1 {
                actorString = String(format: "POST_DETAILS_USERS_GLOWED".localized, actorName, count - 1)
            }
        } else {// comment or reply action
            actionIcon.image = UIImage(named: "storyCommentAction")
            actionSeparetor1.startColor = AppColors.secondary
            actionSeparetor1.endColor = AppColors.primary
            actionSeparetor1.horizontalMode = false
            actionSeparetor2.startColor = AppColors.primary
            actionSeparetor2.endColor = AppColors.secondary
            if AppConfig.currentLanguage == .arabic {
                actionSeparetor2.startColor = AppColors.secondary
                actionSeparetor2.endColor = AppColors.primary
            }
            actionSeparetor2.horizontalMode = true
            // comment or reply action
            actorString = String(format: "POST_DETAILS_USER_COMMENTED".localized, actorName)
            if let count = story.actorsCount, count > 1 {
                actorString = String(format: "POST_DETAILS_USERS_COMMENTED".localized, actorName, count - 1)
            }
        }
        // actor info
        actorLabel.textColor = AppColors.grayXDark
        let actorMutableString = NSMutableAttributedString(string: actorString, attributes: [NSFontAttributeName:AppFonts.small])
        if let range = actorString.range(of: actorName) {
            let startPos = actorString.distance(from: actorString.startIndex, to: range.lowerBound)
            actorMutableString.addAttributes([NSFontAttributeName:AppFonts.smallBold], range: NSMakeRange(startPos, actorName.length + 1))
        }
        actorLabel.attributedText = actorMutableString
    }
}


