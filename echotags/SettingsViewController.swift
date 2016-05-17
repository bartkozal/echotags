//
//  SettingsViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import BEMCheckBox
import Spring

class SettingsViewController: UIViewController {
    
    @IBOutlet private weak var overlayView: DesignableView!
    @IBOutlet private weak var settingsView: DesignableView!
    @IBOutlet private weak var settingsButton: DesignableButton!
    @IBOutlet private weak var checkbox: BEMCheckBox!
    
    @IBAction private func touchCheckboxLabel(sender: UIButton) {
        checkbox.setOn(!checkbox.on, animated: true)
    }
    
    @IBAction private func touchOverlayEffect(sender: UIButton) {
        slideDownSettingsView()
        
        overlayView.curve = "easeOut"
        overlayView.duration = 0.3
        overlayView.delay = 0.2
        overlayView.opacity = 0
        overlayView.animateToNext({
            self.performSegueWithIdentifier("unwindToHome", sender: self)
        })
    }
    
    @IBAction private func touchSettings(sender: DesignableButton) {
        slideDownSettingsView()
        
        settingsButton.curve = "easeOut"
        settingsButton.duration = 0.3
        settingsButton.damping = 1
        settingsButton.rotate = -90.0
        settingsButton.animateTo()
        
        overlayView.curve = "easeOut"
        overlayView.duration = 0.3
        overlayView.delay = 0.2
        overlayView.opacity = 0
        overlayView.animateToNext({
            self.performSegueWithIdentifier("unwindToHome", sender: self)
        })
    }
    
    private func slideDownSettingsView() {
        settingsView.curve = "easeOut"
        settingsView.duration = 0.3
        settingsView.damping = 1
        settingsView.y = settingsView.frame.height
        settingsView.animateTo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkbox.onAnimationType = .Bounce
        checkbox.offAnimationType = .Bounce
    }
    
}
