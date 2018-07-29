//
//  AttributeSchema.swift
//  Mokets
//
//  Created by PPH-MacMini on 31/5/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class AttributeSchema {
    var id: Int64?
    var attributeDetailId: String?
    var itemId: String?
    var shopId: String?
    var headerId: String?
    var name: String?
    var price: String?
    
    
    init() {}
    
    init(id: Int64, attributeDetailId: String, itemId: String, shopId: String, headerId: String, name: String, price: String) {
    
        self.id = id
        self.attributeDetailId = attributeDetailId
        self.itemId = itemId
        self.shopId = shopId
        self.headerId = headerId
        self.name = name
        self.price = price
        
    }
    
}
