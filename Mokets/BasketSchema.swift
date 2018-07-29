//
//  BasketSchema.swift
//  Mokets
//
//  Created by PPH-MacMini on 31/5/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class BasketSchema {
    
    var id: Int64?
    var itemId: String?
    var shopId: String?
    var userId: String?
    var name: String?
    var desc: String?
    var unitPrice: String?
    var discountPercent: String?
    var qty: Int64?
    var imagePath: String?
    var currencySymbol: String?
    var currencyShortForm: String?
    var selectedAttribute: String?
    var selectedAttributeIds: String?
    
    init() {}
    
    init(id:Int64, itemId:String, shopId: String, userId: String, name: String, desc: String, unitPrice: String, discountPercent: String, qty: Int64, imagePath: String, currencySymbol: String, currencyShortForm: String, selectedAttribute: String, selectedAttributeIds: String) {
        
        self.id = id
        self.itemId = itemId
        self.shopId = shopId
        self.userId = userId
        self.name = name
        self.desc = desc
        self.unitPrice = unitPrice
        self.discountPercent = discountPercent
        self.qty = qty
        self.imagePath = imagePath
        self.currencySymbol = currencySymbol
        self.currencyShortForm = currencyShortForm
        self.selectedAttribute = selectedAttribute
        self.selectedAttributeIds = selectedAttributeIds
        
        
    }
    
    
}
