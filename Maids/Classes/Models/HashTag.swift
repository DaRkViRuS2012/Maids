//
//  HashTag.swift
//  Wardah
//
//  Created by Dania on 7/10/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import SwiftyJSON

class HashTag: BaseModel {
    // MARK: Keys
    private let kText: String = "text"
    private let kStartsAt: String = "startsAt"
    private let kEndsAt: String = "endsAt"
    // MARK: Properties
    public var text:String?
    public var starstAt:Int!
    public var endsAt:Int!
    
    // MARK: Initializers
    public override init() {
        super.init()
    }
    
    public required init(json: JSON) {
        super.init(json: json)
        text = json[kText].string
        starstAt = json[kStartsAt].int ?? -1
        endsAt = json[kEndsAt].int ?? -1
    }
    
    public override func dictionaryRepresentation() -> [String : Any] {
        var dictionary = super.dictionaryRepresentation()
        // text
        if let value = text {
            dictionary[kText] = value
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
