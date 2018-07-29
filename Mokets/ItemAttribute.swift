//
//  Attributes.swift
//  Mokets
//
//  Created by PPH-MacMini on 23/5/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class ItemAttribute: NSObject{
    var id: String?
    var itemId: String?
    var shopId: String?
    var name: String?
    var added: String?
    var detailString: String?
    
    var attributesDetail: [ItemAttributeDetail] = []
    
    init(attributeData: NSDictionary) {
        super.init()
        self.setData(attributeData)
    }
    
    func setData(_ attributeData: NSDictionary) {
        self.id = attributeData["id"] as? String
        self.itemId = attributeData["item_id"] as? String
        self.shopId = attributeData["shop_id"] as? String
        self.name = attributeData["name"] as? String
        self.added = attributeData["added"] as? String
        self.detailString = attributeData["detailString"] as? String
        
        
        for attDetail in attributeData["details"] as! [NSDictionary] {
            self.attributesDetail.append(ItemAttributeDetail(attributeDetailData: attDetail))
        }
    }
}
