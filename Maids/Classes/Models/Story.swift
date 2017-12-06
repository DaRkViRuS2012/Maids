//
//  Story.swift
//  Wardah
//
//  Created by Dania on 7/9/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import SwiftyJSON

// MARK: Story type
enum StoryType: String {
    case post = "post"
    case like = "like"
    case comment = "comment"
    case reply = "reply"
}

class Story: BaseModel {
    // MARK: Keys
    private let kActor = "actor"
    private let kActorsCount = "totalActorsCount"
    private let kPost = "post"
    private let kVerb = "verb"
    private let kCreatedAt = "createdAt"
    
    
    // MARK: Properties
    public var actor:AppUser?
    public var actorsCount: Int?
    public var post: Post?
    public var verb: StoryType!
    public var createdAt: Date?
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        if (json[kActor] != JSON.null) {
            actor = AppUser(json: json[kActor])
        }
        if let count = json[kActorsCount].int {
            actorsCount = count
        }
        if (json[kPost] != JSON.null) {
            post = Post(json: json[kPost])
        }
        verb = .post
        if let verbString = json[kVerb].string {
            verb = StoryType(rawValue: verbString)
        }
        if let dateString = json[kCreatedAt].string {
            createdAt = DateHelper.getDateFromISOString(dateString)
        }
    }
    
    override func dictionaryRepresentation() -> [String : Any] {
        var dictionary = super.dictionaryRepresentation()
        // actor
        if let value = actor {
            dictionary[kActor] = value.dictionaryRepresentation()
        }
        // actors count
        if let value = actorsCount {
            dictionary[kActorsCount] = value
        }
        // post
        if let value = post {
            dictionary[kPost] = value.dictionaryRepresentation()
        }
        // verb raw value
        dictionary[kVerb] = verb.rawValue
        // created at
        if let value = createdAt {
            dictionary[kCreatedAt] = DateHelper.getISOStringFromDate(value)
        }
        return dictionary
    }
}
