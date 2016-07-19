//
//  Database.swift
//  echotags
//
//  Created by bkzl on 23/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import RealmSwift

class Database {
    var db = try! Realm()

    func copyToFileSystem() {
        let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
        let fileManager = NSFileManager.defaultManager()
        
        if let dbPath = NSBundle.mainBundle().URLForResource("DB", withExtension: "realm") {
            do {
                try fileManager.removeItemAtURL(defaultURL)
                try fileManager.copyItemAtURL(dbPath, toURL: defaultURL)
                UserDefaults.hasBeenLaunched = true
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
