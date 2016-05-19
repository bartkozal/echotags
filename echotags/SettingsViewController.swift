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
    
    @IBOutlet weak var overlayView: DesignableView!
    @IBOutlet weak var settingsView: DesignableView!
    @IBOutlet private weak var checkbox: BEMCheckBox!
    
    @IBAction private func touchCheckboxLabel(sender: UIButton) {
        checkbox.setOn(!checkbox.on, animated: true)
    }
    
    @IBAction private func touchOverlayEffect(sender: UIButton) {
        if let wrapperViewController = presentingViewController?.parentViewController as? WrapperViewController {
            performUnwindToHomeOnButton(wrapperViewController.settingsButton)
        }
    }
    
    func performUnwindToHomeOnButton(sender: UIButton?) {
        overlayView.animation = "fadeOut"
        overlayView.animate()
        
        settingsView.y = view.frame.height
        
        if let settingsButton = sender as? DesignableButton {
            settingsView.animateTo()
            settingsButton.rotate = 90.0
            settingsButton.animateNext({
                settingsButton.userInteractionEnabled = true
                self.performSegueWithIdentifier("unwindToHome", sender: self)
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        overlayView.hidden = true
        settingsView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        
        overlayView.animation = "fadeIn"
        overlayView.animate()
        
        settingsView.y = view.frame.height
        settingsView.animate()
        
        overlayView.hidden = false
        settingsView.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkbox.onAnimationType = .Bounce
        checkbox.offAnimationType = .Bounce
    }
}
