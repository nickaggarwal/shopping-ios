//
//  User.swift
//  Mokets
//
//  Created by Panacea-soft on 16/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

final class User: NSObject, ResponseObjectSerializable {
    var id: String?
    var username: String?
    var password: String?
    var email: String?
    var aboutMe: String?
    var deliveryAddress: String?
    var billingAddress: String?
    var phone: String?
    var profilePhoto: String?
    var isBanned: String?
    var status: String?
    var added: String?
    var updated: String?
    
    init(userData: NSDictionary) {
        super.init()
        self.setData(userData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        super.init()
        if let userData = (representation as AnyObject).value(forKeyPath: "data") as? NSDictionary {
            self.setData(userData)
        } else {
            return nil
        }
    }
    
    
    func setData(_ userData: NSDictionary) {
        self.id       = userData["id"] as? String
        self.username = userData["username"] as? String
        self.password = userData["password"] as? String
        self.email    = userData["email"] as? String
        self.aboutMe  = userData["about_me"] as? String
        self.profilePhoto = userData["profile_photo"] as? String
        self.isBanned = userData["is_banned"] as? String
        self.status   = userData["status"] as? String
        self.added    = userData["added"] as? String
        self.updated  = userData["updated"] as? String
        self.deliveryAddress = userData["delivery_address"] as? String
        self.billingAddress  = userData["billing_address"] as? String
        self.phone = userData["phone"] as? String
    }

}
