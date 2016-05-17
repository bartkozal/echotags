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
        if let homeViewController = childViewControllers.first as? HomeViewController {
            if let settingsViewController = homeViewController.presentedViewController as? SettingsViewController {
                settingsViewController.performUnwindToHomeOnButton(sender)
            } else {
                homeViewController.performSegueToSettingsOnButton(sender)
            }
        }
    }
}
