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
        performUnwindToHomeOnSettingsButton()
    }
    
    func performUnwindToHomeOnButton(sender: UIButton?) {   
        overlayView.animation = "fadeOut"
        overlayView.animate()
        
        settingsView.curve = "linear"
        settingsView.damping = CGFloat(1.0)
        
        if settingsScrollView.contentOffset.y > 0 {
            settingsView.y = settingsScrollView.bounds.maxY
        } else {
            settingsView.y = view.frame.height
        }
        
        if let settingsButton = sender as? DesignableButton {
            settingsView.animateTo()
            settingsButton.rotate = 90.0
            settingsButton.animateNext { [weak weakSelf = self] in
                settingsButton.userInteractionEnabled = true
                weakSelf?.performSegueWithIdentifier("unwindToMap", sender: self)
            }
        }
    }
    
    private func performUnwindToHomeOnSettingsButton() {
        if let mainCVC = presentingViewController?.parentViewController as? MainContainerViewController {
            performUnwindToHomeOnButton(mainCVC.settingsButton)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingsScrollView.delegate = self
        settingsScrollView.contentInset.top = overlayButton.bounds.height
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let bottomBackground = UIView(frame: CGRectMake(0, settingsScrollView.contentSize.height, settingsScrollView.contentSize.width, 200))
        bottomBackground.backgroundColor = .whiteColor()
        settingsScrollView.addSubview(bottomBackground)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        overlayView.hidden = true
        settingsView.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        overlayView.animation = "fadeIn"
        overlayView.animate()
        
        settingsView.curve = "linear"
        settingsView.damping = CGFloat(1.0)
        settingsView.y = view.frame.height
        settingsView.animate()
        
        overlayView.hidden = false
        settingsView.hidden = false
    }
}

extension SettingsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let breakScrollPoint = CGFloat(-130.0)
        if scrollView.contentOffset.y < breakScrollPoint {
            performUnwindToHomeOnSettingsButton()
        }
    }
}
