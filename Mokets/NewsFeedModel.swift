//
//  NewsFeedModel.swift
//  Mokets
//
//  Created by Panacea-soft on 22/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class NewsFeedModel {
    var newsFeedId: String
    var newsFeedTitle: String
    var newsFeedDesc : String
    var newsFeedAdded: String
    var newsFeedImage: String
    var newsFeedImages = [Image]()
    
    init(newsFeedId: String, newsFeedTitle: String, newsFeedDesc: String,newsFeedAdded: String, newsFeedImage: String, NewsFeedImages:[Image] ) {
        self.newsFeedId = newsFeedId
        self.newsFeedTitle = newsFeedTitle
        self.newsFeedDesc = newsFeedDesc
        self.newsFeedAdded = newsFeedAdded
        self.newsFeedImage = newsFeedImage
        
        self.newsFeedImages = NewsFeedImages
    }
    
    convenience init(newsFeed: NewsFeed) {
        let id = newsFeed.id
        let title = newsFeed.title
        let desc = newsFeed.desc
        let added = newsFeed.added
        let imageName = newsFeed.images[0].path
        
        let imageArray:[Image] = newsFeed.images
        self.init(newsFeedId:id!, newsFeedTitle: title!, newsFeedDesc: desc!,newsFeedAdded: added!, newsFeedImage: imageName!, NewsFeedImages: imageArray)
        
    }
}
