//
//  Transaction.swift
//  Mokets
//
//  Created by PPH-MacMini on 30/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

final class Transaction: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    var id: String?
    var shopId: String?
    var userId: String?
    var paymentTransId: String?
    var totalAmount: String?
    var deliveryAddress: String?
    var billingAddress: String?
    var transactionStatus: String?
    var email: String?
    var phone: String?
    var paymentMethod: String?
    var added: String?
    var currencySymbol: String?
    var currencyShortForm: String?
    
    var details: [TransactionDetail] = []
    
    init(transData: NSDictionary) {
        super.init()
        self.setData(transData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let itemData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(itemData)
    }
    
    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Transaction] {
        var trans = [Transaction]()
        
        if var _ = (representation as AnyObject).value(forKey: "data") as? [NSDictionary]{
            
            for tran in ((representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary]) {
                trans.append(Transaction(transData: tran))
                
            }
        }
        return trans
    }
    
    func setData(_ transData: NSDictionary) {
        self.id = transData["id"] as? String
        self.shopId = transData["shop_id"] as? String
        self.userId = transData["user_id"] as? String
        self.paymentTransId = transData["payment_trans_id"] as? String
        self.totalAmount = transData["total_amount"] as? String
        self.deliveryAddress = transData["delivery_address"] as? String
        self.billingAddress = transData["billing_address"] as? String
        self.transactionStatus = transData["transaction_status"] as? String
        self.email = transData["email"] as? String
        self.phone = transData["phone"] as? String
        self.paymentMethod = transData["payment_method"] as? String
        self.added = transData["added"] as? String
        self.currencySymbol = transData["currency_symbol"] as? String
        self.currencyShortForm = transData["currency_short_form"] as? String
        
        for transDetail in transData["details"] as! [NSDictionary] {
            self.details.append(TransactionDetail(transDetailData: transDetail))
        }
    }
    
    
}
