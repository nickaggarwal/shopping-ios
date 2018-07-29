//
//  TransactionModel.swift
//  Mokets
//
//  Created by PPH-MacMini on 31/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class TransactionModel {
    var id: String
    var shopId: String
    var userId: String
    var paymentTransId: String
    var totalAmount: String
    var deliveryAddress: String
    var billingAddress: String
    var transactionStatus: String
    var email: String
    var phone: String
    var paymentMethod: String
    var added: String
    var currencySymbol: String
    var currencyShortForm: String
    
    var transactionDetail = [TransactionDetail]()
    
    init(id: String, shopId: String, userId: String, paymentTransId: String, totalAmount: String, deliveryAddress: String, billingAddress: String, transactionStatus: String, email: String, phone: String, paymentMethod: String, added: String, currencySymbol: String, currencyShortForm: String, transactionDetail : [TransactionDetail] ) {
        
        self.id = id
        self.shopId = shopId
        self.userId = userId
        self.paymentTransId = paymentTransId
        self.totalAmount = totalAmount
        self.deliveryAddress = deliveryAddress
        self.billingAddress = billingAddress
        self.transactionStatus = transactionStatus
        self.email = email
        self.phone = phone
        self.paymentMethod = paymentMethod
        self.added = added
        self.transactionDetail = transactionDetail
        self.currencySymbol = currencySymbol
        self.currencyShortForm = currencyShortForm
        
    }
    
    convenience init(transData: Transaction) {
        
        let id = transData.id
        let shopId = transData.shopId
        let userId = transData.userId
        let paymentTransId = transData.paymentTransId
        let totalAmount = transData.totalAmount
        let deliveryAddress = transData.deliveryAddress
        let billingAddress = transData.billingAddress
        let transactionStatus = transData.transactionStatus
        let email = transData.email
        let phone = transData.phone
        let paymentMethod = transData.paymentMethod
        let added = transData.added
        let currencySymbol = transData.currencySymbol
        let currencyShortForm = transData.currencyShortForm
        
        let detailArray: [TransactionDetail] = transData.details
        
        self.init(id: id!, shopId: shopId!, userId: userId!, paymentTransId: paymentTransId!, totalAmount: totalAmount!, deliveryAddress: deliveryAddress!, billingAddress: billingAddress!, transactionStatus: transactionStatus!, email: email!, phone: phone!, paymentMethod: paymentMethod!, added: added!, currencySymbol: currencySymbol!, currencyShortForm: currencyShortForm!, transactionDetail: detailArray)
    
    }
    
    
    
}
