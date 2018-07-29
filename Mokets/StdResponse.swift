//
//  StdResponse.swift
//  Mokets
//
//  Created by Panacea-soft on 17/1/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import Alamofire

final class StdResponse: NSObject, ResponseObjectSerializable {
    var status: String?
    var data: String!
    var intData: Int!
    
    internal init?(response: HTTPURLResponse, representation: Any) {
        self.status = (representation as AnyObject).value(forKeyPath: "status") as? String
        
        if let str = (representation as AnyObject).value(forKeyPath: "data") as? String {
                  self.data = str
        } else {
            let str = (representation as AnyObject).value(forKeyPath: "data") as? Int
            self.intData = str
        }
    }
}

