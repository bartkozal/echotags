//
//  Database.swift
//  echotags
//
//  Created by bkzl on 23/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import Foundation
import RealmSwift

class Database {
    var db = try! Realm()

    func copyToFileSystem() {
        let defaultURL = Realm.Configuration.defaultConfiguration.fileURL!
        let fileManager = FileManager.default
        
        if let dbPath = Bundle.main.url(forResource: "DB", withExtension: "realm") {
            do {
                try fileManager.removeItem(at: defaultURL)
                try fileManager.copyItem(at: dbPath, to: defaultURL)
                UserDefaults.hasBeenLaunched = true
            } catch {
                print(error)
            }
        }

        let folderPath = defaultURL.deletingLastPathComponent().path

        do {
            try fileManager.setAttributes([.protectionKey: FileProtectionType.none], ofItemAtPath: folderPath)
        } catch {
            print(error)
        }
    }
}
