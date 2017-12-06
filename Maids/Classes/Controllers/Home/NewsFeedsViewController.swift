//
//  NewsfeedViewController.swift
//  Wardah
//
//  Created by Hani on 7/2/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import Foundation
import JPVideoPlayer
import AVKit

/*
 * The scroll derection of tableview.
 */
public enum ScrollDirection: Int {
    case none
    case up
    case down
}

class NewsFeedsViewController: AbstractController {    
    
    // MARK: Properties
    @IBOutlet weak var storiesTableView: UITableView!
    @IBOutlet weak var filterView: FilterFeedsView!
    @IBOutlet weak var filterHeightConstraint: NSLayoutConstraint!
    // The cell of playing video.
    var playingCell : MediaFeedsListCell?
    
    // MARK: Data
    let mediaFeedsListCell = "mediaFeedsListCell"
    let textFeedsListCell = "textFeedsListCell"
    let glowMediaFeedsListCell = "glowMediaFeedsListCell"
    let glowTextFeedsListCell = "glowTextFeedsListCell"
    var isMoreData: Bool = true
    var refreshControl: UIRefreshControl!
    //offset-Y of tableview when begain drag used to find scroll direction
    var lastContentOffset: CGFloat = 0
    // The scroll derection of tableview now.
    var currentScrollDirection: ScrollDirection = .none
    var shouldResume:Bool = false
    let screenSize = UIScreen.main.bounds.size
    let filterMaxHeight = CGFloat(370)
    let scrollLimitToCloseFilters: CGFloat = 40
    let mediaFeedsCellHeight: CGFloat = 454
    let textFeedsCellHeight: CGFloat = 258
    let glowMediaFeedsCellHeight: CGFloat = 516
    let glowTextFeedsCellHeight: CGFloat = 320
    let navAndStatusTotalHeight: CGFloat = 64.0
    var maxHeightPosts = [String]()
    // full screen media manager
    var mediaFocusManager = AKMediaViewerManager()
    // MARK: Selected Items
    var selectedPost: Post?
    var selectedUser: AppUser?
    
    
    // MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // register for filter changes notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.openFilter(_:)), name: .notificationFilterOpened, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeFilter(_:)), name: .notificationFilterClosed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: .notificationRefreshStories, object: nil)
        // load stories
        fillInStories(lastId: "", refresh: false)
        // media manager
        mediaFocusManager.delegate = self
        mediaFocusManager.elasticAnimation = false
        mediaFocusManager.zoomEnabled = true
        mediaFocusManager.focusOnPinch = false
        mediaFocusManager.animationDuration = 0.3
        mediaFocusManager.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedUser = nil
        selectedPost = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (playingCell != nil) {
            stopPlay()
        }
    }
    
    // Customize all view members (fonts - style - text)
    override func customizeView() {
        super.customizeView()
        self.filterHeightConstraint.constant = 0
        let cellNibFile1 = UINib(nibName: "MediaFeedsListCell", bundle: nil)
        let cellNibFile2 = UINib(nibName: "TextFeedsListCell", bundle: nil)
        let cellNibFile3 = UINib(nibName: "GlowMediaFeedsListCell", bundle: nil)
        let cellNibFile4 = UINib(nibName: "GlowTextFeedsListCell", bundle: nil)
        storiesTableView.register(cellNibFile1, forCellReuseIdentifier: mediaFeedsListCell)
        storiesTableView.register(cellNibFile2, forCellReuseIdentifier: textFeedsListCell)
        storiesTableView.register(cellNibFile3, forCellReuseIdentifier: glowMediaFeedsListCell)
        storiesTableView.register(cellNibFile4, forCellReuseIdentifier: glowTextFeedsListCell)
        // refresh table control
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColors.primary
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        storiesTableView.addSubview(refreshControl)
        // load more cell
        storiesTableView.addInfiniteScroll { (tableView) in
            if let lastPost = DataStore.shared.stories.last {
                self.fillInStories(lastId: lastPost.id, refresh: true)
            } else {
                self.fillInStories(lastId: "", refresh: true)
            }
        }
        storiesTableView.infiniteScrollTriggerOffset = 500;
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicator.color = AppColors.primary
        storiesTableView.infiniteScrollIndicatorView = indicator
        // Provide a block to be called right before a infinite scroll event is triggered.  Return YES to allow or NO to prevent it from triggering.
        storiesTableView.setShouldShowInfiniteScrollHandler { (tableView) -> Bool in
            return self.isMoreData
        }
    }
    
    // fill in stories
    func fillInStories(lastId: String, refresh: Bool) {
        if DataStore.shared.stories.isEmpty {
            showActivityLoader(true)
        }
        ApiManager.shared.getStories(lastId: lastId) { (success, isMoreData, error) in
            if (success) {
                self.isMoreData = isMoreData ?? true
                self.storiesTableView.reloadData()
            } else {
                self.isMoreData = false
            }
            // refresh table case
            if refresh {
                self.refreshControl.endRefreshing()
                // finish infinite scroll animation
                self.storiesTableView.finishInfiniteScroll()
                // show error message
                if !success {
                    self.showMessage(message:(error?.type.errorMessage)!, type: .error)
                }
            }
            self.showActivityLoader(false)
        }
    }
    
    func refresh() {
        // scroll to top
        if storiesTableView.numberOfSections > 0 {
            storiesTableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
        //  your code to refresh tableView
        fillInStories(lastId: "", refresh: true)
    }
    
    // MARK: Filters Actions
    func openFilter(_ notification: NSNotification) {
        let isAnimated = notification.userInfo?["animated"] as? Bool ?? true
        self.filterHeightConstraint.constant = filterMaxHeight
        // show with animation
        if isAnimated {
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
                self.view.layoutIfNeeded()
                self.filterView.filtersTableView.transform = CGAffineTransform.identity
            }, completion: nil)
        } else {
            self.view.layoutIfNeeded()
            self.filterView.filtersTableView.transform = CGAffineTransform.identity
        }
        // refresh categories
        self.filterView.refreshCategories()
    }
    
    func closeFilter(_ notification: NSNotification) {
        let isAnimated = notification.userInfo?["animated"] as? Bool ?? true
        self.filterHeightConstraint.constant = 0
        var delay = 0.0
        // close with animation
        if !isAnimated {
            delay = 2.0
        }
        UIView.animate(withDuration: 0.6, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
            self.view.layoutIfNeeded()
            self.filterView.filtersTableView.transform = CGAffineTransform.init(translationX: 0, y: -100)
        }, completion: nil)
        // update user preferences
        ApiManager.shared.updateUserPreferences { (isSuccess, error) in
        }
    }
    
    //MARK: Video player stuff
    /**:
     * Play or pause resume video when tapping on video player view
     */
    func videoPlayerAction(videoCell:MediaFeedsListCell) {
        // Play new video
        if playingCell?.tag != videoCell.tag {
            stopPlay()
            if let link = videoCell.mediaFeedsListView.videoPath {
                let url = URL(string: link)
                playingCell = videoCell
                playingCell?.mediaFeedsListView.audioEnabled =  true
                playingCell?.mediaFeedsListView.mediaImageView.jp_playVideo(with: url)
                playingCell?.showControlButtons(show: true)
            }
        }
        // pause and resume currenlty playing video
        else if (playingCell != nil) {
            if (shouldResume) {
                playingCell?.mediaFeedsListView.mediaImageView.resumePlay()
                shouldResume = false
                playingCell?.showControlButtons(show: true)
            } else {
                playingCell?.mediaFeedsListView.mediaImageView.pausePlay()
                playingCell?.showControlButtons(show: false)
                shouldResume = true
            }
        }
    }
    
    func stopPlay() {
        playingCell?.mediaFeedsListView.mediaImageView.stopPlay()
        playingCell?.showControlButtons(show: false)
        playingCell = nil
    }
    
    func commentOnPost(index: Int) {
        let notificationInfo:[String: Bool] = ["animated": false]
        NotificationCenter.default.post(name: .notificationFilterClosed, object: nil, userInfo: notificationInfo)
        // show post details
        if let post = DataStore.shared.stories[index].post {
            self.selectedPost = post
            self.performSegue(withIdentifier: "feedsPostDetailsSegue", sender: self)
        }
    }
    
    func showFullScreen(image: UIImageView) {
        let notificationInfo:[String: Bool] = ["animated": false]
        NotificationCenter.default.post(name: .notificationFilterClosed, object: nil, userInfo: notificationInfo)
        self.stopPlay()
        self.mediaFocusManager.startFocusingView(image)
    }
    
    func showUserProfile(author: AppUser) {
        let notificationInfo:[String: Bool] = ["animated": false]
        NotificationCenter.default.post(name: .notificationFilterClosed, object: nil, userInfo: notificationInfo)
        self.selectedUser = author
        self.performSegue(withIdentifier: "feedsProfileSegue", sender: self)
    }
    
    func glowPost(post: Post, glowButton: UIButton, interactionsLabel: UILabel) {
        var count = 0
        if let glow = post.isLiked, glow == true {
            glowButton.setImage(UIImage.init(named: "postGlowNormal"), for: .normal)
            glowButton.setImage(UIImage.init(named: "postGlowActive"), for: .highlighted)
            post.isLiked = false
            count = -1
        } else {
            glowButton.setImage(UIImage.init(named: "postGlowActive"), for: .normal)
            glowButton.setImage(UIImage.init(named: "postGlowNormal"), for: .highlighted)
            post.isLiked = true
            count = 1
        }
        ApiManager.shared.likePost(post: post, completionBlock: { (isSuccess, error) in
        })
        post.likesCount = count + (post.likesCount ?? 0)
        glowButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        glowButton.transform = CGAffineTransform.identity
        }, completion: { Void in()
            interactionsLabel.text = "-"
            count = (post.commentsCount ?? 0) + (post.likesCount ?? 0)
            if count > 0 {
                interactionsLabel.text = String(count)
            }
        })
    }
    
    func showHashtag(post: Post, hashtag: String) {
        let notificationInfo:[String: Bool] = ["animated": false]
        NotificationCenter.default.post(name: .notificationFilterClosed, object: nil, userInfo: notificationInfo)
        let hashtagUser = AppUser.init()
        hashtagUser.firstName = hashtag
        self.selectedUser = hashtagUser
        self.performSegue(withIdentifier: "feedsProfileSegue", sender: self)
    }
    
    func showMention(post: Post, mention: String) {
        let notificationInfo:[String: Bool] = ["animated": false]
        NotificationCenter.default.post(name: .notificationFilterClosed, object: nil, userInfo: notificationInfo)
        let mentionUser = AppUser.init()
        mentionUser.firstName = mention
        self.selectedUser = mentionUser
        self.performSegue(withIdentifier: "feedsProfileSegue", sender: self)
    }
    
    // MARK: Navigation & Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedsPostDetailsSegue", let nextScene = segue.destination as? PostDetailsViewController {
            nextScene.activePost = selectedPost
        } else if segue.identifier == "feedsProfileSegue", let nextScene = segue.destination as? ProfileViewController {
            nextScene.activeUser = selectedUser
        }
    }
}

