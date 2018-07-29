//
//  Review.swift
//  Mokets
//
//  Created by Panacea-soft on 16/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class Review: NSObject {
    var id: String?
    var itemId: String?
    var appuserId: String?
    var shopId: String?
    var review: String?
    var status: String?
    var added: String?
    var appuserName: String?
    var profilePhoto: String?
    
    init(reviewData: NSDictionary) {
        super.init()
        self.setData(reviewData)
    }
    
    func setData(_ reviewData: NSDictionary) {
        self.id = reviewData["id"] as? String
        self.itemId = reviewData["item_id"] as? String
        self.appuserId = reviewData["appuser_id"] as? String
        self.shopId = reviewData["shop_id"] as? String
        self.review = reviewData["review"] as? String
        self.status = reviewData["status"] as? String
        self.added = reviewData["added"] as? String
        self.appuserName = reviewData["appuser_name"] as? String
        self.profilePhoto = reviewData["profile_photo"] as? String
    }
}
