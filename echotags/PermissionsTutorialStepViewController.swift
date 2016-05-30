//
//  PermissionsTutorialStepViewController
//  echotags
//
//  Created by bkzl on 30/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Spring
import CoreLocation

class PermissionsTutorialStepViewController: TutorialStepViewController, CLLocationManagerDelegate {

    private var locationManager = CLLocationManager()
    
    @IBOutlet private weak var locationPermissionButton: DesignableButton! {
        didSet {
            determinePermissionButtonStyle(CLLocationManager.authorizationStatus())
        }
    }

    @IBAction private func touchLocationPermission(sender: DesignableButton) {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways:
            return
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
        case .Denied, .Restricted, .AuthorizedWhenInUse:
            Alert(viewController: self).accessToLocationBackgroundDenied()
        }
    }

    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        determinePermissionButtonStyle(status)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
    }
    
    private func determinePermissionButtonStyle(status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            locationPermissionButton.backgroundColor = UIColor(hex: "37435A")
            locationPermissionButton.setTitleColor(.whiteColor(), forState: .Normal)
            locationPermissionButton.setImage(UIImage(named: "icon-permissions-active"), forState: .Normal)
        }
    }
}
