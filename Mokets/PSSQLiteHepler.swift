//
//  PSSQLiteHepler.swift
//  Mokets
//
//  Created by PPH-MacMini on 31/5/16.
//  Copyright © 2016 Panacea-soft. All rights reserved.
//

import SQLite

class PSSQLiteHelper {
    static let sharedInstance = PSSQLiteHelper()
    let db: Connection?
    
    init() {
        let dbName = "panacea.mokets"
        
        //let path = NSSearchPathForDirectoriesInDomains(
        //    .DocumentDirectory, .UserDomainMask, true
        //   ).first!
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        
        do {
            db = try Connection("\(documentsURL)\(dbName)")
        } catch {
            print("error")
            db = nil
        }
    }
}
