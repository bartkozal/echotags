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
import StoreKit

class SettingsViewController: UIViewController {
    let removeAdsIdentifier = "bkzl.echotags.amsterdam.iap.noads"
    var categoriesHaveChanged = false
    var transactionInProgress = false {
        didSet {
            if transactionInProgress {
                removeAdsStackView.isUserInteractionEnabled = false
                transactionIndicator.startAnimating()
            } else {
                removeAdsStackView.isUserInteractionEnabled = true
                transactionIndicator.stopAnimating()
            }
        }
    }

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

    @IBOutlet fileprivate weak var removeAdsStackView: UIStackView! {
        didSet {
            if !UserDefaults.hasRemovedAds && SKPaymentQueue.canMakePayments() {
                SKPaymentQueue.default().add(self)
            } else {
                removeAdsStackView.isHidden = true
            }
        }
    }

    @IBOutlet fileprivate weak var transactionIndicator: UIActivityIndicatorView! {
        didSet {
            transactionIndicator.stopAnimating()
        }
    }

    @IBOutlet fileprivate weak var removeAdsButton: UIButton! {
        didSet {
            if UserDefaults.hasRemovedAds {
                removeAdsButton.isEnabled = false
            }
        }
    }

    @IBAction private func touchRemoveAdsButton() {
        transactionInProgress = true

        let productRequest = SKProductsRequest(productIdentifiers: Set([removeAdsIdentifier]))
        productRequest.delegate = self
        productRequest.start()
    }

    @IBAction private func touchRestorePurchasesButton() {
        transactionInProgress = true
        
        SKPaymentQueue.default().restoreCompletedTransactions()
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

        SKPaymentQueue.default().remove(self)
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

            mapVC.adView.isHidden = UserDefaults.hasRemovedAds
            
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

extension SettingsViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
}

extension SettingsViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        transactionInProgress = false
        let alert = Alert.alertDialog("Something went wrong", message: error.localizedDescription)
        present(alert, animated: true, completion: nil)
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transcation in transactions {
            switch transcation.transactionState {
            case .purchased:
                UserDefaults.hasRemovedAds = true
                removeAdsButton.isEnabled = false
                transactionIndicator.stopAnimating()
                SKPaymentQueue.default().finishTransaction(transcation)
            case .restored:
                if transcation.original?.payment.productIdentifier == removeAdsIdentifier {
                    UserDefaults.hasRemovedAds = true
                    removeAdsButton.isEnabled = false
                    transactionIndicator.stopAnimating()
                } else {
                    transactionInProgress = false
                }
                SKPaymentQueue.default().finishTransaction(transcation)
            case .failed:
                transactionInProgress = false
                SKPaymentQueue.default().finishTransaction(transcation)
            default:
                break
            }
        }
    }
}
