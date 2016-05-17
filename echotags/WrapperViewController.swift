//
//  WrapperViewController.swift
//  echotags
//
//  Created by bkzl on 17/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Spring

class WrapperViewController: UIViewController {
    
    @IBAction func touchSettings(sender: DesignableButton) {
        if let homeViewController = childViewControllers.first {
            if let settingViewController = homeViewController.presentedViewController as? SettingsViewController {
                sender.rotate = 90.0
                sender.animateTo()
                settingViewController.performSegueWithIdentifier("unwindToHome", sender: self)
            } else {
                sender.rotate = -90.0
                sender.animateTo()
                homeViewController.performSegueWithIdentifier("segueToSettings", sender: self)
            }
        }
    }
}
