//
//  BasketModel.swift
//  Mokets
//
//  Created by PPH-MacMini on 3/6/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class BasketModel {
    var id: Int
    var itemId: String
    var shopId: String
    var userId: String
    var name: String
    var unitPrice: String
    var discountPercent: String
    var qty: String
    var imagePath: String
    var currencySymbol: String
    var currencyShortForm: String
    
    init(id: Int, itemId: String, shopId: String, userId: String, name: String, unitPrice: String, discountPercent: String, qty: String, imagePath: String, currencySymbol: String, currencyShortForm: String) {
        
        self.id = id
        self.itemId = itemId
        self.shopId = shopId
        self.userId = userId
        self.name = name
        self.unitPrice = unitPrice
        self.discountPercent = discountPercent
        self.qty = qty
        self.imagePath = imagePath
        self.currencySymbol = currencySymbol
        self.currencyShortForm = currencyShortForm
    }
    
    convenience init(bsk: Basket) {
        let id = bsk.id
        let itemId = bsk.itemId
        let shopId = bsk.shopId
        let userId = bsk.userId
        let name = bsk.name
        let unitPrice = bsk.unitPrice
        let discountPercent = bsk.discountPercent
        let qty = bsk.qty
        let imagePath = bsk.imagePath
        let currencySymbol = bsk.currencySymbol
        let currencyShortForm = bsk.currencyShortForm
        
        self.init(id: id!, itemId: itemId!, shopId: shopId!, userId: userId!,
                  name: name!, unitPrice: unitPrice!, discountPercent: discountPercent!, qty: qty!, imagePath: imagePath!, currencySymbol: currencySymbol!, currencyShortForm: currencyShortForm!)
        
    }
    
}
