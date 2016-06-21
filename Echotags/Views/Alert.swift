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
        let alertController = UIAlertController(
            title: "Centering is unavailable",
            message: "For some reasons centering wasn't possible. Please try again in a few seconds.",
            preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(okAction)
        
        vc.presentViewController(alertController, animated: true, completion: nil)
    }
}
