//
//  Item.swift
//  Mokets
//
//  Created by Panacea-soft on 16/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

final class Item: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String?
    var catId: String?
    var subCatId: String?
    var shopId: String?
    var name: String?
    var desc: String?
    var price: String?
    var searchTag: String?
    var isPublished: String?
    var added: String?
    var updated: String?
    
    var likeCount: Int?
    var reviewCount: Int?
    var inquiryCount: Int?
    var touchCount: Int?
    var ratingCount: Float?
    
    var discountTypeId: String?
    var discountName: String?
    var discountPercent: String?
    var currencySymbol: String?
    var currencyShortForm: String?
    
    var images: [Image] = []
    var reviews: [Review] = []
    var attributes: [ItemAttribute] = []
    
    
    init(itemData: NSDictionary) {
        super.init()
        self.setData(itemData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let itemData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(itemData)
    }
    
    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Item] {
        var items = [Item]()
        
        if var _ = (representation as AnyObject).value(forKey: "data") as? [NSDictionary]{
            
            for item in ((representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary]) {
                items.append(Item(itemData: item))
                
            }
        }
        return items
    }
    
    func setData(_ itemData: NSDictionary) {
        self.id = itemData["id"] as? String
        self.catId = itemData["cat_id"] as? String
        self.subCatId = itemData["sub_cat_id"] as? String
        self.shopId = itemData["shop_id"] as? String
        self.name = itemData["name"] as? String
        self.desc = itemData["description"] as? String
        self.price = itemData["unit_price"] as? String
        self.searchTag = itemData["search_tag"] as? String
        self.isPublished = itemData["is_published"] as? String
        self.added = itemData["added"] as? String
        self.updated = itemData["updated"] as? String
       
        self.likeCount = itemData["like_count"] as? Int
        self.reviewCount = itemData["review_count"] as? Int
        self.inquiryCount = itemData["inquiries_count"] as? Int
        self.touchCount = itemData["touches_count"] as? Int
        self.ratingCount = itemData["rating_count"] as? Float
        
        self.discountTypeId = itemData["discount_type_id"] as? String
        self.discountName = itemData["discount_name"] as? String
        self.discountPercent = itemData["discount_percent"] as? String
        self.currencySymbol = itemData["currency_symbol"] as? String
        self.currencyShortForm = itemData["currency_short_form"] as? String
        
        
        for image in itemData["images"] as! [NSDictionary] {
            self.images.append(Image(imageData: image))
        }
        
        
        for review in itemData["reviews"] as! [NSDictionary] {
            self.reviews.append(Review(reviewData: review))
        }
        
        for attribute in itemData["attributes"] as! [NSDictionary] {
            self.attributes.append(ItemAttribute(attributeData: attribute))
        }
        
    }
    
    
}
