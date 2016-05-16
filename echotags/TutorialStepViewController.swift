//
//  TutorialStepViewController.swift
//  echotags
//
//  Created by bkzl on 16/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

class TutorialStepViewController: UIViewController {

    @IBAction private func touchSkipTutorial(sender: UIButton) {
        dismissViewControllerAnimated(false, completion: nil)
    }

}
