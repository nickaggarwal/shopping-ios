//
//  Basket.swift
//  Mokets
//
//  Created by PPH-MacMini on 3/6/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class Basket: NSObject {

    var id: Int?
    var itemId: String?
    var shopId: String?
    var userId: String?
    var name: String?
    var unitPrice: String?
    var discountPercent: String?
    var qty: String?
    var imagePath: String?
    var currencySymbol: String?
    var currencyShortForm: String?
    
    init(basketData: NSDictionary) {
        super.init()
        self.setData(basketData)
    }
    
    func setData(_ basketData: NSDictionary) {
        self.id = basketData["id"] as? Int
        self.itemId = basketData["itemId"] as? String
        self.shopId = basketData["shopId"] as? String
        self.userId = basketData["userId"] as? String
        self.name = basketData["name"] as? String
        self.unitPrice = basketData["unitPrice"] as? String
        self.discountPercent = basketData["discountPercent"] as? String
        self.qty = basketData["qty"] as? String
        self.imagePath = basketData["imagePath"] as? String
        self.currencySymbol = basketData["currencySymbol"] as? String
        self.currencyShortForm = basketData["currencyShortForm"] as? String
    }
    
}
