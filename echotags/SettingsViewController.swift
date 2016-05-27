//
//  SettingsViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Spring

class SettingsViewController: UIViewController {
    
    @IBOutlet private weak var overlayView: DesignableView!
    @IBOutlet private weak var settingsView: DesignableView!
    @IBOutlet private weak var settingsScrollView: UIScrollView!
    @IBOutlet private weak var overlayButton: UIButton!
    
    @IBOutlet private weak var categoriesStackView: UIStackView! {
        didSet {
            for category in Category.all() {
                guard let categoryView = NSBundle.mainBundle().loadNibNamed("CategoryView", owner: self, options: nil)[0] as? CategoryView else { return }
                categoryView.checkboxLabel.setTitle(category.title, forState: .Normal)
                categoryView.checkbox.on = category.visible
                categoriesStackView.addArrangedSubview(categoryView)
            }
        }
    }
    
    @IBAction private func touchOverlayButton(sender: UIButton) {
        if let wrapperViewController = presentingViewController?.parentViewController as? WrapperViewController {
            performUnwindToHomeOnButton(wrapperViewController.settingsButton)
        }
    }
    
    func performUnwindToHomeOnButton(sender: UIButton?) {   
        overlayView.animation = "fadeOut"
        overlayView.animate()
        
        settingsView.y = view.frame.height
        
        if let settingsButton = sender as? DesignableButton {
            settingsView.animateTo()
            settingsButton.rotate = 90.0
            settingsButton.animateNext { [weak weakSelf = self] in
                settingsButton.userInteractionEnabled = true
                weakSelf?.performSegueWithIdentifier("unwindToHome", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsScrollView.contentInset.top = overlayButton.bounds.height
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let bottomBackground = UIView(frame: CGRectMake(0, settingsScrollView.contentSize.height, settingsScrollView.contentSize.width, 200))
        bottomBackground.backgroundColor = .whiteColor()
        settingsScrollView.addSubview(bottomBackground)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        overlayView.hidden = true
        settingsView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        
        overlayView.animation = "fadeIn"
        overlayView.animate()
        
        settingsView.y = view.frame.height
        settingsView.animate()
        
        overlayView.hidden = false
        settingsView.hidden = false
    }
}
