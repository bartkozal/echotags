//
//  HomeViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Spring

class HomeViewController: UIViewController {
    
    @IBOutlet weak var overlayView: DesignableView!
    
    @IBAction internal func unwindToHomeViewController(sender: UIStoryboardSegue) {}
    
    @IBAction func toggleOverlayView(sender: UIButton) {
        overlayView.animation = "fadeOut"
        overlayView.animateNext({
            self.overlayView.hidden = true
        })
    }
    
    @IBAction private func touchTestTutorial(sender: UIButton) {
        performSegueWithIdentifier("segueToTutorial", sender: sender)
    }
    
    func performSegueToSettingsOnButton(sender: UIButton?) {
        if let settingsButton = sender as? DesignableButton {
            settingsButton.rotate = -90.0
            settingsButton.animate()
        }
        performSegueWithIdentifier("segueToSettings", sender: sender)
    }
    
    override func viewWillLayoutSubviews() {
        createMaskLayer()
    }
    
    private func createMaskLayer() {
        let xOffset = CGFloat(overlayView.frame.width - 26)
        let yOffset = CGFloat(overlayView.frame.height - 26)
        
        MaskLayer(bindToView: overlayView, radius: 42.0, xOffset: xOffset, yOffset: yOffset).circle()
    }
}
