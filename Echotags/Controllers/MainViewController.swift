//
//  MainViewController.swift
//  echotags
//
//  Created by bkzl on 17/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var tutorialView: UIView! {
        didSet {
            tutorialView.hidden = UserDefaults.hasPassedTutorial
        }
    }
    
    @IBAction private func dismissTutorial() {
        UIView.animateWithDuration(0.3) {
            self.tutorialView.alpha = 0.0
        }
        
        UserDefaults.hasPassedTutorial = true
    }
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBAction func touchSettingsButton(sender: UIButton) {
        guard let mapVC = childViewControllers.first as? MapViewController else { return }
        
        if let settingsVC = mapVC.presentedViewController as?
            SettingsViewController {
            settingsVC.performSegueWithIdentifier("unwindToMap", sender: nil)
        } else {
            mapVC.performSegueWithIdentifier("segueToSettings", sender: nil)
            sender.selected = true
        }
    }
}
