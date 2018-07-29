//
//  DataModels.swift
//  cdapi
//
//  Created by Panacea-soft on 6/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation

final class Shop: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String?
    var name: String?
    var desc: String?
    var phone: String?
    var email: String?
    var address: String?
    var lat: String?
    var lng: String?
    var coordinate: String?
    
    var paypalEmail: String?
    var paypalEnvironment: String?
    var paypalMerchantname: String?
    var paypalCustomerId: String?
    
    var bankAccount: String?
    var bankName: String?
    var bankCode: String?
    var branchCode: String?
    var swiftCode: String?
    
    var codEmail: String?
    var currencySymbol: String?
    var currencyShortForm: String?
    var senderEmail: String?
    
    var added: String?
    var status: String?
    
    var itemCount: Int?
    var categoryCount: Int?
    var subCategoryCount: Int?
    var followCount: Int?
    
    var coverImageFile: String?
    var coverImageWidth: String?
    var coverImageHeight: String?
    var coverImageDescription: String?
    
    var paypalEnabled: String?
    var stripeEnabled: String?
    var codEnabled: String?
    var bankTransferEnabled: String?
    
    var stripePublishableKey: String?
    
    
    var categories: [Category] = []
    
    init(shopData: NSDictionary) {
        super.init()
        self.setData(shopData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let shopData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(shopData)
    }
    
    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Shop] {
        var shops = [Shop]()
        
        if var _ = (representation as AnyObject).value(forKeyPath: "data") as? [NSDictionary]{
            for shop in (representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary] {
                shops.append(Shop(shopData: shop))
            }
        }
        return shops
        
    }
    
    func setData(_ shopData: NSDictionary) {
        self.id = shopData["id"] as? String
        self.name = shopData["name"] as? String
        self.desc = shopData["description"] as? String
        self.phone = shopData["phone"] as? String
        self.email = shopData["email"] as? String
        self.address = shopData["address"] as? String
        self.lat = shopData["lat"] as? String
        self.lng = shopData["lng"] as? String
        self.coordinate = shopData["coordinate"] as? String
        
        self.paypalEmail = shopData["paypal_email"] as? String
        self.paypalEnvironment = shopData["paypal_environment"] as? String
        self.paypalMerchantname = shopData["paypal_merchantname"] as? String
        self.paypalCustomerId = shopData["paypal_customerid"] as? String
        
        self.bankAccount = shopData["bank_account"] as? String
        self.bankCode = shopData["bank_code"] as? String
        self.bankName = shopData["bank_name"] as? String
        self.branchCode = shopData["branch_code"] as? String
        self.swiftCode = shopData["swift_code"] as? String
        
        self.codEmail = shopData["cod_email"] as? String
        
        self.added = shopData["added"] as? String
        self.status = shopData["status"] as? String
        self.itemCount = shopData["item_count"] as? Int
        self.categoryCount = shopData["category_count"] as? Int
        self.subCategoryCount = shopData["sub_category_count"] as? Int
        self.followCount = shopData["follow_count"] as? Int
        
        self.coverImageFile = shopData["cover_image_file"] as? String
        self.coverImageWidth = shopData["cover_image_width"] as? String
        self.coverImageHeight = shopData["cover_image_height"] as? String
        self.coverImageDescription = shopData["cover_image_description"] as? String
        
        self.paypalEnabled = shopData["paypal_enabled"] as? String
        self.stripeEnabled = shopData["stripe_enabled"] as? String
        self.codEnabled = shopData["cod_enabled"] as? String
        self.bankTransferEnabled = shopData["banktransfer_enabled"] as? String
        
        self.currencySymbol = shopData["currency_symbol"] as? String
        self.currencyShortForm = shopData["currency_short_form"] as? String
        self.stripePublishableKey = shopData["stripe_publishable_key"] as? String
        
        for category in shopData["categories"] as! [NSDictionary] {
            self.categories.append(Category(categoryData: category))
        }
        
    }
    
    
}