// MARK: UITableView Datasource, Delegate, Scroll delegate
extension NewsFeedsViewController : UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.shared.stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get post & stories details
        let story = DataStore.shared.stories[indexPath.row]
        let post = story.post ?? Post()
        var expanded = false
        if self.maxHeightPosts.contains(post.id) {
            expanded = true
        }
        // media post cell
        if let _ = post.media {
            var cell = tableView.dequeueReusableCell(withIdentifier: mediaFeedsListCell) as! MediaFeedsListCell
            if story.verb == .post {
                cell.populate(story: story, isExpanded: expanded)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: glowMediaFeedsListCell) as! GlowMediaFeedsListCell
                (cell as! GlowMediaFeedsListCell).populate(story: story, isExpanded: expanded, action: story.verb)
                // actor button action
                (cell as! GlowMediaFeedsListCell).actorButton.tapAction {
                    if let storyActor = story.actor {
                        self.showUserProfile(author: storyActor)
                    }
                }
            }
            cell.tag = indexPath.row
            cell.mediaFeedsListView.playBtn.tapAction {
                if (post.media?.type == .video){
                    self.videoPlayerAction(videoCell: cell)
                }
            }
            // media stuff
            cell.mediaFeedsListView.mediaImageView.tag = indexPath.row
            if let media = post.media, media.type == .image {
                mediaFocusManager.installOnView(cell.mediaFeedsListView.mediaImageView)
            }
            // full screen button
            cell.mediaFeedsListView.fullscreenBtn.tapAction {
                self.showFullScreen(image: cell.mediaFeedsListView.mediaImageView)
            }
            // comment button
            cell.mediaFeedsListView.commentButton.tapAction {
                self.commentOnPost(index: indexPath.row)
            }
            // share button
            cell.mediaFeedsListView.shareButton.tapAction {
                SocialManager.shared.shareOptions(controller: self, post: post)
            }
            // actions button
            cell.mediaFeedsListView.moreActionsButton.tapAction {
            }
            // profile touch
            cell.mediaFeedsListView.profileButton.tapAction {
                if let postAuthor = post.author {
                    self.showUserProfile(author: postAuthor)
                }
            }
            // glow button
            cell.mediaFeedsListView.glowButton.tapAction {
                self.glowPost(post: post, glowButton: cell.mediaFeedsListView.glowButton, interactionsLabel: cell.mediaFeedsListView.interactionsLabel)
            }
            // see more text
            cell.mediaFeedsListView.seeMoreButton.tapAction {
                if self.maxHeightPosts.contains(post.id) {
                    self.maxHeightPosts.remove(object: post.id)
                    self.storiesTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                } else {
                    self.maxHeightPosts.append(post.id)
                }
                self.storiesTableView.reloadData()
            }
            // hashtag clicked
            cell.mediaFeedsListView.bodyLabel.handleHashtagTap { hashtag in
                self.showHashtag(post: post, hashtag: hashtag)
            }
            // mention clicked
            cell.mediaFeedsListView.bodyLabel.handleMentionTap { mention in
                self.showMention(post: post, mention: mention)
            }
            return cell
        } else {// text post cell
            var cell = tableView.dequeueReusableCell(withIdentifier: textFeedsListCell) as! TextFeedsListCell
            if story.verb == .post {
                cell.populate(story: story, isExpanded: expanded)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: glowTextFeedsListCell) as! GlowTextFeedsListCell
                (cell as! GlowTextFeedsListCell).populate(story: story, isExpanded: expanded, action: story.verb)
                // actor button action
                (cell as! GlowTextFeedsListCell).actorButton.tapAction {
                    if let storyActor = story.actor {
                        self.showUserProfile(author: storyActor)
                    }
                }
            }
            cell.tag = indexPath.row
            // comment button
            cell.textFeedsListView.commentButton.tapAction {
                self.commentOnPost(index: indexPath.row)
            }
            // share button
            cell.textFeedsListView.shareButton.tapAction {
                SocialManager.shared.shareOptions(controller: self, post: post)
            }
            // actions button
            cell.textFeedsListView.moreActionsButton.tapAction {
            }
            // profile touch
            cell.textFeedsListView.profileButton.tapAction {
                if let postAuthor = post.author {
                    self.showUserProfile(author: postAuthor)
                }
            }
            // glow button
            cell.textFeedsListView.glowButton.tapAction {
                self.glowPost(post: post, glowButton: cell.textFeedsListView.glowButton, interactionsLabel: cell.textFeedsListView.interactionsLabel)
            }
            // see more text
            cell.textFeedsListView.seeMoreButton.tapAction {
                if self.maxHeightPosts.contains(post.id) {
                    self.maxHeightPosts.remove(object: post.id)
                    self.storiesTableView.scrollToRow(at: indexPath, at: .top, animated: false)
                } else {
                    self.maxHeightPosts.append(post.id)
                }
                self.storiesTableView.reloadData()
            }
            // hashtag clicked
            cell.textFeedsListView.bodyLabel.handleHashtagTap { hashtag in
                self.showHashtag(post: post, hashtag: hashtag)
            }
            // mention clicked
            cell.textFeedsListView.bodyLabel.handleMentionTap { mention in
                self.showMention(post: post, mention: mention)
            }
            return cell
        }
    }
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let story = DataStore.shared.stories[indexPath.row]
        let post = story.post ?? Post()
        // normal post story
        if story.verb == .post {
            // media post
            if let _ = post.media {
                return mediaFeedsCellHeight
            }
            // text post
            return textFeedsCellHeight
        } else {// glow or comment story
            // media post
            if let _ = post.media {
                return glowMediaFeedsCellHeight
            }
            // text post
            return glowTextFeedsCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // close filters
        let notificationInfo:[String: Bool] = ["animated": false]
        NotificationCenter.default.post(name: .notificationFilterClosed, object: nil, userInfo: notificationInfo)
        // show post details
        let story = DataStore.shared.stories[indexPath.row]
        if let post = story.post {
            selectedPost = post
            self.performSegue(withIdentifier: "feedsPostDetailsSegue", sender: self)
        }
    }
    
    // MARK: UITableView scroll delegate
    // table view will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // handle quick scroll and check which direction tableview is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (self.lastContentOffset < offsetY) {
            currentScrollDirection = .up
            //close filters when scroll up
            if (scrollLimitToCloseFilters < offsetY - self.lastContentOffset) {
                NotificationCenter.default.post(name: .notificationFilterClosed, object: nil)
            }
        } else if (self.lastContentOffset > offsetY) {
            currentScrollDirection = .down
        } else {
            currentScrollDirection = .none
        }
        lastContentOffset = offsetY
        // Stop video play when the cell is unvisiable.
        if !playingCellIsVisiable() {
            stopPlay()
        }
    }
    
    private func playingCellIsVisiable() -> Bool {
        guard let cell = playingCell else {
            return true
        }
        
        var windowRect = UIScreen.main.bounds
        windowRect.origin.y = navAndStatusTotalHeight;
        windowRect.size.height -= navAndStatusTotalHeight;
        
        if currentScrollDirection == .up {
            let cellLeftUpPoint = cell.frame.origin
            let cellDownY = cellLeftUpPoint.y+cell.frame.size.height
            var cellLeftDownPoint = CGPoint(x: 0, y: cellDownY)
            cellLeftDownPoint.y -= 1
            let coorPoint = playingCell?.superview?.convert(cellLeftDownPoint, to: nil)
            let contain = windowRect.contains(coorPoint!)
            return contain
        }
        else if(currentScrollDirection == .down){
            var cellLeftUpPoint = cell.frame.origin
            cellLeftUpPoint.y += 1
            let coorPoint = cell.superview?.convert(cellLeftUpPoint, to: nil)
            let contain = windowRect.contains(coorPoint!)
            return contain
        }
        return true
    }
}

