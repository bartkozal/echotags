//
//  HomeViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var overlayView: UIView!
    
    @IBAction internal func unwindToHomeViewController (sender: UIStoryboardSegue) {}
    
    @IBAction func toggleOverlayView(sender: UIButton) {
        overlayView.hidden = !overlayView.hidden
    }
    
    @IBAction private func touchTestTutorial(sender: UIButton) {
        performSegueWithIdentifier("segueToTutorial", sender: self)
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
