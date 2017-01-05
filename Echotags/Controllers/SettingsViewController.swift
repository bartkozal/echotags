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
                guard let categoryView = Bundle.main.loadNibNamed("CategoryView", owner: self, options: nil)?[0] as? CategoryView else { return }
                categoryView.checkboxLabel.setTitle(category.name, for: .normal)
                categoryView.checkbox.on = category.visible
                categoryView.delegate = self
                categoriesStackView.addArrangedSubview(categoryView)
            }
        }
    }
    
    @IBAction private func touchOverlayButton() {
        performSegue(withIdentifier: "unwindToMap", sender: nil)
    }
    
    @IBOutlet private weak var downloadMapButton: UIButton! {
        didSet {
            downloadMapButton.isEnabled = !UserDefaults.hasOfflineMap
        }
    }
    
    @IBAction private func touchDownloadMapButton() {
        offlineMap.startDownloading()
    }
    
    @IBOutlet weak var resetVisitedButton: UIButton! {
        didSet {
            resetVisitedButton.isHidden = Point.unvisited().count == 0
        }
    }
    
    @IBAction private func touchResetVisitedButton(_ sender: UIButton) {
        present(Alert.resetVisitedPoints(self), animated: true, completion: nil)
    }

    @IBAction private func touchTweetButton() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc?.setInitialText("Amsterdam offline audio guide. Perfect for short term visitors and solo travelers. http://echotags.io/appstore")
            present(vc!, animated: true, completion: nil)
        } else {
            present(Alert.twitterUnavailable(), animated: true, completion: nil)
        }
    }
    
    @IBAction private func touchShareButton() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc?.setInitialText("Amsterdam offline audio guide. Perfect for short term visitors and solo travelers. http://echotags.io/appstore")
            present(vc!, animated: true, completion: nil)
        } else {
            present(Alert.facebookUnavailable(), animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(offlinePackProgressDidChange),
            name: NSNotification.Name.MGLOfflinePackProgressChanged,
            object: nil
        )
        
        settingsScrollView.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let bottomBackground = UIView(frame: CGRect(x: 0, y: settingsScrollView.contentSize.height, width: settingsScrollView.contentSize.width, height: 450))
        bottomBackground.backgroundColor = .white
        settingsScrollView.addSubview(bottomBackground)
        settingsScrollView.contentInset.top = overlayButton.bounds.height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToMap" {
            let mapVC = segue.destination as! MapViewController
            if categoriesHaveChanged {
                mapVC.reloadPointAnnotations()
                categoriesHaveChanged = false
            }

            let mainVC = mapVC.parent as! MainViewController
            mainVC.settingsButton.isSelected = false
        }
    }

    func offlinePackProgressDidChange(_ notification: Notification) {
        if let pack = notification.object as? MGLOfflinePack {
            let offlinePack = OfflinePack(pack: pack)
            
            switch pack.state {
            case .active:
                downloadMapButton.isEnabled = false
                downloadMapButton.setTitle("Downloading... \(offlinePack.progressPercentage)%", for: .disabled)
            case .inactive:
                downloadMapButton.isEnabled = true
                downloadMapButton.setTitle("Resume download", for: UIControlState())
            case .complete:
                downloadMapButton.isEnabled = false
                downloadMapButton.setTitle("Offline map is ready", for: .disabled)
            default:
                break
            }
        }
    }
}

extension SettingsViewController: CategoryViewDelegate {
    func didTapCategory(_ checkbox: BEMCheckBox, name: String?) {
        if let checkboxLabel = name, let category = Category.findBy(name: checkboxLabel) {
            category.updateVisibility(to: checkbox.on)
        }
        categoriesHaveChanged = true
    }
}

extension SettingsViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let breakScrollPoint = CGFloat(-130.0)
        if scrollView.contentOffset.y < breakScrollPoint {
            performSegue(withIdentifier: "unwindToMap", sender: nil)
        }
    }
}
