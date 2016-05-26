//
//  CategoryView.swift
//  echotags
//
//  Created by bkzl on 26/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import BEMCheckBox

class CategoryView: UIView {
    
    @IBOutlet private weak var checkbox: BEMCheckBox! {
        didSet {
            checkbox.onAnimationType = .Bounce
            checkbox.offAnimationType = .Bounce
        }
    }
    
    @IBOutlet weak var checkboxLabel: UIButton!
    
    @IBAction private func touchCheckboxLabel(sender: UIButton) {
        checkbox.setOn(!checkbox.on, animated: true)
        
    }
    
}
