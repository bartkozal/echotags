//
//  CategoryView.swift
//  echotags
//
//  Created by bkzl on 26/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import BEMCheckBox

class CategoryView: UIView, BEMCheckBoxDelegate {
    
    @IBOutlet weak var checkbox: BEMCheckBox! {
        didSet {
            checkbox.onAnimationType = .Bounce
            checkbox.offAnimationType = .Bounce
            checkbox.delegate = self
        }
    }
    
    @IBOutlet weak var checkboxLabel: UIButton!
    
    @IBAction private func touchCheckboxLabel(sender: UIButton) {
        checkbox.setOn(!checkbox.on, animated: true)
        updateValue()
    }
    
    func didTapCheckBox(checkBox: BEMCheckBox) {
        updateValue()
    }
    
    private func updateValue() {
        if let category = Category.findByTitle(checkboxLabel.currentTitle!) {
            category.updateVisibility(checkbox.on)
        }
    }
}
