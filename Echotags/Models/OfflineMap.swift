//
//  OfflineMap.swift
//  Echotags
//
//  Created by bkzl on 16/06/16.
//  Copyright © 2016 Bartłomiej Kozal. All rights reserved.
//

import Mapbox

class OfflineMap: NSObject {
    var isAvailable = UserDefaults.hasOfflineMap
    
    override init() {
        super.init()
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(
            self,
            selector: #selector(offlinePackProgressDidChange),
            name: MGLOfflinePackProgressChangedNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(offlinePackDidReceiveError),
            name: MGLOfflinePackErrorNotification,
            object: nil
        )
    }
    
    func startDownloading() {
        let region = MGLTilePyramidOfflineRegion(
            styleURL: Geofencing.Defaults.styleURL,
            bounds: MGLCoordinateBoundsMake(Geofencing.Bounds.southWest, Geofencing.Bounds.northEast),
            fromZoomLevel: Geofencing.Bounds.minimumZoomLevel,
            toZoomLevel: Geofencing.Bounds.maximumZoomLevel
        )
        
        let context = NSKeyedArchiver.archivedDataWithRootObject(["name": "Amsterdam"])
        
        MGLOfflineStorage.sharedOfflineStorage().addPackForRegion(region, withContext: context) { (pack, error) in
            guard error == nil else {
                print("Error: \(error?.localizedFailureReason)")
                return
            }
            
            pack!.resume()
        }
    }
    
    func offlinePackProgressDidChange(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack {
            let offlinePack = OfflinePack(pack: pack)
            
            if offlinePack.isReady {
                UserDefaults.hasOfflineMap = true
            }
        }
    }
    
    func offlinePackDidReceiveError(notification: NSNotification) {
        if let error = notification.userInfo?[MGLOfflinePackErrorUserInfoKey] as? NSError {
            print("Offline pack received error: \(error.localizedFailureReason)")
        }
    }
}
