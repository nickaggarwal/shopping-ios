//
//  BasketTable.swift
//  Mokets
//
//  Created by PPH-MacMini on 31/5/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import SQLite

class BasketTable {
    
    static let tableName = "basket"
    static let table = Table(tableName)
    
    static let id              = Expression<Int64>("id")
    static let itemId          = Expression<String>("itemId")
    static let shopId          = Expression<String>("shopId")
    static let userId          = Expression<String>("userId")
    static let name            = Expression<String>("name")
    static let desc            = Expression<String?>("desc")
    static let unitPrice       = Expression<String>("unitPrice")
    static let discountPercent = Expression<String>("discountPercent")
    static let qty             = Expression<Int64>("qty")
    static let imagePath       = Expression<String>("imagePath")
    static let currencySymbol     = Expression<String>("currencySign")
    static let currencyShortForm  = Expression<String>("currencySymbol")
    static let selectedAttribute = Expression<String>("selectedAttribute")
    static let selectedAttributeIds = Expression<String>("selectedAttributeIds")
    
    static func createTable() {
        do {
            try PSSQLiteHelper.sharedInstance.db!.run(table.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(itemId)
                t.column(shopId)
                t.column(userId)
                t.column(name)
                t.column(desc)
                t.column(unitPrice)
                t.column(discountPercent)
                t.column(qty)
                t.column(imagePath)
                t.column(currencySymbol)
                t.column(currencyShortForm)
                t.column(selectedAttribute)
                t.column(selectedAttributeIds)
                })
        } catch { }
    }
    
    
    static func isExist(_ basket:BasketSchema) -> Bool {
        do {
            let count = try PSSQLiteHelper.sharedInstance.db!.scalar(table.filter(name == basket.name!).count)
            if count > 0 {
                return true
            }
        } catch _ {}
        return false
    }
    
    static func getAll() -> [BasketSchema] {
        var baskets = [BasketSchema]()
        do {
            for row in try PSSQLiteHelper.sharedInstance.db!.prepare(table) {
                let basket = BasketSchema(id: row[id],
                                          itemId: row[itemId],
                                          shopId: row[shopId],
                                          userId: row[userId],
                                          name: row[name],
                                          desc: row[desc]!,
                                          unitPrice: row[unitPrice],
                                          discountPercent: row[discountPercent],
                                          qty: row[qty],
                                          imagePath: row[imagePath],
                                          currencySymbol: row[currencySymbol],
                                          currencyShortForm: row[currencyShortForm],
                                          selectedAttribute: row[selectedAttribute],
                                          selectedAttributeIds: row[selectedAttributeIds])
                baskets.append(basket)
            }
        } catch { }
        
        return baskets
    }
    
    static func getByKeyIds(_ selectedShopId: String, selectedId: Int64) -> [BasketSchema] {
        var baskets = [BasketSchema]()
        let c = table.filter(shopId == selectedShopId && id == selectedId)
        do {
            for row in try PSSQLiteHelper.sharedInstance.db!.prepare(c) {
                let basket = BasketSchema(id: row[id],
                                          itemId: row[itemId],
                                          shopId: row[shopId],
                                          userId: row[userId],
                                          name: row[name],
                                          desc: row[desc]!,
                                          unitPrice: row[unitPrice],
                                          discountPercent: row[discountPercent],
                                          qty: row[qty],
                                          imagePath: row[imagePath],
                                          currencySymbol: row[currencySymbol],
                                          currencyShortForm: row[currencyShortForm],
                                          selectedAttribute: row[selectedAttribute],
                                          selectedAttributeIds: row[selectedAttributeIds])
                baskets.append(basket)
            }
        } catch { }
        
        return baskets
    }
    
    static func getByIdsAndAttrs(_ selectedItemId: String, paramAttrIds: String) -> Int64{
        var baskets = [BasketSchema]()
        let c = table.filter(itemId == selectedItemId)
        var keyId : Int64 = 0
        do {
            for row in try PSSQLiteHelper.sharedInstance.db!.prepare(c) {
                let basket = BasketSchema(id: row[id],
                                          itemId: row[itemId],
                                          shopId: row[shopId],
                                          userId: row[userId],
                                          name: row[name],
                                          desc: row[desc]!,
                                          unitPrice: row[unitPrice],
                                          discountPercent: row[discountPercent],
                                          qty: row[qty],
                                          imagePath: row[imagePath],
                                          currencySymbol: row[currencySymbol],
                                          currencyShortForm: row[currencyShortForm],
                                          selectedAttribute: row[selectedAttribute],
                                          selectedAttributeIds: row[selectedAttributeIds])
                baskets.append(basket)
            }
        } catch { }
        
        if baskets.count > 0 {
            
            for  ii in 0..<baskets.count {
                let attr : String = baskets[ii].selectedAttribute!
                print("Attribute : \(attr)")
                let attrIds : String = baskets[ii].selectedAttributeIds!
                print("Attribute Id : \(attrIds)")
                
                let attrIdArray = attrIds.split(separator: ",")
                
                    let paramAttrIdsArray = paramAttrIds.split(separator: ",")
                    
                    var allSame : Bool = true
                    
                    for paramData in paramAttrIdsArray {
                        var status : Bool = false
                        
                        for i in 0..<attrIdArray.count {
                            if(paramData == attrIdArray[i]) {
                                status = true
                                break
                            }
                        }
                        
                        if !status {
                            allSame = false
                            keyId = 0
                            print("Attr not found key for \(paramData)")
                        }else {
                            print("Attr found key for \(paramData)")
                        }
                        
                    }
                    
                    if (allSame && paramAttrIdsArray.count > 0) || (allSame && attrIdArray.count == 0) {
                        keyId = baskets[ii].id!
                    }
                
                
                if keyId != 0 {
                    break;
                }
            }
            
        }
        
        
        return keyId
    }
    
    static func getByShopId(_ selectedShopId: String) -> [BasketSchema] {
        var baskets = [BasketSchema]()
        let c = table.filter(shopId == selectedShopId)
        do {
            for row in try PSSQLiteHelper.sharedInstance.db!.prepare(c) {
                let basket = BasketSchema(id: row[id],
                                          itemId: row[itemId],
                                          shopId: row[shopId],
                                          userId: row[userId],
                                          name: row[name],
                                          desc: row[desc]!,
                                          unitPrice: row[unitPrice],
                                          discountPercent: row[discountPercent],
                                          qty: row[qty],
                                          imagePath: row[imagePath],
                                          currencySymbol: row[currencySymbol],
                                          currencyShortForm: row[currencyShortForm],
                                          selectedAttribute: row[selectedAttribute],
                                          selectedAttributeIds: row[selectedAttributeIds])
                baskets.append(basket)
            }
        } catch { }
        
        return baskets
    }
    
    static func getByShopIdAndUserId(_ selectedShopId: String, loginUserId: String) -> [BasketSchema] {
        var baskets = [BasketSchema]()
        let c = table.filter(shopId == selectedShopId && userId == loginUserId)
        do {
            for row in try PSSQLiteHelper.sharedInstance.db!.prepare(c) {
                let basket = BasketSchema(id: row[id],
                                          itemId: row[itemId],
                                          shopId: row[shopId],
                                          userId: row[userId],
                                          name: row[name],
                                          desc: row[desc]!,
                                          unitPrice: row[unitPrice],
                                          discountPercent: row[discountPercent],
                                          qty: row[qty],
                                          imagePath: row[imagePath],
                                          currencySymbol: row[currencySymbol],
                                          currencyShortForm: row[currencyShortForm],
                                          selectedAttribute: row[selectedAttribute],
                                          selectedAttributeIds: row[selectedAttributeIds])
                baskets.append(basket)
            }
        } catch { }
        
        return baskets
    }
    
    static func insert(_ basket:BasketSchema) -> Int64{
        var rowId: Int64 = 0
        
        do {
            let insert = table.insert(
                itemId <- basket.itemId!,
                shopId <- basket.shopId!,
                userId <- basket.userId!,
                name <- basket.name!,
                desc <- basket.desc,
                unitPrice <- basket.unitPrice!,
                discountPercent <- basket.discountPercent!,
                qty <- basket.qty!,
                imagePath <- basket.imagePath!,
                currencySymbol <- basket.currencySymbol!,
                currencyShortForm <- basket.currencyShortForm!,
                selectedAttribute <- basket.selectedAttribute!,
                selectedAttributeIds <- basket.selectedAttributeIds!)
            
                rowId = try PSSQLiteHelper.sharedInstance.db!.run(insert)
        } catch { }
        
        return rowId
    }
    
    static func updateAllByKeyId(_ basket:BasketSchema,selectedShopId: String, selectedId: Int64) {
        do {
            let c = table.filter(shopId == selectedShopId && id == selectedId)
            
            _ = try PSSQLiteHelper.sharedInstance.db!.run(c.update(
                itemId <- basket.itemId!,
                shopId <- basket.shopId!,
                userId <- basket.userId!,
                name <- basket.name!,
                desc <- basket.desc,
                unitPrice <- basket.unitPrice!,
                discountPercent <- basket.discountPercent!,
                qty <- basket.qty!,
                imagePath <- basket.imagePath!,
                currencySymbol <- basket.currencySymbol!,
                currencyShortForm <- basket.currencyShortForm!,
                selectedAttribute <- basket.selectedAttribute!,
                selectedAttributeIds <- basket.selectedAttributeIds!
                ))
        } catch { }
    }
    
