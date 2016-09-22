//
//  CategoryView.swift
//  echotags
//
//  Created by bkzl on 26/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol CategoryViewDelegate {
    func didTapCategory(_ checkbox: BEMCheckBox, name: String?)
}

class CategoryView: UIView {
    var delegate: CategoryViewDelegate?
    
    @IBOutlet weak var checkbox: BEMCheckBox! {
        didSet {
            checkbox.onAnimationType = .bounce
            checkbox.offAnimationType = .bounce
            checkbox.delegate = self
        }
    }
    
    @IBOutlet weak var checkboxLabel: UIButton!
    
    @IBAction private func touchCheckboxLabel(_ sender: UIButton) {
        checkbox.setOn(!checkbox.on, animated: true)
        delegate?.didTapCategory(checkbox, name: checkboxLabel.currentTitle)
    }
}

extension CategoryView: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        delegate?.didTapCategory(checkbox, name: checkboxLabel.currentTitle)
    }
}
