//
//  UserDefaults.swift
//  Echotags
//
//  Created by bkzl on 09/06/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import Foundation

struct UserDefaults {
    static var hasBeenLaunched: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("hasBeenLaunched")
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "hasBeenLaunched")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    static var hasOfflineMap: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("hasOfflineMap")
        }
        set {
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: "hasOfflineMap")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
