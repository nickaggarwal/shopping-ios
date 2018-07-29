//
//  NewsFeed.swift
//  Mokets
//
//  Created by Panacea-soft on 22/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

final class NewsFeed: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    var id: String?
    var shopId: String?
    var title: String?
    var desc: String?
    var isPublished: String?
    var added: String?
    var images: [Image] = []
    
    init(newsData: NSDictionary) {
        super.init()
        self.setData(newsData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let newsData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(newsData)
    }
    
    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [NewsFeed] {
        var newsFeeds = [NewsFeed]()
        
        if var _ = (representation as AnyObject).value(forKeyPath: "data") as? [NSDictionary]{
            for newsFeed in (representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary] {
                newsFeeds.append(NewsFeed(newsData: newsFeed))
            }
        }
        
        return newsFeeds
    }
    
    func setData(_ newsData: NSDictionary) {
        self.id = newsData["id"] as? String
        self.shopId = newsData["shop_id"] as? String
        self.title = newsData["title"] as? String
        self.desc = newsData["description"] as? String
        self.isPublished = newsData["is_published"] as? String
        self.added = newsData["added"] as? String
        
        for image in newsData["images"] as! [NSDictionary] {
            self.images.append(Image(imageData: image))
        }
        
    }
}
