//
//  TutorialStepViewController.swift
//  echotags
//
//  Created by bkzl on 16/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

class TutorialStepViewController: UIViewController {
    
    @IBAction private func touchFinishTutorial(sender: UIButton) {
        parentViewController?.performSegueWithIdentifier("segueToMainContainer", sender: sender)
    }
    
    @IBAction private func touchNextStep(sender: UIButton) {
        guard let tutorialPVC = parentViewController as? TutorialPageViewController else { return }
        guard let currentStepVC = tutorialPVC.viewControllers?.first else { return }
        
        if let nextStepVC = tutorialPVC.pageViewController(tutorialPVC, viewControllerAfterViewController: currentStepVC) {
            tutorialPVC.setViewControllers([nextStepVC], direction: .Forward, animated: true, completion: nil)
        }
    }
}
