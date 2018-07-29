//
//  Extensions.swift
//  CitiesDirectory
//
//  Created by Thet Paing Soe on 10/3/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Foundation
import Alamofire

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    // For image loading from server with url
    func loadImage(urlString : String, completionHandler: @escaping (String, String, UIImage, String) -> Void) {
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage
        {
            self.image = imageFromCache
            completionHandler(STATUS.success, urlString, imageFromCache, "success")
            return
        }
        print("URL : " + urlString)
        Alamofire.request(urlString).responseData { response in
            guard let data = response.result.value else {
                let errmsg : String = "error in loading image."
                let img = UIImage()
                
                completionHandler(STATUS.fail, urlString, img, errmsg)
                
                return
            }
            self.image = UIImage(data: data)
            
            if self.image != nil {
                
                imageCache.setObject(self.image!, forKey: urlString as AnyObject)
                completionHandler(STATUS.success, urlString, self.image!, "success")
            }else {
                completionHandler(STATUS.fail, urlString, UIImage(), "success")
            }
            
            
        }
        
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
