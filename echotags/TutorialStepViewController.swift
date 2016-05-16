//
//  TutorialStepViewController.swift
//  echotags
//
//  Created by bkzl on 16/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

class TutorialStepViewController: UIViewController {
    
    @IBAction private func touchDismissTutorial(sender: UIButton) {
        let homeViewController = presentingViewController as? HomeViewController
        
        dismissViewControllerAnimated(false, completion: {
            homeViewController?.overlayView.hidden = false
        })
    }
    
    @IBAction private func touchFinishTutorial(sender: UIButton) {
        dismissViewControllerAnimated(false, completion: nil)
    }
}
