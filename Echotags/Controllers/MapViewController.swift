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
    
    private let geofencing = Geofencing()
    private let audio = AudioPlayer()
    private var isFirstLoad = true
    private var userLocation: CLLocationCoordinate2D?
    private var userHeading: CLLocationDirection?
    
    @IBOutlet weak var overlayView: DesignableView!
    
    @IBOutlet private weak var mapView: MGLMapView! {
        didSet {
            mapView.delegate = self
            mapView.attributionButton.hidden = true
            mapView.showsUserLocation = true
            mapView.styleURL = Geofencing.Defaults.styleURL
            mapView.minimumZoomLevel = Geofencing.Bounds.minimumZoomLevel
            mapView.maximumZoomLevel = Geofencing.Bounds.maximumZoomLevel
            
            mapView.setCenterCoordinate(Geofencing.Defaults.coordinate, zoomLevel: Geofencing.Defaults.zoomLevel, animated: false)
            
            let camera = MGLMapCamera(lookingAtCenterCoordinate: mapView.centerCoordinate, fromDistance: 4000, pitch: 35, heading: 0)
            mapView.setCamera(camera, animated: false)
        }
    }
    
    @IBOutlet private weak var centerMapButton: UIButton! {
        didSet {
            centerMapButton.hidden = true
        }
    }
    
    private var centering: Bool {
        get {
            return centerMapButton.selected
        }
        
        set {
            if newValue {
                centerMapButton.selected = true
                geofencing.manager.startUpdatingHeading()
                centerMapButton.setImage(UIImage(named: "icon-center-active"), forState: .Normal)
            } else {
                centerMapButton.selected = false
                geofencing.manager.stopUpdatingHeading()
                centerMapButton.setImage(UIImage(named: "icon-center"), forState: .Normal)
            }
        }
    }
    
    @IBOutlet private weak var navigationButton: UIButton!
    
    private var navigation: Bool {
        get {
            return navigationButton.selected
        }
        
        set {
            if newValue {
                navigationButton.selected = true
                centerMapButton.hidden = false
                geofencing.manager.startUpdatingLocation()
                navigationButton.setImage(UIImage(named: "icon-navigation-active"), forState: .Normal)
            } else {
                navigationButton.selected = false
                centerMapButton.hidden = true
                geofencing.manager.stopUpdatingLocation()
                navigationButton.setImage(UIImage(named: "icon-navigation"), forState: .Normal)
                centering = false
            }
        }
    }
    
    @IBAction internal func unwindToMapViewController(sender: UIStoryboardSegue) {}
    
    @IBAction private func touchCenterMapButton(sender: UIButton) {
        centering = !centering
    }
    
    @IBAction private func touchNavigationButton(sender: UIButton) {
        navigation = !navigation
    }
    
    @IBAction private func touchOverlayView(sender: UIButton) {
        overlayView.animation = "fadeOut"
        overlayView.animateNext { [unowned self] in
            self.overlayView.hidden = true
            self.geofencing.checkPermission(self)
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
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
            if let pointAnnotations = self.mapView.annotations {
                self.mapView.removeAnnotations(pointAnnotations)
            }
            
            for point in Marker.visible() {
                let point = point as! Point
                let pointAnnotation = PointAnnotation(fromPoint: point)
                self.mapView.addAnnotation(pointAnnotation)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        overlayView.hidden = isOverlayHidden
        
        reloadPointAnnotations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(didBecomeActive),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil
        )
        
        geofencing.manager.delegate = self
        geofencing.manager.requestLocation()
    }
    
    @objc private func didBecomeActive() {
        reloadPointAnnotations()
    }
    
    private func tryCenterMapOn(location: CLLocationCoordinate2D?, heading: CLLocationDirection?) {
        if centering {
            if let location = location, heading = heading {
                let camera = MGLMapCamera(lookingAtCenterCoordinate: location, fromDistance: 1000, pitch: 35, heading: heading)
                mapView.setCamera(camera, animated: true)
            }
        }
    }
    
    private func handleUserLocation(userLocation: CLLocationCoordinate2D) {
        if let point = geofencing.lookForNearbyPoint(userLocation) {
            point.markAsVisited()
            audio.play(point.audio)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0].coordinate
        
        if let userLocation = userLocation {
            if geofencing.cityBoundsContains(userLocation) {
                if isFirstLoad {
                    mapView.setCenterCoordinate(userLocation, animated: true)
                    isFirstLoad = false
                } else {
                    handleUserLocation(userLocation)
                }
                
                tryCenterMapOn(userLocation, heading: userHeading)
            } else {
                Alert(vc: self).outOfBounds()
                navigation = false
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        userHeading = newHeading.trueHeading
        tryCenterMapOn(userLocation, heading: userHeading)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let annotation = annotation as! PointAnnotation
        var imageName = "marker-\(annotation.color)"
        
        if annotation.visited {
            imageName = "marker-visited"
        }
        
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(imageName)
        
        if annotationImage == nil {
            let image = UIImage(named: imageName)!
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: imageName)
        }
        
        return annotationImage
    }
    
    func mapView(mapView: MGLMapView, rightCalloutAccessoryViewForAnnotation annotation: MGLAnnotation) -> UIView? {
        let audioButton = UIButton()
        
        audioButton.frame = CGRectMake(0, 0, 23, 23)
        audioButton.setImage(UIImage(named: "icon-play"), forState: .Normal)
        
        return audioButton
    }
    
    func mapView(mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        if let audioFile = (annotation as? PointAnnotation)?.audio {
            audio.play(audioFile)
        }
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return annotation.isMemberOfClass(PointAnnotation)
    }
}
