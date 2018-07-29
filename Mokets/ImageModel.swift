//
//  ImageModel.swift
//  Mokets
//
//  Created by Panacea-soft on 19/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class ImageModel {
    var imageId: String
    var imageParentId: String
    var imageCoverName: String
    var imageWidth: String
    var imageHeight: String
    var imageDesc: String
    
    init(imageId: String, imageParentId: String, imageCoverName: String, imageWidth: String, imageHeight: String,  imageDesc: String) {
        self.imageId       = imageId
        self.imageParentId = imageParentId
        self.imageCoverName    = imageCoverName
        self.imageWidth    = imageWidth
        self.imageHeight   = imageHeight
        self.imageDesc     = imageDesc
    }
    
    convenience init(image: Image) {
        let id = image.id
        let parentId = image.parentId
        let imageName = image.path
        let width = image.width
        let height = image.height
        let desc = image.desc
        
        self.init(imageId: id!, imageParentId: parentId!, imageCoverName: imageName!, imageWidth: width!, imageHeight: height!, imageDesc: desc!)
    
    }
    
}
