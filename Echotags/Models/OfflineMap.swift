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
            let progress = pack.progress
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected
            let progressPercentage = Float(completedResources) / Float(expectedResources)
            
            // if progressView == nil {
            //     progressView = UIProgressView(progressViewStyle: .Default)
            //     let frame = view.bounds.size
            //     progressView.frame = CGRectMake(frame.width / 4, frame.height * 0.75, frame.width / 2, 10)
            //     view.addSubview(progressView)
            // }
            // progressView.progress = progressPercentage
            
            if completedResources == expectedResources {
                let byteCount = NSByteCountFormatter.stringFromByteCount(Int64(pack.progress.countOfBytesCompleted), countStyle: .Memory)
                print("Offline pack completed: \(byteCount), \(completedResources) resources")
            } else {
                UserDefaults.hasOfflineMap = true
                print("Offline pack has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
            }
        }
    }
    
    func offlinePackDidReceiveError(notification: NSNotification) {
        if let error = notification.userInfo?[MGLOfflinePackErrorUserInfoKey] as? NSError {
            print("Offline pack received error: \(error.localizedFailureReason)")
        }
    }
}
