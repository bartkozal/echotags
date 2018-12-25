//
//  MainViewController.swift
//  echotags
//
//  Created by bkzl on 17/05/16.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var tutorialView: UIView! {
        didSet {
            tutorialView.isHidden = UserDefaults.hasPassedTutorial
        }
    }
    
    @IBAction private func dismissTutorial() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tutorialView.alpha = 0.0
        }) 
        
        UserDefaults.hasPassedTutorial = true
    }
    
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBAction func touchSettingsButton(_ sender: UIButton) {
        guard let mapVC = childViewControllers.first as? MapViewController else { return }
        
        if let settingsVC = mapVC.presentedViewController as?
            SettingsViewController {
            settingsVC.performSegue(withIdentifier: "unwindToMap", sender: nil)
        } else {
            mapVC.performSegue(withIdentifier: "segueToSettings", sender: nil)
            sender.isSelected = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        switch geofencing.checkPermission() {
        case .authorized:
            break
        case .notDetermined:
            geofencing.manager.requestWhenInUseAuthorization()
        case .denied:
            present(Alert.accessToLocationBackgroundDenied(), animated: true, completion: nil)
        }
    }
}
