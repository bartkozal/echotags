//
//  Data.swift
//  echotags
//
//  Created by bkzl on 23/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import RealmSwift

class Data {
    static let db = try! Realm()
    
    static func dbInit() {
        var dbConfig = Realm.Configuration()
        
        guard let dbPath = NSBundle.mainBundle().URLForResource("DB", withExtension: "realm") else { return }
        
        dbConfig.fileURL = dbPath
        
        Realm.Configuration.defaultConfiguration = dbConfig
    }
}
