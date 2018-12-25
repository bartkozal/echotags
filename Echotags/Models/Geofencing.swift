//
//  Geofencing.swift
//  echotags
//
//  Created by bkzl on 30/05/16.
//

import UIKit
import CoreLocation
import RealmSwift

let geofencing = Geofencing()

class Geofencing {    
    var manager: CLLocationManager
    
    struct Defaults {
        static let coordinate = CLLocationCoordinate2D(latitude: 52.373846, longitude: 4.896244)
        static let zoomLevel = 14.0
        static let minimumAccuracy = 0.03
        static let styleURL = URL.init(string: "mapbox://styles/echotags/cioedlsaw002mbzmdkem7wkao")
    }
    
    struct Bounds {
        static let northEast = CLLocationCoordinate2D(latitude: 52.428573, longitude: 5.009148)
        static let southWest = CLLocationCoordinate2D(latitude: 52.280643, longitude: 4.724184)
        static let minimumZoomLevel = 12.0
        static let maximumZoomLevel = 16.5
    }
    
    enum Permission {
        case authorized
        case notDetermined
        case denied
    }
    
    init() {
        manager = CLLocationManager()
        manager.allowsBackgroundLocationUpdates = true
        manager.activityType = .fitness
        manager.distanceFilter = 10.0
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }
    
    func cityBoundsContains(_ location: CLLocationCoordinate2D) -> Bool {
        return location.latitude > Bounds.southWest.latitude &&
            location.latitude < Bounds.northEast.latitude &&
            location.longitude > Bounds.southWest.longitude &&
            location.longitude < Bounds.northEast.longitude
    }
    
    func checkPermission() -> Geofencing.Permission {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            return .authorized
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        }
    }
    
    func lookForNearby(pointAt location: CLLocationCoordinate2D) -> Point? {
        let nearestTrigger = Marker.nearby(location: location).flatMap { ($0 as! Point).triggers }.sorted { t1, t2 in
            let t1coordinate = CLLocationCoordinate2D(latitude: t1.latitude, longitude: t1.longitude)
            let t2coordinate = CLLocationCoordinate2D(latitude: t2.latitude, longitude: t2.longitude)
            return distanceBetween(location, target: t1coordinate) < distanceBetween(location, target: t2coordinate)
        }.first
        
        if let trigger = nearestTrigger {
            let triggerCoordinate = CLLocationCoordinate2D(latitude: trigger.latitude, longitude: trigger.longitude)
            if distanceBetween(location, target: triggerCoordinate) < Defaults.minimumAccuracy {
                return trigger.point.first
            }
        }
        
        return nil
    }
    
    private func distanceBetween(_ source: CLLocationCoordinate2D, target: CLLocationCoordinate2D) -> Double {
        let sourceLatRad = source.latitude * M_PI / 180
        let sourceLngRad = source.longitude * M_PI / 180
        let targetLatRad = target.latitude * M_PI / 180
        let targetLngRad = target.longitude * M_PI / 180
        
        let deltaLat = targetLatRad - sourceLatRad
        let deltaLng = targetLngRad - sourceLngRad

        let lat = sin(deltaLat/2) * sin(deltaLat/2)
        let lng = sin(deltaLng/2) * sin(deltaLng/2)
        let rad = cos(sourceLatRad) * cos(targetLatRad)
        
        let a = lat + lng * rad
        let c = 2 * asin(sqrt(a))
        let r = 6372.8
        
        return r * c
    }
}