//    static func updateQty(_ basket:BasketSchema,selectedShopId: String, selectedItemId: String) {
//        do {
//            let c = table.filter(shopId == selectedShopId && itemId == selectedItemId)
//
//            _ = try PSSQLiteHelper.sharedInstance.db!.run(c.update(qty <- basket.qty!))
//        } catch { }
//    }
    static func updateQtyById(_ basket:BasketSchema,selectedShopId: String, selectedId: Int64) {
        do {
            let c = table.filter(shopId == selectedShopId && id == selectedId)
            
            _ = try PSSQLiteHelper.sharedInstance.db!.run(c.update(qty <- basket.qty!))
        } catch { }
    }
    
    static func deleteAll(_ basket:BasketSchema) {
        do {
            let c = table.filter(id == 1)
            
            _ = try PSSQLiteHelper.sharedInstance.db!.run(c.delete())
        } catch { }
    }
    
    static func deleteByKeyIds(_ selectedShopId: String, selectedId: Int64) {
        do {
            let c = table.filter(shopId == selectedShopId && id == selectedId)
            
            _ = try PSSQLiteHelper.sharedInstance.db!.run(c.delete())
        } catch { }
    }
    
    static func deleteByShopId(_ selectedShopId: String) {
        do {
            let c = table.filter(shopId == selectedShopId)
            
            _ = try PSSQLiteHelper.sharedInstance.db!.run(c.delete())
        } catch { }
    }
}
