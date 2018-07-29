//
//  ItemModel.swift
//  Mokets
//
//  Created by Panacea-soft on 9/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class ItemModel {
    
    var itemId: String
    var itemShopId : String
    var itemName: String
    var itemImage: String
    var itemLikeCount: Int
    var itemReviewCount: Int
    var itemImageBlob : UIImage?
    var itemImageHeight : CGFloat
    var itemImageWidth : CGFloat
    var itemPrice: String
    
    init(itemId: String, itemShopId: String,itemName: String,itemImage: String, itemLikeCount: Int, itemReviewCount: Int, itemImageHeight : CGFloat, itemImageWidth : CGFloat, itemPrice: String) {
        self.itemId = itemId
        self.itemShopId = itemShopId
        self.itemName = itemName
        self.itemImage = itemImage
        self.itemLikeCount = itemLikeCount
        self.itemReviewCount = itemReviewCount
        self.itemImageHeight = itemImageHeight
        self.itemImageWidth = itemImageWidth
        self.itemPrice = itemPrice
    }
    
    convenience init(item: Item) {
        let id = item.id
        let name = item.name
        let shopId = item.shopId
        var imageName : String = ""
        var imageHeight : CGFloat = 0
        var imageWidth : CGFloat = 0
        if item.images.count > 0 {
            imageName = item.images[0].path! as String
            
            if let n = NumberFormatter().number(from: item.images[0].height!) {
                imageHeight = CGFloat(truncating: n)
            }
            
            if let n2 = NumberFormatter().number(from: item.images[0].width!) {
                imageWidth = CGFloat(truncating: n2)
            }
            
        }else{
            //TODO: Need to add default image
        }
       
        let likeCount = item.likeCount
        let reviewCount = item.reviewCount
        let itemPrice = item.price
        
        self.init(itemId:id!, itemShopId: shopId!, itemName: name!, itemImage: imageName, itemLikeCount: likeCount!, itemReviewCount: reviewCount!, itemImageHeight : imageHeight, itemImageWidth: imageWidth, itemPrice: itemPrice!)
        
    }
    
}
