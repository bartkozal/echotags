//
//  Location.swift
//  echotags
//
//  Created by bkzl on 30/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import CoreLocation

class Location {
    var manager: CLLocationManager
    
    init() {
        manager = CLLocationManager()
    }
    
    func checkPermission(inViewControler: UIViewController) {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways:
            return
        case .NotDetermined:
            manager.requestAlwaysAuthorization()
        case .Denied, .Restricted, .AuthorizedWhenInUse:
            Alert(viewController: inViewControler).accessToLocationBackgroundDenied()
        }
    }
}