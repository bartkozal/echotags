//
//  MapViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Mapbox
import GoogleMobileAds

class MapViewController: UIViewController {
    fileprivate var firstRequest = false
    fileprivate var userHeading: CLLocationDirection?
    fileprivate var userLocation: CLLocationCoordinate2D?
    
    @IBOutlet fileprivate weak var mapView: MGLMapView! {
        didSet {
            mapView.delegate = self
            mapView.attributionButton.isHidden = true
            mapView.styleURL = Geofencing.Defaults.styleURL as URL!
            mapView.minimumZoomLevel = Geofencing.Bounds.minimumZoomLevel
            mapView.maximumZoomLevel = Geofencing.Bounds.maximumZoomLevel
            
            mapView.setCenter(Geofencing.Defaults.coordinate, zoomLevel: Geofencing.Defaults.zoomLevel, animated: false)
            
            let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 4000, pitch: 35, heading: 0)
            mapView.setCamera(camera, animated: false)
        }
    }
    
    @IBOutlet private weak var directionButton: UIButton!
    @IBOutlet private weak var adView: GADNativeExpressAdView!
    
    private var directing: Bool {
        get {
            return directionButton.isSelected
        }
        
        set {
            if newValue {
                directionButton.isSelected = true
                geofencing.manager.startUpdatingHeading()
            } else {
                directionButton.isSelected = false
                geofencing.manager.stopUpdatingHeading()
            }
        }
    }
    
    @IBOutlet private weak var navigationButton: UIButton!
    
    fileprivate var navigation: Bool {
        get {
            return navigationButton.isSelected
        }
        
        set {
            if newValue {
                navigationButton.isSelected = true
                directionButton.isHidden = false
                geofencing.manager.startUpdatingLocation()
                mapView.showsUserLocation = true
                firstRequest = true
            } else {
                navigationButton.isSelected = false
                directionButton.isHidden = true
                geofencing.manager.stopUpdatingLocation()
                mapView.showsUserLocation = false
                directing = false
            }
        }
    }
    
    @IBAction internal func unwindToMapViewController(_ sender: UIStoryboardSegue) {}
    
    @IBAction private func touchDirectionButton() {
        directing = !directing
    }
    
    @IBAction private func touchNavigationButton() {
        switch geofencing.checkPermission() {
        case .authorized:
            navigation = !navigation
        case .notDetermined:
            geofencing.manager.requestWhenInUseAuthorization()
        case .denied:
            present(Alert.accessToLocationBackgroundDenied(), animated: true, completion: nil)
        }
    }
    
    func reloadPointAnnotations() {
        if let pointAnnotations = mapView.annotations {
            mapView.removeAnnotations(pointAnnotations)
        }
        
        for point in Marker.visible() {
            let point = point as! Point
            let pointAnnotation = PointAnnotation(fromPoint: point)
            mapView.addAnnotation(pointAnnotation)
        }
    }
    
    func reloadPointAnnotation(_ point: Point) {
        if let pointAnnotation = mapView.annotations?.filter({ $0.title! == point.title }).first {
            mapView.removeAnnotation(pointAnnotation)
            let pointAnnotation = PointAnnotation(fromPoint: point)
            mapView.addAnnotation(pointAnnotation)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didBecomeActive),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil
        )

        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]

        adView.adUnitID = "ca-app-pub-7534465000462120/3993390694"
        adView.rootViewController = self
        adView.load(request)
        
        geofencing.manager.delegate = self
    }
    
    @objc private func didBecomeActive() {
        reloadPointAnnotations()
    }
    
    fileprivate func updateDirection() {
        if directing {
            guard let location = userLocation else { return }
            guard let heading = userHeading else {
                let camera = MGLMapCamera(
                    lookingAtCenter: location,
                    fromDistance: mapView.camera.altitude,
                    pitch: mapView.camera.pitch,
                    heading: mapView.camera.heading
                )
                mapView.setCamera(camera, animated: true)
                return
            }
            
            let camera = MGLMapCamera(
                lookingAtCenter: location,
                fromDistance: 1000,
                pitch: 35,
                heading: heading
            )
            mapView.setCamera(camera, animated: true)
        }
    }
    
    fileprivate func lookForPoints() {
        guard let location = userLocation else { return }
        
        guard let player = audio.player , player.isPlaying else {
            if let point = geofencing.lookForNearby(pointAt: location) {
                point.markAsVisited()
                audio.play(point.audio)
                reloadPointAnnotation(point)
            }
            return
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0].coordinate
        guard let location = userLocation else { return }
        
        if geofencing.cityBoundsContains(location) {
            if firstRequest {
                mapView.setCenter(location, animated: true)
                firstRequest = false
            }
            
            updateDirection()
            lookForPoints()
        } else {
            navigation = false
            present(Alert.outOfBounds(), animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        userHeading = newHeading.trueHeading
        updateDirection()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSettings" {
            segue.destination.transitioningDelegate = self
        }
    }
}

extension MapViewController: MGLMapViewDelegate {
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let annotation = annotation as! PointAnnotation
        var imageName = "marker-\(annotation.color)"
        
        if annotation.visited {
            imageName = "marker-visited"
        }
        
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: imageName)
        
        if annotationImage == nil {
            let image = UIImage(named: imageName)!
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: imageName)
        }
        
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
        let audioButton = UIButton()
        
        audioButton.frame = CGRect(x: 0, y: 0, width: 33, height: 43)
        audioButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 10)
        audioButton.setImage(UIImage(named: "icon-play"), for: UIControlState())
        
        return audioButton
    }
    
    func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
        if let audioFile = (annotation as? PointAnnotation)?.audio {
            audio.play(audioFile)
        }
        mapView.deselectAnnotation(annotation, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return annotation.isMember(of: PointAnnotation.self)
    }
}

extension MapViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SettingsPresentAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SettingsDismissAnimationController()
    }
}
