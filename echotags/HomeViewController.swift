//
//  HomeViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Spring
import Mapbox

class HomeViewController: UIViewController {
    
    @IBOutlet weak var overlayView: DesignableView!
    @IBOutlet private weak var mapView: MGLMapView! {
        didSet {
            let camera = MGLMapCamera(lookingAtCenterCoordinate: mapView.centerCoordinate, fromDistance: 4000, pitch: 45, heading: 0)
            
            mapView.delegate = self
            mapView.attributionButton.hidden = true
            mapView.setCamera(camera, animated: false)
            
            reloadPointAnnotations()
        }
    }
    
    @IBAction internal func unwindToHomeViewController(sender: UIStoryboardSegue) {}
    
    @IBAction func toggleOverlayView(sender: UIButton) {
        overlayView.animation = "fadeOut"
        overlayView.animateNext { [weak weakSelf = self] in
            weakSelf?.overlayView.hidden = true
            Location.checkPermission(self)
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

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)

        performSegueWithIdentifier("segueToTutorial", sender: self)
    }
}

extension HomeViewController: MGLMapViewDelegate {
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
