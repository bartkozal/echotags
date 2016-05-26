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
        let db = try! Realm()
        let defaultURL = db.configuration.fileURL!
        let fileManager = NSFileManager.defaultManager()
        
        if let dbPath = NSBundle.mainBundle().URLForResource("DB", withExtension: "realm") {
            do {
                try fileManager.removeItemAtURL(defaultURL)
                try fileManager.copyItemAtURL(dbPath, toURL: defaultURL)
            } catch {}
        }
        
        let folderPath = defaultURL.URLByDeletingLastPathComponent!.path!
        try! fileManager.setAttributes([NSFileProtectionKey: NSFileProtectionNone], ofItemAtPath: folderPath)
    }
}
