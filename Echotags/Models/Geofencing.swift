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
    var isEnabled: Bool {
        return CLLocationManager.authorizationStatus() == .AuthorizedAlways
    }
    
    struct Defaults {
        static let coordinate = CLLocationCoordinate2D(latitude: 52.373846, longitude: 4.896244)
        static let zoomLevel = 14.0
        static let pointRadius = CLLocationDistance(30.0)
        static let styleURL = NSURL.init(string: "mapbox://styles/echotags/cioedlsaw002mbzmdkem7wkao")
    }
    
    struct Bounds {
        static let northEast = CLLocationCoordinate2D(latitude: 52.428573, longitude: 5.009148)
        static let southWest = CLLocationCoordinate2D(latitude: 52.280643, longitude: 4.724184)
        static let minimumZoomLevel = 12.0
        static let maximumZoomLevel = 16.5
    }
    
    init() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func cityBoundsContains(location: CLLocationCoordinate2D) -> Bool {
        return location.latitude > Bounds.southWest.latitude &&
            location.latitude < Bounds.northEast.latitude &&
            location.longitude > Bounds.southWest.longitude &&
            location.longitude < Bounds.northEast.longitude
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
    
    func monitorNearestPointsFor(source: CLLocationCoordinate2D) {
        // Return 20 nearest triggers for current user location
        let nearestTriggers = Marker.visible().flatMap { ($0 as! Point).triggers }.sort { t1, t2 in
            let t1coordinate = CLLocationCoordinate2D(latitude: t1.latitude, longitude: t1.longitude)
            let t2coordinate = CLLocationCoordinate2D(latitude: t2.latitude, longitude: t2.longitude)
            return distanceBetween(source, target: t1coordinate) < distanceBetween(source, target: t2coordinate)
            }[0...20]
        
        // Empty monitored regions array
        for region in manager.monitoredRegions {
            manager.stopMonitoringForRegion(region)
        }
        
        // Start monitoring nearest trigger
        for trigger in nearestTriggers {
            let coordinate = CLLocationCoordinate2D(latitude: trigger.latitude, longitude: trigger.longitude)
            let region = circularRegionFrom(coordinate, withIdentifier: trigger.id)
            manager.startMonitoringForRegion(region)
        }
    }
    
    private func circularRegionFrom(coordinate: CLLocationCoordinate2D, withIdentifier identifier: String) -> CLCircularRegion {
        return CLCircularRegion(center: coordinate, radius: Defaults.pointRadius, identifier: identifier)
    }
    
    private func distanceBetween(source: CLLocationCoordinate2D, target: CLLocationCoordinate2D) -> Double {
        let sourceLatRad = source.latitude * M_PI / 180
        let sourceLngRad = source.longitude * M_PI / 180
        let targetLatRad = target.latitude * M_PI / 180
        let targetLngRad = target.longitude * M_PI / 180
        
        let deltaLat = targetLatRad - sourceLatRad
        let deltaLng = targetLngRad - sourceLngRad
        
        let a = sin(deltaLat/2) * sin(deltaLat/2) + sin(deltaLng/2) * sin(deltaLng/2) * cos(sourceLatRad) * cos(targetLatRad)
        let c = 2 * asin(sqrt(a))
        let r = 6372.8
        
        return r * c
    }
}
