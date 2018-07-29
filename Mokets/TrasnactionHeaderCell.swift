//
//  TrasnactionHeaderCell.swift
//  Mokets
//
//  Created by PPH-MacMini on 31/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

class TransactionHeaderCell : UICollectionViewCell {
    
    @IBOutlet weak var transactionNo: UILabel!
    @IBOutlet weak var transactionNoValue: UILabel!
    @IBOutlet weak var transactionTotalAmount: UILabel!
    @IBOutlet weak var transactionTotalAmountValue: UILabel!
    @IBOutlet weak var transactionStatus: UILabel!
    @IBOutlet weak var transactionStatusValue: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var phoneValue: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var emailValue: UILabel!
    @IBOutlet weak var billingAddress: UILabel!
    @IBOutlet weak var billingAddressValue: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var deliveryAddressValue: UILabel!
    
    func configure(_ data: TransactionModel) {
        // Transaction No
        transactionNo.text = language.transactionNo
        transactionNoValue.text = data.id
        
        // Transaction Total Amount
        transactionTotalAmount.text = language.transactionTotal
        transactionTotalAmountValue.text = data.totalAmount + data.currencySymbol + "(" + data.currencyShortForm + ")"
        
        // Transaction Status
        transactionStatus.text = language.transactionStatus
        transactionStatusValue.text = data.transactionStatus
        if(data.transactionStatus == "Pending"){
            transactionStatusValue.textColor = UIColor.orange
        }else {
            transactionStatusValue.textColor = UIColor.blue
        }
        
        // Phone
        phone.text = language.transactionPhone
        phoneValue.text = data.phone
        
        // Email
        email.text = language.transactionEmail
        emailValue.text = data.email
        
        // Billing Address
        billingAddress.text = language.transactionBilling
        billingAddressValue.text = data.billingAddress
        
        // Delivery Address
        deliveryAddress.text = language.transactionDelivery
        deliveryAddressValue.text = data.deliveryAddress
        
    }
    
}