// MARK: AKMediaViewerDelegate
extension NewsFeedsViewController: AKMediaViewerDelegate {
    
    func parentViewControllerForMediaViewerManager(_ manager: AKMediaViewerManager) -> UIViewController {
        return self.parent!.navigationController!
    }
    
    func mediaViewerManager(_ manager: AKMediaViewerManager, mediaURLForView view: UIView) -> URL {
        let index: Int = view.tag
        var url = URL(string: "")
        // get post media url
        let story = DataStore.shared.stories[index]
        if let media = story.post?.media {
            url = URL(string: media.url!)
        }
        return url!
    }
    
    func mediaViewerManager(_ manager: AKMediaViewerManager, titleForView view: UIView) -> String {
        return ""
    }
    
    func mediaViewerManagerWillAppear(_ manager: AKMediaViewerManager) {
        /*
         *  Call here setDefaultDoneButtonText, if you want to change the text and color of default "Done" button
         *  eg: mediaFocusManager!.setDefaultDoneButtonText("Panda", withColor: UIColor.purple)
         */
        /*statusBarHidden = true
        if self.responds(to: #selector(UIViewController.setNeedsStatusBarAppearanceUpdate)) {
            self.setNeedsStatusBarAppearanceUpdate()
        }*/
        NotificationCenter.default.post(name: .notificationFilterClosed, object: nil)
    }
    
    func mediaViewerManagerWillDisappear(_ mediaFocusManager: AKMediaViewerManager) {
        /*statusBarHidden = false
        if self.responds(to: #selector(UIViewController.setNeedsStatusBarAppearanceUpdate)) {
            self.setNeedsStatusBarAppearanceUpdate()
        }*/
    }
}
