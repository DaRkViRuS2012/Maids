//
//  MediaFeedsListView.swift
//  Wardah
//
//  Created by Hani on 7/9/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import Foundation
import SDWebImage
import ActiveLabel

class MediaFeedsListView : AbstractNibView {
    
    // MARK: Properties
    // profile
    @IBOutlet weak var authorLabel:UILabel!
    @IBOutlet weak var profileImageView:UIImageViewWithMask!
    @IBOutlet weak var moreActionsButton:UIButton!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var profileButton: UIButton!
    // media
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var playBtn:UIButton!
    @IBOutlet weak var playBtnIcon:UIButton!
    @IBOutlet weak var audioBtn:UIButton!
    @IBOutlet weak var fullscreenBtn:UIButton!
    public var videoPath: String?
    // action
    @IBOutlet weak var glowButton:UIButton!
    @IBOutlet weak var commentButton:UIButton!
    @IBOutlet weak var shareButton:UIButton!
    @IBOutlet weak var interactionsLabel:UILabel!
    @IBOutlet weak var repliesLabel:UILabel!
    // body
    @IBOutlet weak var bodyLabel:ActiveLabel!
    @IBOutlet weak var bodyHeightConstraint:NSLayoutConstraint!
    @IBOutlet weak var bodyBottomConstraint:NSLayoutConstraint!
    @IBOutlet weak var seeMoreButton:UIButton!
    let bodyHeight: CGFloat = 32
    let bodyOffsetBottom: CGFloat = 16
    
    func showControlButtons(show:Bool){
        audioBtn.isHidden = !show
        fullscreenBtn.isHidden = !show
        playBtnIcon.isHidden = show
    }
    
    var audioEnabled: Bool = false {
        didSet {
            if (audioEnabled) {
                audioBtn.setImage(UIImage(named:"audioOn"), for: .normal)
            } else {
                audioBtn.setImage(UIImage(named:"audioOff"), for: .normal)
            }
        }
    }
    
    func populate(story: Story, isExpanded: Bool) {
        let post = story.post ?? Post()
        // author info
        authorLabel.text = post.author?.fullName ?? "-"
        authorLabel.font = AppFonts.normal
        authorLabel.textColor = AppColors.grayXDark
        profileImageView.sd_setImage(with: URL(string: post.author?.profilePic ?? ""), placeholderImage: UIImage(named: "profileMask"))
        dateLabel.text = DateHelper.ellapsedString(fromDate: post.createdAt)
        dateLabel.font = AppFonts.small
        dateLabel.textColor = AppColors.grayXDark
        // media stuff
        if let media = post.media {
            mediaImageView.sd_setImage(with: URL(string: media.thumbnail ?? ""), placeholderImage: nil)
            if (media.type == .video) {
                videoPath = media.url
                audioEnabled = !mediaImageView.playerIsMute()
                showControlButtons(show: false)
                playBtn.isHidden = false
            } else if(media.type == .image) {
                videoPath = media.url
                showControlButtons(show: false)
                playBtnIcon.isHidden = true
                playBtn.isHidden = true
            }
        }
        // audio button action
        audioBtn.tapAction {
            self.mediaImageView.setPlayerMute(!self.mediaImageView.playerIsMute())
            self.audioEnabled = !self.mediaImageView.playerIsMute()
        }
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
        } else {
            seeMoreButton.setTitle("POST_DETAILS_SHOW_LESS".localized, for: .normal)
            bodyHeightConstraint.constant = bodyLabel.text!.getLabelHeight(width: self.bounds.width, font: bodyLabel.font)
        }
    }
}
