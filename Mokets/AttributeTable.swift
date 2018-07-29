//
//  AttributeTable.swift
//  Mokets
//
//  Created by PPH-MacMini on 31/5/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import SQLite
/*
class AttributeTable {
    
    static let tableName = "attribute"
    static let table = Table(tableName)
    
    static let id       = Expression<Int64>("id")
    static let attributeDetailId = Expression<String>("attributeDetailId")
    static let itemId   = Expression<String>("itemId")
    static let shopId   = Expression<String>("shopId")
    static let headerId = Expression<String>("headerId")
    static let name     = Expression<String>("name")
    static let price    = Expression<String>("price")
    
    //t.column(desc, unique: true)
    
    static func createTable() {
        do {
            try PSSQLiteHelper.sharedInstance.db!.run(table.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(attributeDetailId)
                t.column(itemId)
                t.column(shopId)
                t.column(headerId)
                t.column(name)
                t.column(price)
                
            })
        } catch { }
    }
    
    static func isExist(_ attribute:AttributeSchema) -> Bool {
        do {
            let count = try PSSQLiteHelper.sharedInstance.db!.scalar(table.filter(name == attribute.name!).count)
            if count > 0 {
                return true
            }
            
        } catch _ {}
        
        return false
    }
    
    static func getAll() -> [AttributeSchema] {
        var attributes = [AttributeSchema]()
        do {
            for row in try PSSQLiteHelper.sharedInstance.db!.prepare(table) {
                let attribute = AttributeSchema(id: row[id],
                                                attributeDetailId: row[attributeDetailId],
                                                itemId: row[itemId],
                                                shopId: row[shopId],
                                                headerId: row[headerId],
                                                name: row[name],
                                                price: row[price])
                attributes.append(attribute)
            }
        } catch { }
        
        return attributes
    }
    
    static func insert(_ attribute:AttributeSchema) -> Int64{
        var rowId: Int64 = 0
        
        do {
            let insert = table.insert(itemId <- attribute.itemId!,
                                      attributeDetailId <- attribute.attributeDetailId!,
                                      shopId <- attribute.shopId!,
                                      headerId <- attribute.headerId!,
                                      name <- attribute.name!,
                                      price <- attribute.price!)
            
            rowId = try PSSQLiteHelper.sharedInstance.db!.run(insert)
        } catch { }
        
        return rowId
    }
    
    
    static func update(_ attribute:AttributeSchema) {
        do {
            let c = table.filter(id == 1)
            
            _ = try PSSQLiteHelper.sharedInstance.db!.run(c.update(
                itemId <- attribute.itemId!,
                attributeDetailId <- attribute.attributeDetailId!,
                shopId <- attribute.shopId!,
                headerId <- attribute.headerId!,
                name <- attribute.name!,
                price <- attribute.price!))
        } catch { }
    }
    
    static func delete(_ attribute:AttributeSchema) {
        do {
            let c = table.filter(id == 1)
            
            _ = try PSSQLiteHelper.sharedInstance.db!.run(c.delete())
        } catch { }
    }
    
    static func deleteByShopId(_ selectedShopId: String) {
        do {
            let c = table.filter(shopId == selectedShopId)
            
            _ = try PSSQLiteHelper.sharedInstance.db!.run(c.delete())
        } catch { }
    }
    
    static func deleteByItemId(_ selectedItemId: String) {
        do {
            let c = table.filter(itemId == selectedItemId)
            
            _ = try PSSQLiteHelper.sharedInstance.db!.run(c.delete())
        } catch { }
    }
    
    static func getAllByIds(_ selectedHeaderId: String, _ selectedItemId: String)-> [AttributeSchema] {
        var attributes = [AttributeSchema]()
        let c = table.filter(headerId == selectedHeaderId && itemId == selectedItemId)
        do {
            for row in try PSSQLiteHelper.sharedInstance.db!.prepare(c) {
                let attribute = AttributeSchema(id: row[id],
                                                attributeDetailId: row[attributeDetailId],
                                                itemId: row[itemId],
                                                shopId: row[shopId],
                                                headerId: row[headerId],
                                                name: row[name],
                                                price: row[price])
                attributes.append(attribute)
            }
        } catch { }
        
        return attributes
    }
    
    static func getAllByItemId(_ selectedItemId: String)-> [AttributeSchema] {
        var attributes = [AttributeSchema]()
        let c = table.filter(itemId == selectedItemId)
        do {
            for row in try PSSQLiteHelper.sharedInstance.db!.prepare(c) {
                let attribute = AttributeSchema(id: row[id],
                                                attributeDetailId: row[attributeDetailId],
                                                itemId: row[itemId],
                                                shopId: row[shopId],
                                                headerId: row[headerId],
                                                name: row[name],
                                                price: row[price])
                attributes.append(attribute)
            }
        } catch { }
        
        return attributes
    }
    
    static func updateByIds(_ attribute:AttributeSchema, _ selectedHeaderId: String, _ selectedItemId: String) {
        do {
            let c = table.filter(headerId == selectedHeaderId && itemId == selectedItemId)
            
            _ = try PSSQLiteHelper.sharedInstance.db!.run(c.update(
                itemId <- attribute.itemId!,
                attributeDetailId <- attribute.attributeDetailId!,
                shopId <- attribute.shopId!,
                headerId <- attribute.headerId!,
                name <- attribute.name!,
                price <- attribute.price!))
        } catch { }
    }
    
}*/
