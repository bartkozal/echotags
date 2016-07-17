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
import Mapbox

class PermissionsTutorialStepViewController: TutorialStepViewController {
    private let geofencing = Geofencing()
    private let offlineMap = OfflineMap()
    
    @IBOutlet private weak var locationPermissionButton: DesignableButton! {
        didSet {
            determinePermissionButtonStyle(CLLocationManager.authorizationStatus())
        }
    }
    
    @IBOutlet private weak var downloadMapButton: DesignableButton! {
        didSet {
            determineDownloadButtonStyle(offlineMap.isAvailable)
        }
    }
    
    @IBAction private func touchLocationPermissionButton(sender: DesignableButton) {
        geofencing.checkPermission(self)
    }

    @IBAction private func touchDownloadMapButton(sender: DesignableButton) {
        sender.userInteractionEnabled = false
        offlineMap.startDownloading()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(offlinePackProgressDidChange),
            name: MGLOfflinePackProgressChangedNotification,
            object: nil
        )
        
        geofencing.manager.delegate = self
    }
    
    
    func offlinePackProgressDidChange(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack {
            let offlinePack = OfflinePack(pack: pack)
            
            switch pack.state {
            case .Active:
                downloadMapButton.setTitle("Downloading... \(offlinePack.progressPercentage)%", forState: .Normal)
            case .Inactive:
                downloadMapButton.setTitle("Resume download", forState: .Normal)
            case .Complete:
                determineDownloadButtonStyle(offlinePack.isReady)
            default:
                break
            }
        }
    }
    
    private func determineDownloadButtonStyle(status: Bool) {
        if status {
            downloadMapButton.backgroundColor = UIColor(hex: "37435A")
            downloadMapButton.setTitleColor(.whiteColor(), forState: .Normal)
            downloadMapButton.setImage(UIImage(named: "icon-download-active"), forState: .Normal)
            downloadMapButton.setTitle("Offline map enabled", forState: .Normal)
            downloadMapButton.userInteractionEnabled = false
        }
    }
    
    private func determinePermissionButtonStyle(status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            locationPermissionButton.backgroundColor = UIColor(hex: "37435A")
            locationPermissionButton.setTitleColor(.whiteColor(), forState: .Normal)
            locationPermissionButton.setImage(UIImage(named: "icon-permissions-active"), forState: .Normal)
            locationPermissionButton.setTitle("Location service enabled", forState: .Normal)
            locationPermissionButton.userInteractionEnabled = false
        default:
            return
        }
    }
}

extension PermissionsTutorialStepViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        determinePermissionButtonStyle(status)
    }
}