//
//  TransactionDetail.swift
//  Mokets
//
//  Created by PPH-MacMini on 30/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class TransactionDetail: NSObject{
    var id: String?
    var transactionHeaderId: String?
    var shopId: String?
    var itemId: String?
    var itemName: String?
    var itemAttribute: String?
    var unitPrice: String?
    var qty: String?
    var discountPercent: String?
    var added: String?
    
    init(transDetailData: NSDictionary) {
        super.init()
        self.setData(transDetailData)
    }
    
    func setData(_ transDetailData: NSDictionary) {
        self.id = transDetailData["id"] as? String
        self.transactionHeaderId =  transDetailData["transaction_header_id"] as? String
        self.shopId = transDetailData["shop_id"] as? String
        self.itemId = transDetailData["item_id"] as? String
        self.itemName = transDetailData["item_name"] as? String
        self.itemAttribute = transDetailData["item_attribute"] as? String
        self.unitPrice = transDetailData["unit_price"] as? String
        self.qty = transDetailData["qty"] as? String
        self.discountPercent = transDetailData["discount_percent"] as? String
        self.added = transDetailData["added"] as? String
    }

}
