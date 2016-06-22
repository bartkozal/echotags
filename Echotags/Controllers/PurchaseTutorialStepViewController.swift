//
//  PurchaseTutorialStepViewController.swift
//  echotags
//
//  Created by bkzl on 30/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Spring

class PurchaseTutorialStepViewController: TutorialStepViewController {
    
    @IBOutlet weak var settingsLabel: DesignableLabel! {
        didSet {
            GlyphLabel(label: settingsLabel).replace("@", withImage: "glyph-settings")
        }
    }

}
