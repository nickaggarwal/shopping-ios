//
//  About.swift
//  Mokets
//
//  Created by PPH-MacMini on 13/6/17.
//  Copyright © 2017 Panacea-soft. All rights reserved.
//

final class About: NSObject, ResponseCollectionSerializable, ResponseObjectSerializable {
    var id: String?
    var title: String?
    var desc: String?
    var email: String?
    var phone: String?
    var website: String?
    
    var images: [Image] = []
    
    init(aboutData: NSDictionary) {
        super.init()
        self.setData(aboutData)
    }
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        let aboutData = (representation as AnyObject).value(forKeyPath: "data") as! NSDictionary
        super.init()
        self.setData(aboutData)
    }
    
    internal static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [About] {
        var abouts = [About]()
        if var _ = (representation as AnyObject).value(forKey: "data") as? [NSDictionary]{
            
            for about in ((representation as AnyObject).value(forKeyPath: "data") as! [NSDictionary]) {
                abouts.append(About(aboutData: about))
                
            }
        }
        return abouts
    }
    
    func setData(_ aboutData: NSDictionary) {
        self.id    = aboutData["id"] as? String
        self.title = aboutData["title"] as? String
        self.desc  = aboutData["description"] as? String
        self.email = aboutData["email"] as? String
        self.phone = aboutData["phone"] as? String
        self.website = aboutData["website"] as? String
        
        if aboutData["images"] != nil {
            for image in aboutData["images"] as! [NSDictionary] {
                self.images.append(Image(imageData: image))
            }
        }
        
    }
    
    
}

