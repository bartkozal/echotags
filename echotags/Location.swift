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

    struct Defaults {
        let coordinate = CLLocationCoordinate2D(latitude: 52.371413, longitude: 4.897451)
        let zoomLevel = 13.5
    }
    
    struct Bounds {
        let northEast = CLLocationCoordinate2D(latitude: 52.42857381779567, longitude: 5.009148437500016)
        let southWest = CLLocationCoordinate2D(latitude: 52.28064348619208, longitude: 4.724184204101562)
    }

    init() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.startUpdatingLocation()
    }
    
    func cityBoundsContains(location: CLLocationCoordinate2D) -> Bool {
        let cityBounds = Bounds()
        return location.latitude > cityBounds.southWest.latitude && location.latitude < cityBounds.northEast.latitude && location.longitude > cityBounds.southWest.longitude && location.longitude < cityBounds.northEast.longitude
    }
    
    func checkPermission(inVC: UIViewController) {
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways:
            return
        case .NotDetermined:
            manager.requestAlwaysAuthorization()
        case .Denied, .Restricted, .AuthorizedWhenInUse:
            Alert(vc: inVC).accessToLocationBackgroundDenied()
        }
    }
}