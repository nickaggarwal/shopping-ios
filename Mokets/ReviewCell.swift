//
//  ReviewCell.swift
//  Mokets
//
//  Created by Panacea-soft on 13/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import UIKit
import Alamofire

class ReviewCell: UITableViewCell {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var reviewMessage: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    var request : Alamofire.Request?
    
    func configure(_ userNameText: String, reviewMessageText: String, reviewAdded: String, reviewUserImageURL: String, textColor: UIColor = UIColor.black) {
        
        userName.textColor = textColor
        reviewMessage.textColor = textColor
        userName.text = "- \(userNameText)" + "(" + reviewAdded + ")"
        userName.accessibilityLabel = userNameText
        
        reviewMessage.text = reviewMessageText
        reviewMessage.accessibilityLabel = reviewMessageText
        _ = Common.instance.circleImageView(userImage)
    }
    
    
}

