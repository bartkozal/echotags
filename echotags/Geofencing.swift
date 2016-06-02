//
//  Geofencing.swift
//  echotags
//
//  Created by bkzl on 30/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import CoreLocation

class Geofencing {
    var manager: CLLocationManager

    struct Defaults {
        static let coordinate = CLLocationCoordinate2D(latitude: 52.371413, longitude: 4.897451)
        static let zoomLevel = 13.5
        static let pointRadius = CLLocationDistance(30.0)
    }
    
    struct CityBounds {
        static let northEast = CLLocationCoordinate2D(latitude: 52.42857381779567, longitude: 5.009148437500016)
        static let southWest = CLLocationCoordinate2D(latitude: 52.28064348619208, longitude: 4.724184204101562)
    }

    init() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.startUpdatingLocation()
    }
    
    func cityBoundsContains(location: CLLocationCoordinate2D) -> Bool {
        return location.latitude > CityBounds.southWest.latitude && location.latitude < CityBounds.northEast.latitude && location.longitude > CityBounds.southWest.longitude && location.longitude < CityBounds.northEast.longitude
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
    
    func monitorNearestPoints() {
        // TODO: missing neareast point localization
        
        if let point = Point.findByTitle("Upstream Gallery") {
            let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            let region = circularRegionFrom(coordinate, withAudio: point.audio)
            manager.startMonitoringForRegion(region)
        }
    }
    
    private func circularRegionFrom(coordinate: CLLocationCoordinate2D, withAudio audio: String) -> CLCircularRegion {
        return CLCircularRegion(center: coordinate, radius: Defaults.pointRadius, identifier: audio)
    }
}
