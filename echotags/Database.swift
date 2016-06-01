//
//  Database.swift
//  echotags
//
//  Created by bkzl on 23/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import RealmSwift

class Database {
    var db: Realm
    
    init() {
        db = try! Realm()
    }

    func copyToFileSystem() {
        let defaultURL = db.configuration.fileURL!
        let fileManager = NSFileManager.defaultManager()
        
        if let dbPath = NSBundle.mainBundle().URLForResource("DB", withExtension: "realm") {
            do {
                try fileManager.removeItemAtURL(defaultURL)
                try fileManager.copyItemAtURL(dbPath, toURL: defaultURL)
            } catch {
                print(error)
            }
        }
        
        let folderPath = defaultURL.URLByDeletingLastPathComponent!.path!
        
        do {
            try fileManager.setAttributes([NSFileProtectionKey: NSFileProtectionNone], ofItemAtPath: folderPath)
        } catch {
            print(error)
        }
    }
}
