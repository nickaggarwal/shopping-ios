//
//  SubCategory.swift
//  Mokets
//
//  Created by Panacea-soft on 14/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class SubCategory: NSObject {
    var id: String?
    var catId: String?
    var shopId: String?
    var name: String?
    var isPublished: String?
    var ordering: String?
    var added: String?
    var updated: String?
    var coverImageFile: String?
    var coverImageWidth: String?
    var coverImageHeight: String?
    
    init(subCategoryData: NSDictionary) {
        super.init()
        self.setData(subCategoryData)
    }
    
    func setData(_ subCatData: NSDictionary) {
        self.id = subCatData["id"] as? String
        self.catId = subCatData["cat_id"] as? String
        self.shopId = subCatData["shop_id"] as? String
        self.name = subCatData["name"] as? String
        self.isPublished = subCatData["is_published"] as? String
        self.ordering = subCatData["ordering"] as? String
        self.added = subCatData["added"] as? String
        self.updated = subCatData["updated"] as? String
        self.coverImageFile = subCatData["cover_image_file"] as? String
        self.coverImageWidth = subCatData["cover_image_width"] as? String
        self.coverImageHeight = subCatData["ascover_image_height"] as? String
    }
}
