//
//  Alert.swift
//  echotags
//
//  Created by bkzl on 30/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

struct Alert {
    var vc: UIViewController
    
    func accessToLocationBackgroundDenied() {
        let alertController = UIAlertController(
            title: "You didn't allow to access background location",
            message: "In order to play audio messages, please tap on \"Settings\" and set location access to \"Always\".",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Settings", style: .Default) { _ in
            if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func mapCenteringUnavailable() {
        let alertController = okAlertController(
            "Centering is unavailable",
            message: "For some reasons centering wasn't possible. Please try again in a few seconds."
        )

        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func twitterUnavailable() {
        let alertController = okAlertController(
            "Account is unavailable",
            message: "You are not logged in to your Twitter account."
        )
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func facebookUnavailable() {
        let alertController = okAlertController(
            "Account is unavailable",
            message: "You are not logged in to your Facebook account."
        )
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func okAlertController(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        
        alertController.addAction(okAction)
        
        return alertController
    }
}
