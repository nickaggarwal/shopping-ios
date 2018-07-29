//
//  AttributesDetailModel.swift
//  Mokets
//
//  Created by PPH-MacMini on 30/5/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class AttributeDetailModel {
    var id: String
    var shopId: String
    var headerId: String
    var itemId: String
    var name: String
    var additionlPrice: String
    
    init(id: String, shopId: String, headerId: String, itemId: String, name: String, additionalPrice: String) {
        self.id = id
        self.shopId = shopId
        self.headerId = headerId
        self.itemId = itemId
        self.name = name
        self.additionlPrice = additionalPrice
    }
    
    convenience init(attDetail: ItemAttributeDetail) {
        let id = attDetail.id
        let shopId = attDetail.shopId
        let headerId = attDetail.headerId
        let itemId = attDetail.itemId
        let name = attDetail.name
        let additionalPrice = attDetail.additionalPrice
        
        self.init(id: id!, shopId: shopId!, headerId: headerId!, itemId: itemId!, name: name!, additionalPrice: additionalPrice!)
        
    }
    
}
