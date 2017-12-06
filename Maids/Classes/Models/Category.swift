//
//  Category.swift
//  Wardah
//
//  Created by Molham Mahmoud on 4/27/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import SwiftyJSON

class Category: BaseModel {
    // MARK: Keys
    private let kCategorytext = "text"
    private let kCategoryId = "id"
    
    public var text: String?
    public var CId: Int?
    // MARK: Properties
//    public var name: String {
//        if (AppConfig.currentLanguage == .arabic) {
//            return nameAR ?? "-"
//        }
//        return nameEN ?? "-"
//    }
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Category]
    {
        var models:[Category] = []
        for item in array
        {
            models.append(Category(json: JSON(item)))
        }
        return models
    }
    
    
    required init(json: JSON) {
        super.init(json: json)
        text = json[kCategorytext].string
        CId = json[kCategoryId].int
    }
    
    override func dictionaryRepresentation() -> [String:Any] {
        var dictionary = super.dictionaryRepresentation()
        // name en
        if let value = text {
            dictionary[kCategorytext] = value
        }
        
    
        return dictionary
    }
}
