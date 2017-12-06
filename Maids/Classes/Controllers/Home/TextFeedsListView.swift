//
//  TextFeedsListView.swift
//  Wardah
//
//  Created by Hani on 7/9/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import Foundation
import SDWebImage
import ActiveLabel

class TextFeedsListView : AbstractNibView {
    
    // MARK: Properties
    // profile
    @IBOutlet weak var authorLabel:UILabel!
    @IBOutlet weak var profileImageView:UIImageViewWithMask!
    @IBOutlet weak var moreActionsButton:UIButton!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var profileButton: UIButton!
    // body
    @IBOutlet weak var bodyLabel:ActiveLabel!
    @IBOutlet weak var bodyHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var bodyBottomConstraint:NSLayoutConstraint!
    @IBOutlet weak var seeMoreButton:UIButton!
    // action
    @IBOutlet weak var glowButton:UIButton!
    @IBOutlet weak var commentButton:UIButton!
    @IBOutlet weak var shareButton:UIButton!
    @IBOutlet weak var interactionsLabel:UILabel!
    @IBOutlet weak var repliesLabel:UILabel!
    
    let bodyHeight: CGFloat = 96
    let bodyOffsetBottom: CGFloat = 16
    
    func populate(story:Story, isExpanded: Bool) {
        let post = story.post ?? Post()
        // author info
        authorLabel.text = post.author?.fullName ?? "-"
        authorLabel.font = AppFonts.normal
        authorLabel.textColor = AppColors.grayXDark
        profileImageView.sd_setImage(with: URL(string: post.author?.profilePic ?? ""), placeholderImage: UIImage(named: "profileMask"))
        dateLabel.text = DateHelper.ellapsedString(fromDate: post.createdAt)
        dateLabel.font = AppFonts.small
        dateLabel.textColor = AppColors.grayXDark
        // glow button
        glowButton.setImage(UIImage.init(named: "postGlowNormal"), for: .normal)
        glowButton.setImage(UIImage.init(named: "postGlowActive"), for: .highlighted)
        if let glow = post.isLiked, glow == true {
            // glow button
            glowButton.setImage(UIImage.init(named: "postGlowActive"), for: .normal)
            glowButton.setImage(UIImage.init(named: "postGlowNormal"), for: .highlighted)
        }
        // interactions & comments
        interactionsLabel.font = AppFonts.small
        interactionsLabel.textColor = AppColors.grayXDark
        interactionsLabel.text = "-"
        let count = (post.commentsCount ?? 0) + (post.likesCount ?? 0)
        if count > 0 {
            interactionsLabel.text = String(count)
        }
        // replies
        repliesLabel.font = AppFonts.small
        repliesLabel.textColor = AppColors.gray
        repliesLabel.text = String(format: "POST_DETAILS_AUTHOR_REPLIES".localized, post.repliesCount ?? 0, post.author?.firstName ?? "POST_DETAILS_AUTHOR_NAME".localized)
        // see more
        seeMoreButton.titleLabel?.font = AppFonts.small
        seeMoreButton.isHidden = true
        seeMoreButton.contentHorizontalAlignment = .left
        if AppConfig.currentLanguage == .arabic {
            seeMoreButton.contentHorizontalAlignment = .right
        }
        // body text
        bodyLabel.font = AppFonts.normal
        bodyLabel.textColor = AppColors.grayXDark
        bodyLabel.text = post.body ?? "-"
        bodyLabel.enabledTypes = [.mention, .hashtag]
        bodyLabel.mentionColor = AppColors.primary
        bodyLabel.hashtagColor = AppColors.primary
        bodyBottomConstraint.constant = bodyOffsetBottom
        if bodyLabel.text!.getLabelHeight(width: self.bounds.width, font: bodyLabel.font) > bodyHeight {
            seeMoreButton.isHidden = false
            bodyBottomConstraint.constant = 2 * bodyOffsetBottom
        }
        // cell expanded
        if !isExpanded {
            seeMoreButton.setTitle("POST_DETAILS_SHOW_MORE".localized, for: .normal)
            bodyHeightConstraint.constant = bodyHeight
            if bodyLabel.text!.getLabelHeight(width: self.bounds.width, font: bodyLabel.font) < bodyHeight {
                bodyHeightConstraint.constant = bodyLabel.text!.getLabelHeight(width: self.bounds.width, font: bodyLabel.font)
            }
        } else {
            seeMoreButton.setTitle("POST_DETAILS_SHOW_LESS".localized, for: .normal)
            bodyHeightConstraint.constant = bodyLabel.text!.getLabelHeight(width: self.bounds.width, font: bodyLabel.font)
        }
    }
}
