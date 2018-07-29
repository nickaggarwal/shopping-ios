//
//  TransactionDetailCell.swift
//  Mokets
//
//  Created by PPH-MacMini on 31/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class TransactionDetailCell: UICollectionViewCell {

    
    @IBOutlet weak var transactionItemName: UILabel!
    @IBOutlet weak var transactionItemNameValue: UILabel!
    @IBOutlet weak var transactionItemPrice: UILabel!
    @IBOutlet weak var transactionItemPriceValue: UILabel!
    @IBOutlet weak var transactionItemQty: UILabel!
    @IBOutlet weak var transactionItemQtyValue: UILabel!
    
    func configure(_ name: String, price: String, qty: String, attribute: String) {
        if(attribute == "") {
            transactionItemName.text = language.transactionItemName
            transactionItemNameValue.text = name
        } else {
            transactionItemName.text = language.transactionItemName
            transactionItemNameValue.text = name + "(" + attribute + ")"
        }
        transactionItemPrice.text = language.price
        transactionItemPriceValue.text = price
        
        transactionItemQty.text = language.qty
        transactionItemQtyValue.text = qty
    }
    
    
}
