//
//  UserDefaults.swift
//  Echotags
//
//  Created by bkzl on 09/06/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import Foundation

struct UserDefaults {
    private static let defaults = NSUserDefaults.standardUserDefaults()
    
    static var hasBeenLaunched: Bool {
        get {
            return defaults.boolForKey("hasBeenLaunched")
        }
        
        set {
            defaults.setBool(newValue, forKey: "hasBeenLaunched")
            defaults.synchronize()
        }
    }
    
    static var hasPassedTutorial: Bool {
        get {
            return defaults.boolForKey("hasPassedTutorial")
        }
        
        set {
            defaults.setBool(newValue, forKey: "hasPassedTutorial")
            defaults.synchronize()
        }
    }
    
    static var hasOfflineMap: Bool {
        get {
            return defaults.boolForKey("hasOfflineMap")
        }
        
        set {
            defaults.setBool(newValue, forKey: "hasOfflineMap")
            defaults.synchronize()
        }
    }
}
