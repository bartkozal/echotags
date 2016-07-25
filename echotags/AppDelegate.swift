//
//  AppDelegate.swift
//  echotags
//
//  Created by bkzl on 10/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if !UserDefaults.hasBeenLaunched {
            Database().copyToFileSystem()
        }
        
        return true
    }
}
