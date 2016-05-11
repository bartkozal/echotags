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
    @IBOutlet weak var checkbox2: BEMCheckBox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkbox.onAnimationType = .Bounce
        checkbox.offAnimationType = .Bounce
        
        checkbox2.onAnimationType = .Bounce
        checkbox2.offAnimationType = .Bounce
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
