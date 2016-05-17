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
    @IBOutlet private weak var checkbox: BEMCheckBox!
    
    @IBAction private func touchCheckboxLabel(sender: UIButton) {
        checkbox.setOn(!checkbox.on, animated: true)
    }
    
    @IBAction private func touchOverlayEffect(sender: UIButton) {
        performSegueWithIdentifier("unwindToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkbox.onAnimationType = .Bounce
        checkbox.offAnimationType = .Bounce
    }
    
}
