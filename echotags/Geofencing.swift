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
    
    func monitorNearestPointsTo(source: CLLocationCoordinate2D) {
        
        // Returns 20 nearest points to user location. 20 is max limit of monitored regions for iOS9
        let nearestPoints = Marker.visible().sort { p1, p2 in
            distanceBetween(source, target: CLLocationCoordinate2D(latitude: (p1 as! Point).latitude, longitude: (p1 as! Point).longitude)) < distanceBetween(source, target: CLLocationCoordinate2D(latitude: (p2 as! Point).latitude, longitude: (p2 as! Point).longitude))
        }[0...20]

        for point in nearestPoints {
            let point = point as! Point
            let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            let region = circularRegionFrom(coordinate, withAudio: point.audio)
            manager.startMonitoringForRegion(region)
        }
    }
    
    private func circularRegionFrom(coordinate: CLLocationCoordinate2D, withAudio audio: String) -> CLCircularRegion {
        return CLCircularRegion(center: coordinate, radius: Defaults.pointRadius, identifier: audio)
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
