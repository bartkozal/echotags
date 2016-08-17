//
//  SettingsViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import BEMCheckBox
import CoreLocation
import Mapbox
import Social

class SettingsViewController: UIViewController {
    var categoriesHaveChanged = false
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet private weak var settingsView: UIView!
    @IBOutlet weak var settingsScrollView: UIScrollView!
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
    
    
    @IBAction private func touchOverlayButton() {
        performSegueWithIdentifier("unwindToMap", sender: nil)
    }
    
    @IBOutlet private weak var downloadMapButton: UIButton! {
        didSet {
            downloadMapButton.enabled = !UserDefaults.hasOfflineMap
        }
    }
    
    @IBAction private func touchDownloadMapButton() {
        offlineMap.startDownloading()
    }
    
    @IBOutlet weak var resetVisitedButton: UIButton! {
        didSet {
            resetVisitedButton.hidden = Point.unvisited().count == 0
        }
    }
    
    @IBAction private func touchResetVisitedButton(sender: UIButton) {
        presentViewController(Alert.resetVisitedPoints(self), animated: true, completion: nil)
    }
    
    @IBAction private func touchTweetButton() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc.setInitialText("Enjoy Amsterdam! Offline audio guide for short term visitors and solo travelers. http://echotags.io/appstore via @echotags")
            presentViewController(vc, animated: true, completion: nil)
        } else {
            presentViewController(Alert.twitterUnavailable(), animated: true, completion: nil)
        }
    }
    
    @IBAction private func touchShareButton() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc.setInitialText("Enjoy Amsterdam! Offline audio guide for short term visitors and solo travelers. http://echotags.io/appstore")
            presentViewController(vc, animated: true, completion: nil)
        } else {
            presentViewController(Alert.facebookUnavailable(), animated: true, completion: nil)
        }
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
        
        let bottomBackground = UIView(frame: CGRectMake(0, settingsScrollView.contentSize.height, settingsScrollView.contentSize.width, 450))
        bottomBackground.backgroundColor = .whiteColor()
        settingsScrollView.addSubview(bottomBackground)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindToMap" {
            let mapVC = segue.destinationViewController as! MapViewController
            if categoriesHaveChanged {
                mapVC.reloadPointAnnotations()
                categoriesHaveChanged = false
            }
            
            let mainVC = mapVC.parentViewController as! MainViewController
            mainVC.settingsButton.selected = false
        }
    }

    func offlinePackProgressDidChange(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack {
            let offlinePack = OfflinePack(pack: pack)
            
            switch pack.state {
            case .Active:
                downloadMapButton.enabled = false
                downloadMapButton.setTitle("Downloading... \(offlinePack.progressPercentage)%", forState: .Disabled)
            case .Inactive:
                downloadMapButton.enabled = true
                downloadMapButton.setTitle("Resume download", forState: .Normal)
            case .Complete:
                downloadMapButton.enabled = false
                downloadMapButton.setTitle("Offline map is ready", forState: .Disabled)
            default:
                break
            }
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
            performSegueWithIdentifier("unwindToMap", sender: nil)
        }
    }
}
