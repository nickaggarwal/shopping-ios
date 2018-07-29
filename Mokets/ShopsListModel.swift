//
//  CitiesListModel.swift
//  Mokets
//
//  Created by Panacea-soft on 25/2/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

class ShopsListModel {
    internal var shops  = [ShopModel]()
    class var sharedManager: ShopsListModel {
        struct Static {
            static let instance = ShopsListModel()
        }
        return Static.instance
    }
}