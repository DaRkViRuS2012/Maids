//
//  Post.swift
//  Wardah
//
//  Created by Dania on 7/9/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import SwiftyJSON

class Post: BaseModel {
    // MARK: Keys
    private let kAuthor: String = "author"
    private let kCategories = "categories"
    private let kBody = "body"
    private let kMentions = "mentions"
    private let kAttachments = "attachments"
    private let kLikes = "likes"
    private let kComments = "comments"
    private let kLikesCount = "likesCount"
    private let kCommentCount = "commentsCount"
    private let kRepliesCount = "repliesCount"
    private let kMedia = "media"
    private let kCreatedAt = "createdAt"
    private let kTags = "hashtags"
    private let kLiked = "liked"
    
    
    // MARK: Properties
    public var author:AppUser?
    public var categories: [String]?
    public var body: String?
    public var mentions: [Mention]?
    public var attachments: [Attachment]?
    public var likes: [AppUser]?
    public var comments: [Comment]?
    public var likesCount: Int?
    public var commentsCount: Int?
    public var repliesCount: Int?
    public var media: Attachment?
    public var createdAt: Date?
    public var hashTags: [HashTag]?
    public var isLiked: Bool?
    
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        if (json[kAuthor] != JSON.null) {
            author = AppUser(json: json[kAuthor])
        }
        categories = json[kCategories].map{$1.stringValue}
        body = json[kBody].string
        if let mentionsJsonArr = json[kMentions].array {
            mentions = mentionsJsonArr.map{Mention(json:$0)}
        }
        if let attachmentsJsonArr = json[kAttachments].array {
            attachments = attachmentsJsonArr.map{Attachment(json:$0)}
        }
        if let likesJsonArr = json[kLikes].array {
            likes = likesJsonArr.map{AppUser(json:$0)}
        }
        if let commentsJsonArr = json[kComments].array {
            comments = commentsJsonArr.map{Comment(json:$0)}
        }
        if let count = json[kLikesCount].int {
            likesCount = count
        }
        if let count = json[kCommentCount].int {
            commentsCount = count
        }
        if let count = json[kRepliesCount].int {
            repliesCount = count
        }
        if json[kMedia] != JSON.null {
            media = Attachment(json: json[kMedia])
        }
        if let tagsJsonArr = json[kTags].array {
            hashTags = tagsJsonArr.map{HashTag(json:$0)}
        }
        if let dateString = json[kCreatedAt].string {
            createdAt = DateHelper.getDateFromISOString(dateString)
        }
        isLiked = json[kLiked].boolValue
    }
    
    override func dictionaryRepresentation() -> [String : Any] {
        var dictionary = super.dictionaryRepresentation()
        // author
        if let value = author {
            dictionary[kAuthor] = value.dictionaryRepresentation()
        }
        // categories
        if let value = categories {
            dictionary[kCategories] = value.map{$0}
        }
        // body
        if let value = body {
            dictionary[kBody] = value
        }
        // mentions
        if let array: [Mention] = mentions {
            let mentionsDictionaries : [[String:Any]] = array.map{$0.dictionaryRepresentation()}
            dictionary[kMentions] = mentionsDictionaries
        }
        // attachments
        if let array: [Attachment] = attachments {
            let attachmentsDictionaries : [[String:Any]] = array.map{$0.dictionaryRepresentation()}
            dictionary[kAttachments] = attachmentsDictionaries
        }
        // likes
        if let array: [AppUser] = likes {
            let likesDictionaries : [[String:Any]] = array.map{$0.dictionaryRepresentation()}
            dictionary[kLikes] = likesDictionaries
        }
        // comments
        if let array: [Comment] = comments {
            let commentsDictionaries : [[String:Any]] = array.map{$0.dictionaryRepresentation()}
            dictionary[kComments] = commentsDictionaries
        }
        // likes count
        if let value = likesCount {
            dictionary[kLikesCount] = value
        }
        // comments count
        if let value = commentsCount {
            dictionary[kCommentCount] = value
        }
        // replies count
        if let value = repliesCount {
            dictionary[kRepliesCount] = value
        }
        // media
        if let value = media {
            dictionary[kMedia] = value.dictionaryRepresentation()
        }
        // created at
        if let value = createdAt {
            dictionary[kCreatedAt] = DateHelper.getISOStringFromDate(value)
        }
        // hashtags
        if let array: [HashTag] = hashTags {
            let tagsDictionaries : [[String:Any]] = array.map{$0.dictionaryRepresentation()}
            dictionary[kTags] = tagsDictionaries
        }
        // is liked
        if let value = isLiked {
            dictionary[kLiked] = value
        }
        return dictionary
    }
}
