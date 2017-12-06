

import Foundation

import SwiftyJSON

public class Product:BaseModel {
    
    
    
    
    
    public var title : String?
    public var subtitle : String?
    public var description : String?
    public var price : Int?
    public var discount : Int?
    public var size : String?
    public var flowerType : String?
    public var isFeatured : Int?
    public var isNew : Bool?
    public var isPublished : Bool?
    public var createdAt : String?
    public var products : Int?
    public var floristId : Int?
    
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let Product_list = Product.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Product Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [Product]
    {
        var models:[Product] = []
        for item in array
        {
            models.append(Product(json: JSON(item)))
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let Product = Product(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Product Instance.
     */

    override init() {
        super.init()
    }
    
    public required init(json: JSON) {
        super.init(json: json)
        title = json["title"].string
        subtitle = json["subtitle"].string
        description = json["description"].string
        price = json["price"].int
        discount = json["discount"].int
        size = json["size"].string
        flowerType = json["flowerType"].string
        isFeatured = json["isFeatured"].int
        isNew = json["isNew"].bool
        isPublished = json["isPublished"].bool
        createdAt = json["createdAt"].string
        products = json["products"].int
        floristId = json["floristId"].int
        
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
     override public func dictionaryRepresentation() -> [String:Any] {
        
        var dictionary = super.dictionaryRepresentation()
        
        dictionary["title"] = self.title
        dictionary["subtitle"] = self.subtitle
        dictionary["description"] = self.description
        dictionary["price"] = self.price
//        dictionary["discount"] = self.discount
//        dictionary.setValue(self.size, forKey: "size")
//        dictionary.setValue(self.flowerType, forKey: "flowerType")
//        dictionary.setValue(self.isFeatured, forKey: "isFeatured")
//        dictionary.setValue(self.isNew, forKey: "isNew")
//        dictionary.setValue(self.isPublished, forKey: "isPublished")
//        dictionary.setValue(self.createdAt, forKey: "createdAt")
//        dictionary.setValue(self.products, forKey: "products")
//        dictionary.setValue(self.floristId, forKey: "floristId")
//        
        return dictionary
    }
    
    
  
    
}
