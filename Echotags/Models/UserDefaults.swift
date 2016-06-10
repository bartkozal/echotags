//
//  UserDefaults.swift
//  Echotags
//
//  Created by bkzl on 09/06/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import Foundation

struct UserDefaults {
    static func isFirstLaunch() -> Bool {
        return !NSUserDefaults.standardUserDefaults().boolForKey("hasBeenLaunched")
    }
    
    static func markAsLaunched() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasBeenLaunched")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
