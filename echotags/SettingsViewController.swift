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
    
    @IBOutlet private weak var overlayEffectView: UIVisualEffectView!
    @IBOutlet private weak var settingsView: UIView!
    @IBOutlet private weak var settingsButton: DesignableButton!
    @IBOutlet private weak var checkbox: BEMCheckBox!
    
    @IBAction private func touchCheckboxLabel(sender: UIButton) {
        checkbox.setOn(!checkbox.on, animated: true)
    }
    
    @IBAction private func touchOverlayEffect(sender: UIButton) {
        performSegueWithIdentifier("unwindToHome", sender: self)
    }
    
    @IBAction private func touchSettings(sender: DesignableButton) {
        performSegueWithIdentifier("unwindToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        settingsButton.rotate = 90.0
//        settingsButton.animate()
//        settingsButton.animateNext({
            self.settingsView.hidden = false
            self.overlayEffectView.hidden = false
//        })

        
        checkbox.onAnimationType = .Bounce
        checkbox.offAnimationType = .Bounce
    }

}
