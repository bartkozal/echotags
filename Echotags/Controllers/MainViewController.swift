//
//  MainViewController.swift
//  echotags
//
//  Created by bkzl on 17/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Spring

class MainViewController: UIViewController {
    @IBOutlet private weak var tutorialView: UIView! {
        didSet {
            tutorialView.hidden = false //UserDefaults.hasBeenLaunched
        }
    }
    
    @IBAction private func dismissTutorial() {
        UIView.animateWithDuration(0.3) {
            self.tutorialView.alpha = 0.0
        }
        
        UserDefaults.hasBeenLaunched = true
    }
    
    @IBOutlet weak var settingsButton: DesignableButton!
    
    @IBAction func touchSettings(sender: DesignableButton) {
        sender.userInteractionEnabled = false
        
        guard let mapVC = childViewControllers.first as? MapViewController else { return }
        
        if let settingsVC = mapVC.presentedViewController as? SettingsViewController {
            settingsVC.performUnwindToHomeOnButton(sender)
        } else {
            mapVC.performSegueToSettingsOnButton(sender)
        }
    }
}
