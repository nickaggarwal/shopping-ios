//
//  Category.swift
//  Mokets
//
//  Created by Panacea-soft on 14/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

final class Category: NSObject {
    var id: String?
    var shopId: String?
    var name: String?
    var isPublished: String?
    var ordering: String?
    var added: String?
    var updated: String?
    var coverImageFile: String?
    var coverImageWidth: String?
    var coverImageHeight: String?
    
    var subCategories: [SubCategory] = []
    
    init(categoryData: NSDictionary) {
        super.init()
        self.setData(categoryData)
    }
    
    func setData(_ categoryData: NSDictionary) {
        self.id = categoryData["id"] as? String
        self.shopId = categoryData["shop_id"] as? String
        self.name = categoryData["name"] as? String
        self.isPublished = categoryData["is_published"] as? String
        self.ordering = categoryData["ordering"] as? String
        self.added = categoryData["added"] as? String
        self.updated = categoryData["updated"] as? String
        self.coverImageFile = categoryData["cover_image_file"] as? String
        self.coverImageWidth = categoryData["cover_image_width"] as? String
        self.coverImageHeight = categoryData["cover_image_height"] as? String
        
        for subCat in categoryData["sub_categories"] as! [NSDictionary] {
            self.subCategories.append(SubCategory(subCategoryData: subCat))
        }
        
    }
}
