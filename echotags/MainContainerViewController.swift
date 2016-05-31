//
//  MainContainerViewController.swift
//  echotags
//
//  Created by bkzl on 17/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Spring

class MainContainerViewController: UIViewController {
    var isOverlayHidden = true
    
    @IBOutlet weak var settingsButton: DesignableButton!
    
    @IBAction func touchSettings(sender: DesignableButton) {
        sender.userInteractionEnabled = false
        if let mapVC = childViewControllers.first as? MapViewController {
            if let settingsVC = mapVC.presentedViewController as? SettingsViewController {
                mapVC.reloadPointAnnotations()
                settingsVC.performUnwindToHomeOnButton(sender)
            } else {
                mapVC.performSegueToSettingsOnButton(sender)
            }
        }
    }
}
