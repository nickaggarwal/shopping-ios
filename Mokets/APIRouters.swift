//
//  APIRouters.swift
//  Mokets
//
//  Created by Panacea-soft on 14/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Alamofire
import Foundation

enum APIRouters: URLRequestConvertible {
    static let baseURLString = configs.mainUrl
    static let imageURLString = configs.imageUrl
    
    static let getShops              = configs.getShops
    static let getShopByID           = configs.getShopByID
    static let itemsBySubCategory    = configs.itemsBySubCategory
    static let allItemsBySubCategory = configs.allItemsBySubCategory
    static let itemById              = configs.itemById
    static let searchByGeo           = configs.searchByGeo
    static let userLogin             = configs.userLogin
    static let getFavouriteItems     = configs.getFavouriteItems
    static let addItemInquiry        = configs.addItemInquiry
    static let addItemReview         = configs.addItemReview
    static let addAppUser            = configs.addAppUser
    static let resetPassword         = configs.resetPassword
    static let updateAppUser         = configs.updateAppUser
    static let profilePhotoUpload    = configs.profilePhotoUpload
    static let addItemLike           = configs.addItemLike
    static let isLikedItem           = configs.isLikedItem
    static let isFavouritedItem      = configs.isFavouritedItem
    static let addItemFavourite      = configs.addItemFavourite
    static let addItemTouch          = configs.addItemTouch
    static let getNewsFeedByShopId   = configs.getNewsFeedByShopId
    static let searchByKeyword       = configs.searchByKeyword
    static let registerPushNoti      = configs.registerPushNoti
    static let addItemRating         = configs.addItemRating
    static let submitTransaction     = configs.transactionSubmit
    static let userTransactionHistory = configs.userTransactionHistory
    static let getAbout = configs.getAbout
    
    case GetShops()
    case GetShopByID(Int)
    case ItemsBySubCategory(Int, Int, Int, Int)
    case AllItemsBySubCategory(Int, Int)
    case ItemById(Int, Int)
    case SearchByGeo(Float, Double, Double, Int, Int)
    case UserLogin([String : AnyObject])
    case GetFavouriteItems(Int, Int, Int)
    case AddItemInquiry(Int, [String : AnyObject])
    case AddItemReview(Int, [String: AnyObject])
    case AddAppUser([String: AnyObject])
    case ResetPassword([String: AnyObject])
    case UpdateAppUser(Int, [String: AnyObject])
    case AddItemLike(Int,[String: AnyObject])
    case IsLikedItem(Int,[String: AnyObject])
    case IsFavouritedItem(Int,[String: AnyObject])
    case AddItemFavourite(Int,[String: AnyObject])
    case AddItemTouch(Int,[String: AnyObject])
    case GetNewsFeedByShopId(Int)
    case SearchByKeyword(Int,[String: AnyObject])
    case RegitsterPushNoti([String: AnyObject])
    case AddItemRating(Int, [String: AnyObject])
    case SubmitTransaction([String: AnyObject])
    case UserTransactionHistory(Int)
    case GetAbout()
    
