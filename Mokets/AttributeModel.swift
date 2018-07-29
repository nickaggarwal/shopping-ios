//
//  AttributeModel.swift
//  Mokets
//
//  Created by PPH-MacMini on 30/5/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class AttributeModel {
    var id: String
    var itemId: String
    var shopId: String
    var name: String
    var attributeDetail : [ItemAttributeDetail]
    
    init(id: String, itemId: String, shopId: String, name: String, attributeDetail: [ItemAttributeDetail]) {
        self.id = id
        self.itemId = itemId
        self.shopId = shopId
        self.name = name
        self.attributeDetail = attributeDetail
        
    }
    
    convenience init(att: ItemAttribute) {
        let id = att.id
        let itemId = att.itemId
        let shopId = att.shopId
        let name = att.name
        let attributeDetail = att.attributesDetail
        
        self.init(id: id!, itemId: itemId!, shopId: shopId!, name: name!, attributeDetail: attributeDetail)
    }
    
}
