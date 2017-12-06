//
//  Mention.swift
//  Wardah
//
//  Created by Dania on 7/10/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import SwiftyJSON

class Mention: BaseModel {
    // MARK: Keys
    private let kUser: String = "user"
    private let kStartsAt: String = "startsAt"
    private let kEndsAt: String = "endsAt"
    // MARK: Properties
    public var user:AppUser?
    public var starstAt:Int!
    public var endsAt:Int!
    
    // MARK: Initializers
    public override init() {
        super.init()
    }
    
    public required init(json: JSON) {
        super.init(json: json)
        if json[kUser] != JSON.null {
            user = AppUser(json: json[kUser])
        }
        starstAt = json[kStartsAt].int ?? -1
        endsAt = json[kEndsAt].int ?? -1
    }
    
    public override func dictionaryRepresentation() -> [String : Any] {
        var dictionary = super.dictionaryRepresentation()
        // user
        if let value = user {
            dictionary[kUser] = value.dictionaryRepresentation()
        }
        // start index
        if let value = starstAt {
            dictionary[kStartsAt] = value
        }
        // end index
        if let value = endsAt {
            dictionary[kEndsAt] = value
        }
        return dictionary
    }
}
