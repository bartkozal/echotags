//
//  MapViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController {
    private let geofencing = Geofencing()
    private let audio = AudioPlayer()
    private var startedNavigating = false
    private var userLocation: CLLocationCoordinate2D?
    private var userHeading: CLLocationDirection?
    
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
    
    @IBOutlet private weak var directionButton: UIButton!
    
    private var directing: Bool {
        get {
            return directionButton.selected
        }
        
        set {
            if newValue {
                directionButton.selected = true
                geofencing.manager.startUpdatingHeading()
            } else {
                directionButton.selected = false
                geofencing.manager.stopUpdatingHeading()
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
                directionButton.hidden = false
                geofencing.manager.startUpdatingLocation()
                startedNavigating = true
            } else {
                navigationButton.selected = false
                directionButton.hidden = true
                geofencing.manager.stopUpdatingLocation()
                directing = false
            }
        }
    }
    
    @IBAction internal func unwindToMapViewController(sender: UIStoryboardSegue) {}
    
    @IBAction private func touchDirectionButton() {
        directing = !directing
    }
    
    @IBAction private func touchNavigationButton() {
        switch geofencing.checkPermission() {
        case .Authorized:
            navigation = !navigation
        case .NotDetermined:
            geofencing.manager.requestWhenInUseAuthorization()
        case .Denied:
            presentViewController(Alert.accessToLocationBackgroundDenied(), animated: true, completion: nil)
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(didBecomeActive),
            name: UIApplicationDidBecomeActiveNotification,
            object: nil
        )
        
        geofencing.manager.delegate = self
    }
    
    @objc private func didBecomeActive() {
        reloadPointAnnotations()
    }
    
    private func updateDirection() {
        if directing {
            guard let location = userLocation else { return }
            guard let heading = userHeading else {
                let camera = MGLMapCamera(
                    lookingAtCenterCoordinate: location,
                    fromDistance: mapView.camera.altitude,
                    pitch: mapView.camera.pitch,
                    heading: mapView.camera.heading
                )
                mapView.setCamera(camera, animated: true)
                return
            }
            
            let camera = MGLMapCamera(
                lookingAtCenterCoordinate: location,
                fromDistance: 1000,
                pitch: 35,
                heading: heading
            )
            mapView.setCamera(camera, animated: true)
        }
    }
    
    private func lookForPoints() {
        guard let location = userLocation else { return }
        
        if let point = geofencing.lookForNearbyPoint(location) {
            point.markAsVisited()
            audio.play(point.audio)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0].coordinate
        guard let location = userLocation else { return }
        
        if geofencing.cityBoundsContains(location) {
            if startedNavigating {
                mapView.setCenterCoordinate(location, animated: true)
                startedNavigating = false
            }
            
            updateDirection()
            lookForPoints()
        } else {
            navigation = false
            presentViewController(Alert.outOfBounds(), animated: true, completion: nil)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        userHeading = newHeading.trueHeading
        updateDirection()
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
