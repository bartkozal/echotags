//
//  Alert.swift
//  echotags
//
//  Created by bkzl on 30/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

struct Alert {
    
    private static func singleAction(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        
        return alertController
    }
    
    static func outOfBounds() -> UIAlertController {
        return singleAction(
            "Out of bounds",
            message: "Seems you are out of Amsterdam. You can still review markers but navigation mode is unavailable."
        )
    }
    
    static func twitterUnavailable() -> UIAlertController {
        return singleAction(
            "Account is unavailable",
            message: "You are not logged in to your Twitter account."
        )
    }
    
    static func facebookUnavailable() -> UIAlertController {
        return singleAction(
            "Account is unavailable",
            message: "You are not logged in to your Facebook account."
        )
    }
    
    static func accessToLocationBackgroundDenied()  -> UIAlertController {
        let alertController = UIAlertController(
            title: "You didn't allow to access background location",
            message: "In order to play audio messages, please tap on \"Settings\" and set location access to \"While Using the App\".",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Settings", style: .Default) { _ in
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        
        return alertController
    }
}
