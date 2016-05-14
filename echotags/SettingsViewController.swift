//
//  SettingsViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import BEMCheckBox

class SettingsViewController: UIViewController {
    @IBOutlet weak var checkbox: BEMCheckBox!
    
    @IBAction func touchCheckboxLabel(sender: UIButton) {
        checkbox.setOn(!checkbox.on, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkbox.onAnimationType = .Bounce
        checkbox.offAnimationType = .Bounce
    }
}
