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
import Mapbox
import Social

class SettingsViewController: UIViewController {
    var categoriesHaveChanged = false
    
    private let geofencing = Geofencing()
    private let offlineMap = OfflineMap()
    
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
    
    @IBOutlet private weak var locationPermissionButton: DesignableButton! {
        didSet {
            if geofencing.isEnabled {
                locationPermissionButton.hidden = true
            }
        }
    }
    
    @IBOutlet private weak var downloadMapButton: DesignableButton! {
        didSet {
            if offlineMap.isAvailable {
                downloadMapButton.hidden = true
            }
        }
    }
    
    @IBAction private func touchTweetButton(sender: DesignableButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc.setInitialText("Enjoy Amsterdam! Offline audio guide for short term visitors and solo travelers. http://echotags.io via @echotags")
            self.presentViewController(vc, animated: true, completion: nil)
        } else {
            Alert(vc: self).twitterUnavailable()
        }
    }
    
    @IBAction private func touchShareButton(sender: DesignableButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc.setInitialText("Enjoy Amsterdam! Offline audio guide for short term visitors and solo travelers. http://echotags.io via https://www.facebook.com/echotagsapp/")
            self.presentViewController(vc, animated: true, completion: nil)
        } else {
            Alert(vc: self).facebookUnavailable()
        }
    }
    
    @IBAction private func touchDownloadButton(sender: DesignableButton) {
        sender.userInteractionEnabled = false
        offlineMap.startDownloading()
    }
    
    @IBAction private func touchLocationPermissionButton(sender: DesignableButton) {
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
            settingsButton.animateNext { [unowned self] in
                settingsButton.userInteractionEnabled = true
                self.performSegueWithIdentifier("unwindToMap", sender: self)
            }
        }
    }
    
    private func touchSettingsButton() {
        performUnwindToHomeOnButton(mainCVC.settingsButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(offlinePackProgressDidChange),
            name: MGLOfflinePackProgressChangedNotification,
            object: nil
        )
        
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
    
    func offlinePackProgressDidChange(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack {
            let offlinePack = OfflinePack(pack: pack)
            
            switch pack.state {
            case .Active:
                downloadMapButton.setTitle("Downloading... \(offlinePack.progressPercentage)%", forState: .Normal)
            case .Inactive:
                downloadMapButton.setTitle("Resume download", forState: .Normal)
            case .Complete:
                determineDownloadButtonStyle(offlinePack.isReady)
            default:
                break
            }
        }
    }
    
    private func determineDownloadButtonStyle(status: Bool) {
        if status {
            downloadMapButton.backgroundColor = UIColor(hex: "37435A")
            downloadMapButton.setTitleColor(.whiteColor(), forState: .Normal)
            downloadMapButton.setImage(UIImage(named: "icon-download-active"), forState: .Normal)
            downloadMapButton.setTitle("Offline map enabled", forState: .Normal)
            downloadMapButton.userInteractionEnabled = false
        }
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
