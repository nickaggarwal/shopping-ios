//
//  Inspiration.swift
//  RWDevCon
//
//  Created by Mic Pringle on 02/03/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

class ShopModel {

    var id: String
    var name: String
    var categoryCount: Int
    var subCategoryCount: Int
    var description: String
    var backgroundImage: String
    var lat: String
    var lng: String
    
    var paypalEnabled: String
    var stripeEnabled: String
    var codEnabled: String
    var bankTransferEnabled: String
    
    var paypalEmail: String
    var paypalEnvironment: String
    var paypalMerchantName: String
    var paypalCustomerId: String
    
    var bankAccount: String
    var bankName: String
    var bankCode: String
    var branchCode: String
    var swiftCode: String
    
    var codEmail: String
    
    var currencySymbol: String
    var currencyShortForm: String
    
    var phone: String
    var email: String
    var address: String
    
    var stripePublishableKey: String
    
    var catAndSubCat: String {
        get {
            return language.categories + String(categoryCount) + language.subCategories + String(subCategoryCount)
        }
    }
    
    init(id: String, name: String, categoryCount: Int, subCategoryCount: Int, description: String, backgroundImage: String, lat: String, lng: String, paypalEnabled: String, stripeEnabled: String, codEnabled: String, bankTransferEnabled: String, paypalEmail: String, paypalEnvironment: String, paypalMerchantName: String, paypalCustomerId: String, bankAccount: String, bankName: String, bankCode: String, branchCode: String, swiftCode: String, codEmail: String, currencySymbol: String, currencyShortForm: String, phone: String, email: String, address: String, stripePublishableKey: String) {
        self.id = id
        self.name = name
        self.categoryCount = categoryCount
        self.subCategoryCount = subCategoryCount
        self.description = description
        self.backgroundImage = backgroundImage
        self.lat = lat
        self.lng = lng
        
        self.paypalEnabled = paypalEnabled
        self.stripeEnabled = stripeEnabled
        self.codEnabled = codEnabled
        self.bankTransferEnabled = bankTransferEnabled
        
        self.paypalEmail = paypalEmail
        self.paypalEnvironment = paypalEnvironment
        self.paypalMerchantName = paypalMerchantName
        self.paypalCustomerId = paypalCustomerId
        
        self.bankAccount = bankAccount
        self.bankCode = bankCode
        self.bankName = bankName
        self.branchCode = branchCode
        self.swiftCode = swiftCode
        
        self.codEmail = codEmail
        
        self.currencySymbol = currencySymbol
        self.currencyShortForm = currencyShortForm
        
        self.phone = phone
        self.address = address
        self.email = email
        
        self.stripePublishableKey = stripePublishableKey
        
    }
    
    convenience init(shop: Shop) {
        let id = shop.id!
        let name = shop.name! as String
        
        let backgroundName = shop.coverImageFile! as String
        let backgroundImage = backgroundName 
        
        let categoryCount = shop.categoryCount!
        let subCategoryCount = shop.subCategoryCount!
        let description = shop.desc! as String
        
        let lat = shop.lat! as String
        let lng = shop.lng! as String
        
        let paypalEnabled = shop.paypalEnabled! as String
        let stripeEnabled = shop.stripeEnabled! as String
        let codEnabled = shop.codEnabled! as String
        let bankTransferEnabled = shop.bankTransferEnabled! as String
        
        let paypalEmail = shop.paypalEmail! as String
        let paypalEnvironment = shop.paypalEnvironment! as String
        let paypalMerchantName = shop.paypalMerchantname! as String
        let paypalCustomerId = shop.paypalCustomerId! as String
        
        let bankAccount = shop.bankAccount! as String
        let bankCode = shop.bankCode! as String
        let bankName = shop.bankName! as String
        let branchCode = shop.branchCode! as String
        let swiftCode = shop.swiftCode! as String
        
        let codEmail = shop.codEmail! as String
        
        let currencySymbol = shop.currencySymbol! as String
        let currencyShortForm = shop.currencyShortForm! as String
        
        let phone = shop.phone! as String
        let email = shop.email! as String
        let address = shop.address! as String
        let stripePublishableKey = shop.stripePublishableKey! as String

        
        self.init(id: id, name: name,categoryCount : categoryCount,subCategoryCount: subCategoryCount, description: description,backgroundImage: backgroundImage, lat: lat, lng: lng, paypalEnabled: paypalEnabled, stripeEnabled: stripeEnabled, codEnabled: codEnabled,bankTransferEnabled: bankTransferEnabled, paypalEmail: paypalEmail, paypalEnvironment: paypalEnvironment, paypalMerchantName: paypalMerchantName, paypalCustomerId: paypalCustomerId, bankAccount: bankAccount, bankName: bankName, bankCode: bankCode, branchCode: branchCode, swiftCode: swiftCode, codEmail: codEmail, currencySymbol:currencySymbol, currencyShortForm: currencyShortForm, phone: phone, email: email, address: address, stripePublishableKey: stripePublishableKey)
    }

}
