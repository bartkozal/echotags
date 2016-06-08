//
//  SettingsViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Spring
import BEMCheckBox
import CoreLocation

class SettingsViewController: UIViewController {
    var categoriesHaveChanged = false
    var geofencing = Geofencing()
    
    private var mainCVC: MainContainerViewController {
        return presentingViewController?.parentViewController as! MainContainerViewController
    }
    
    private var mapVC: MapViewController {
        return presentingViewController as! MapViewController
    }
    
    @IBOutlet private weak var overlayView: DesignableView!
    @IBOutlet private weak var settingsView: DesignableView!
    @IBOutlet private weak var settingsScrollView: UIScrollView!
    @IBOutlet private weak var overlayButton: UIButton!
    @IBOutlet private weak var categoriesStackView: UIStackView! {
        didSet {
            for category in Category.all() {
                guard let categoryView = NSBundle.mainBundle().loadNibNamed("CategoryView", owner: self, options: nil)[0] as? CategoryView else { return }
                categoryView.checkboxLabel.setTitle(category.name, forState: .Normal)
                categoryView.checkbox.on = category.visible
                categoryView.delegate = self
                categoriesStackView.addArrangedSubview(categoryView)
            }
        }
    }
    
    @IBOutlet weak var locationPermissionButton: DesignableButton! {
        didSet {
            if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
                locationPermissionButton.hidden = true
            }
        }
    }
    
    @IBAction func touchLocationPermission(sender: DesignableButton) {
        geofencing.checkPermission(self)
    }
    
    @IBAction private func touchOverlayButton(sender: UIButton) {
        touchSettingsButton()
    }
    
    func performUnwindToHomeOnButton(sender: UIButton?) {
        if categoriesHaveChanged {
            mapVC.reloadPointAnnotations()
            categoriesHaveChanged = false
        }
        
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
    
    private func touchSettingsButton() {
        performUnwindToHomeOnButton(mainCVC.settingsButton)
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

extension SettingsViewController: CategoryViewDelegate {
    func didTapCategory(checkbox: BEMCheckBox, name: String?) {
        if let checkboxLabel = name, category = Category.findByName(checkboxLabel) {
            category.updateVisibility(checkbox.on)
        }
        categoriesHaveChanged = true
    }
}

extension SettingsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let breakScrollPoint = CGFloat(-130.0)
        if scrollView.contentOffset.y < breakScrollPoint {
            touchSettingsButton()
        }
    }
}
