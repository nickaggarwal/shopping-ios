//
//  ItemAttributeDetail.swift
//  Mokets
//
//  Created by PPH-MacMini on 23/5/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class ItemAttributeDetail: NSObject {
    var id: String?
    var shopId: String?
    var headerId: String?
    var itemId: String?
    var name: String?
    var additionalPrice: String?
    var added: String?
    
    init(attributeDetailData: NSDictionary) {
        super.init()
        self.setData(attributeDetailData)
    }
    
    func setData(_ attributeDetailData: NSDictionary) {
        self.id = attributeDetailData["id"] as? String
        self.shopId = attributeDetailData["shop_id"] as? String
        self.headerId = attributeDetailData["header_id"] as? String
        self.itemId = attributeDetailData["item_id"] as? String
        self.name = attributeDetailData["name"] as? String
        self.added = attributeDetailData["added"] as? String
        self.additionalPrice = attributeDetailData["additional_price"] as? String
    }
    
}