    public func asURLRequest() throws -> URLRequest {
        
        let (path, parameters, method) : (String, [String: AnyObject], HTTPMethod) = {
            
            switch self {
                
            case .GetShops():
                return (APIRouters.getShops, ["params":"no" as AnyObject], .get)
                
            case .ItemsBySubCategory(let cityId, let subCategoryId, let count, let from):
                let url: String = NSString(format: APIRouters.itemsBySubCategory as NSString, cityId, subCategoryId, count, from) as String
                return (url, ["params":"no" as AnyObject], .get)
                
            case .AllItemsBySubCategory(let cityId, let subCategoryId) :
                let url: String = NSString(format: APIRouters.allItemsBySubCategory as NSString, cityId, subCategoryId) as String
                return (url, ["params":"no" as AnyObject], .get)
                
            case .ItemById(let itemId, let cityId):
                let url: String = NSString(format: APIRouters.itemById as NSString, itemId, cityId) as String
                return (url, ["params":"no" as AnyObject], .get)
                
            case .SearchByGeo(let mile, let lat, let long, let cityId, let subCatId):
                let url: String = NSString(format: APIRouters.searchByGeo as NSString, mile, lat, long, cityId, subCatId) as String
                return (url, ["params":"no" as AnyObject], .get)
                
            case .UserLogin(let params):
                return (APIRouters.userLogin, params, .post)
                
            case .GetFavouriteItems(let userId, let count, let from):
                let url: String = NSString(format: APIRouters.getFavouriteItems as NSString, userId, count, from) as String
                return (url, ["params":"no" as AnyObject], .get)
                
            case .AddItemInquiry(let itemId, let params):
                let url: String = NSString(format: APIRouters.addItemInquiry as NSString, itemId) as String
                return (url, params, .post)
                
            case .AddItemReview(let itemId, let params):
                let url: String = NSString(format: APIRouters.addItemReview as NSString, itemId) as String
                return (url, params, .post)
                
            case .AddAppUser(let params):
                return (APIRouters.addAppUser, params, .post)
                
            case .ResetPassword(let params):
                return (APIRouters.resetPassword, params, .post)
                
            case .UpdateAppUser(let userId, let params):
                let url: String = NSString(format: APIRouters.updateAppUser as NSString, userId) as String
                return (url, params, .put)
                
            case .GetShopByID(let shopID):
                let url: String = NSString(format: APIRouters.getShopByID as NSString, shopID) as String
                return (url,["params":"no" as AnyObject], .get)
                
            case .AddItemLike(let itemId, let params):
                let url: String = NSString(format: APIRouters.addItemLike as NSString, itemId) as String
                return (url, params, .post)
                
            case .IsLikedItem(let itemId, let params) :
                let url: String = NSString(format: APIRouters.isLikedItem as NSString, itemId) as String
                return (url, params, .post)
                
            case .IsFavouritedItem(let itemId, let params) :
                let url: String = NSString(format: APIRouters.isFavouritedItem as NSString, itemId) as String
                return (url, params, .post)
                
            case .AddItemFavourite(let itemId, let params) :
                let url: String = NSString(format: APIRouters.addItemFavourite as NSString, itemId) as String
                return (url, params, .post)
                
            case .AddItemTouch(let itemId, let params) :
                let url: String = NSString(format: APIRouters.addItemTouch as NSString, itemId) as String
                return (url, params, .post)
                
            case .GetNewsFeedByShopId(let cityId):
                let url: String = NSString(format: APIRouters.getNewsFeedByShopId as NSString, cityId) as String
                return (url,["params":"no" as AnyObject], .get)
                
            case .SearchByKeyword(let cityId, let params) :
                let url: String = NSString(format: APIRouters.searchByKeyword as NSString, cityId) as String
                return (url, params, .post)
                
            case .RegitsterPushNoti(let params):
                return (APIRouters.registerPushNoti, params, .post)
                
            case .AddItemRating(let itemId, let params):
                let url: String = NSString(format: APIRouters.addItemRating as NSString, itemId) as String
                return (url, params, .post)
                
            case .SubmitTransaction(let params):
                print(params)
                return (APIRouters.submitTransaction, params, .post)
                
            case .UserTransactionHistory(let userId):
                let url: String = NSString(format: APIRouters.userTransactionHistory as NSString, userId) as String
                return (url,["params":"no" as AnyObject], .get)
                
            case .GetAbout() :
                return (APIRouters.getAbout, ["params":"no" as AnyObject], .get)
                
            }
            
        }()
        
/*
        let url = try APIRouters.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = TimeInterval(configs.timeoutInterval)
 */
        let url = try APIRouters.baseURLString.asURL()
        
        //For Offline Cache
        let cachePolicy: NSURLRequest.CachePolicy = Reachability.isConnectedToNetwork() ? .reloadIgnoringLocalCacheData : .returnCacheDataElseLoad
        let timeout = 1
        var urlRequest = URLRequest(url: url.appendingPathComponent(path), cachePolicy: cachePolicy, timeoutInterval: TimeInterval(timeout))
        urlRequest.addValue("private", forHTTPHeaderField: "Cache-Control")
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = TimeInterval(configs.timeoutInterval)
        
        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}

func UploadImage(url: String, userID: Int, image : UIImageView, completionHandler: @escaping (String, String, String) -> Void) {
    
    //DispatchQueue.main.async {
    let myUrl = NSURL(string: APIRouters.baseURLString + url);
    
    let request = NSMutableURLRequest(url:myUrl! as URL);
    request.httpMethod = "POST";
    
    
    let param = [
        "platformName"  : "ios",
        "userId"    : "\(userID)"
    ]
    
    let boundary = generateBoundaryString()
    
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let imageData = UIImageJPEGRepresentation(image.image!, 1)
    
    if(imageData==nil)  {
        DispatchQueue.main.async {
            completionHandler(STATUS.fail, "", language.imageIsNull)
        }
        return;
    }
    
    request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "pic", imageDataKey: imageData! as NSData, boundary: boundary) as Data
    
    let task = URLSession.shared.dataTask(with: request as URLRequest) {
        data, response, error in
        
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            print("error=\(String(describing: error))")
            DispatchQueue.main.async {
                completionHandler(STATUS.fail, "", language.networkError)
            }
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(String(describing: response))")
            
            DispatchQueue.main.async {
                completionHandler(STATUS.fail, "", language.tryAgainToConnect)
            }
            
            return
            
        }
        
        // You can print out response object
        print("******* response = \(String(describing: response))")
        
        // Print out reponse body
        let responseString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        print("****** response data = \(responseString!)")
        
        do {
            
            
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            
            // Normal String
            guard let status3 = json?["status"] as? String,
                let data3 = json?["data"] else {
                    
                    //let rRtn : [[String: AnyObject]] = []
                    DispatchQueue.main.async {
                        completionHandler(STATUS.fail, "", language.somethingWrong)
                    }
                    return
            }
            
            
            if status3 == "success" {
                DispatchQueue.main.async {
                    completionHandler(STATUS.success, data3 as! String, "Success")
                }
            }else {
                DispatchQueue.main.async {
                    completionHandler(STATUS.fail, data3 as! String , "Fail")
                }
            }
            
            
        }catch
        {
            DispatchQueue.main.async {
                completionHandler(STATUS.fail, "", language.somethingWrong)
            }
            return
            
        }
        
    }
    task.resume()
    //}
    
}

func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
    let body = NSMutableData();
    
    if parameters != nil {
        for (key, value) in parameters! {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
    }
    
    let filename = "user-profile.jpg"
    let mimetype = "image/jpg"
    
    body.appendString(string: "--\(boundary)\r\n")
    body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
    body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
    body.append(imageDataKey as Data)
    body.appendString(string: "\r\n")
    
    body.appendString(string: "--\(boundary)--\r\n")
    
    return body
}

func generateBoundaryString() -> String {
    return "Boundary-\(NSUUID().uuidString)"
}

struct  STATUS {
    static let success : String = "success"
    static let fail : String = "fail"
}
