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
    @IBOutlet weak var settingsButton: DesignableButton!
    
    @IBAction func touchSettings(sender: DesignableButton) {
        sender.userInteractionEnabled = false
        if let homeVC = childViewControllers.first as? HomeViewController {
            if let settingsVC = homeVC.presentedViewController as? SettingsViewController {
                if settingsVC.categoriesChanged {
                    homeVC.reloadPointAnnotations()
                    settingsVC.categoriesChanged = false
                }
                settingsVC.performUnwindToHomeOnButton(sender)
            } else {
                homeVC.performSegueToSettingsOnButton(sender)
            }
        }
    }
}
