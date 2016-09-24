//
//  Alert.swift
//  echotags
//
//  Created by bkzl on 30/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

struct Alert {
    
    static func alertDialog(_ title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        
        return alertController
    }
    
    static func confirmDialog(_ title: String, message: String, caption: String, handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: caption, style: .default, handler: handler)
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
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
        )
    }
    
    static func resetVisitedPoints(_ sender: AnyObject?) -> UIAlertController {
        return confirmDialog(
            "Are you sure?",
            message: "This will mark all places on the map as unvisited",
            caption: "Confirm",
            handler: { _ in
                let settingsVC = sender as! SettingsViewController
                
                settingsVC.resetVisitedButton.isEnabled = false
                settingsVC.categoriesHaveChanged = true
                Point.markAllAsUnvisited()
            }
        )
    }
}
