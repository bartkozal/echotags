//
//  MapViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Spring
import Mapbox

class MapViewController: UIViewController {
    var isOverlayHidden: Bool {
        if let mainCVC = parentViewController as? MainContainerViewController {
            return mainCVC.isOverlayHidden
        }
        return true
    }
    
    private var geofencing = Geofencing()
    private var audio = AudioPlayer()
    
    @IBOutlet weak var overlayView: DesignableView!
    @IBOutlet private weak var outOfBoundsView: DesignableView!
    
    @IBOutlet private weak var mapView: MGLMapView! {
        didSet {
            mapView.delegate = self
            mapView.attributionButton.hidden = true
            mapView.showsUserLocation = true
            
            mapView.setCenterCoordinate(Geofencing.Defaults.coordinate, zoomLevel: Geofencing.Defaults.zoomLevel, animated: false)
            
            let camera = MGLMapCamera(lookingAtCenterCoordinate: mapView.centerCoordinate, fromDistance: 4000, pitch: 45, heading: 0)
            mapView.setCamera(camera, animated: false)
            
            reloadPointAnnotations()
        }
    }
    
    @IBAction internal func unwindToMapViewController(sender: UIStoryboardSegue) {}
    
    @IBAction private func touchOutOfBoundsButton(sender: AnyObject) {
        outOfBoundsView.animation = "fadeOut"
        outOfBoundsView.animateNext { [weak weakSelf = self] in
            weakSelf?.outOfBoundsView.hidden = true
        }
    }
    
    @IBAction private func touchOverlayView(sender: UIButton) {
        overlayView.animation = "fadeOut"
        overlayView.animateNext { [weak weakSelf = self] in
            weakSelf?.overlayView.hidden = true
            weakSelf?.geofencing.checkPermission(weakSelf!)
        }
    }
    
    func performSegueToSettingsOnButton(sender: UIButton?) {
        if let settingsButton = sender as? DesignableButton {
            settingsButton.rotate = -90.0
            settingsButton.animateNext {
                settingsButton.userInteractionEnabled = true
            }
        }
        performSegueWithIdentifier("segueToSettings", sender: sender)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        createMaskLayer()
    }
    
    private func createMaskLayer() {
        let xOffset = CGFloat(overlayView.frame.width - 26)
        let yOffset = CGFloat(overlayView.frame.height - 26)
        
        MaskLayer(bindToView: overlayView, radius: 42.0, xOffset: xOffset, yOffset: yOffset).circle()
    }
    
    func reloadPointAnnotations() {
        if let pointAnnotations = mapView.annotations {
            mapView.removeAnnotations(pointAnnotations)
        }
        
        for point in Marker.visible() {
            let point = point as! Point
            let pointAnnotation = MGLPointAnnotation()
            pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            pointAnnotation.title = point.title
            
            mapView.addAnnotation(pointAnnotation)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        overlayView.hidden = isOverlayHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        geofencing.manager.delegate = self
        
        geofencing.monitorNearestPoints()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0].coordinate
        
        if geofencing.cityBoundsContains(userLocation) {
            mapView.setCenterCoordinate(userLocation, animated: true)
        } else {
            outOfBoundsView.hidden = false
            mapView.showsUserLocation = false
        }

        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        audio.play(region.identifier)
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
