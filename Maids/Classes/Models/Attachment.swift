//
//  Attachment.swift
//  Wardah
//
//  Created by Dania on 7/10/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import SwiftyJSON

enum AttachmentType:String{
    case image = "image"
    case video = "video"
}

class Attachment: BaseModel {
    
    // MARK: Keys
    private let kType: String = "type"
    private let kUrl: String = "url"
    private let kThunmbnail: String = "thumbnail"
    // MARK: Properties
    public var thumbnail:String?
    public var url:String?
    public var type:AttachmentType?
    
    // MARK: Initializers
    public override init() {
        super.init()
    }
    
    public required init(json: JSON) {
        super.init(json: json)
        url = json[kUrl].string
        thumbnail = json[kThunmbnail].string
        type = .image
        if let attachmentTypeString = json[kType].string {
            type = AttachmentType(rawValue: attachmentTypeString)
        }
    }
    
    public override func dictionaryRepresentation() -> [String : Any] {
        var dictionary = super.dictionaryRepresentation()
        // type raw value
        if let value = type?.rawValue {
            dictionary[kType] = value
        }
        // url
        if let value = url {
            dictionary[kUrl] = value
        }
        // thumbnail
        if let value = thumbnail {
            dictionary[kThunmbnail] = value
        }
        return dictionary
    }
}
