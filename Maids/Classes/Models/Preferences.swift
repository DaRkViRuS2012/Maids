//
//  Preferences.swift
//  Wardah
//
//  Created by Hani on 4/27/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import SwiftyJSON

class Preferences: BaseModel {
    // MARK: Keys
    private let kCategories = "categories"
    private let kMyCelebrities = "myCelebrities"
    // MARK: Properties
    public var categories: [Category]?
    public var isMyCelebrities: Bool!
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    required init(json: JSON) {
        super.init(json: json)
        if let categoriesArray = json[kCategories].array {
            categories = categoriesArray.map{Category(json:$0)}
        }
        isMyCelebrities = json[kMyCelebrities].boolValue
    }
    
    override func dictionaryRepresentation() -> [String : Any] {
        var dictionary = super.dictionaryRepresentation()
        // categories
        if let array: [Category] = categories {
            let categoryDictionaries : [[String:Any]] = array.map{$0.dictionaryRepresentation()}
            dictionary[kCategories] = categoryDictionaries
        }
        // my celebrities
        if let value = isMyCelebrities {
            dictionary[kMyCelebrities] = value
        }
        return dictionary
    }
}
