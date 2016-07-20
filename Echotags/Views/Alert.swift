//
//  Alert.swift
//  echotags
//
//  Created by bkzl on 30/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

struct Alert {
    
    private static func alertDialog(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        
        return alertController
    }
    
    private static func confirmDialog(title: String, message: String, caption: String, handler: (UIAlertAction) -> Void) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .Alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: caption, style: .Default, handler: handler)
        alertController.addAction(confirmAction)
        
        return alertController
    }
    
    static func outOfBounds() -> UIAlertController {
        return alertDialog(
            "Out of Amsterdam",
            message: "Looks like you are out of Amsterdam. You can still review markers on the map but discovery mode is unavailable."
        )
    }
    
    static func twitterUnavailable() -> UIAlertController {
        return alertDialog(
            "Account is unavailable",
            message: "You are not logged in to your Twitter account."
        )
    }
    
    static func facebookUnavailable() -> UIAlertController {
        return alertDialog(
            "Account is unavailable",
            message: "You are not logged in to your Facebook account."
        )
    }
    
    static func accessToLocationBackgroundDenied() -> UIAlertController {
        return confirmDialog(
            "You didn't allow to access background location",
            message: "In order to play audio messages, please tap on \"Settings\" and set location access to \"While Using the App\".",
            caption: "Settings",
            handler: { _ in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        )
    }
    
    static func resetVisitedPoints(sender: AnyObject?) -> UIAlertController {
        return confirmDialog(
            "Are you sure?",
            message: "This will mark all places on the map as unvisited",
            caption: "Confirm",
            handler: { _ in
                let settingsVC = sender as! SettingsViewController
                
                settingsVC.resetVisitedButton.enabled = false
                settingsVC.categoriesHaveChanged = true
                Point.markAllAsUnvisited()
            }
        )
    }
}
