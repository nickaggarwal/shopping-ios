//
//  TransactionCell.swift
//  Mokets
//
//  Created by PPH-MacMini on 31/7/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

class TransactionCell: UITableViewCell {
    @IBOutlet weak var transactionNo: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var transactionStatus: UILabel!
    @IBOutlet weak var transIcon: UIImageView!
    
    func configure(_ transNo: String, transStatus: String, total: String) {
        transactionNo.text = language.transactionNo + transNo
        transactionStatus.text = language.transactionStatus +  transStatus
        totalAmount.text = language.transactionTotal + total
    }
    
}
