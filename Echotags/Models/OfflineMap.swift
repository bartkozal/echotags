//
//  OfflineMap.swift
//  Echotags
//
//  Created by bkzl on 16/06/16.
//  Copyright © 2016 Bartłomiej Kozal. All rights reserved.
//

import Mapbox

let offlineMap = OfflineMap()

class OfflineMap: NSObject {
    override init() {
        super.init()
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(offlinePackProgressDidChange),
            name: NSNotification.Name.MGLOfflinePackProgressChanged,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(offlinePackDidReceiveError),
            name: NSNotification.Name.MGLOfflinePackError,
            object: nil
        )
    }
    
    func startDownloading() {
        let region = MGLTilePyramidOfflineRegion(
            styleURL: Geofencing.Defaults.styleURL as URL?,
            bounds: MGLCoordinateBoundsMake(Geofencing.Bounds.southWest, Geofencing.Bounds.northEast),
            fromZoomLevel: Geofencing.Bounds.minimumZoomLevel,
            toZoomLevel: Geofencing.Bounds.maximumZoomLevel
        )
        
        let context = NSKeyedArchiver.archivedData(withRootObject: ["name": "Amsterdam"])
        
        MGLOfflineStorage.shared().addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                print("Error: \(error?.localizedFailureReason)")
                return
            }
            
            pack!.resume()
        }
    }
    
    func offlinePackProgressDidChange(_ notification: Notification) {
        if let pack = notification.object as? MGLOfflinePack {
            let offlinePack = OfflinePack(pack: pack)

            if offlinePack.downloaded {
                UserDefaults.hasOfflineMap = true
            }
        }
    }
    
    func offlinePackDidReceiveError(_ notification: Notification) {
        if let error = (notification as NSNotification).userInfo?[MGLOfflinePackErrorUserInfoKey] as? NSError {
            print("Offline pack received error: \(error.localizedFailureReason)")
        }
    }
}
