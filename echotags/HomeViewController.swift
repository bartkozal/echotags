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

class HomeViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet weak var overlayView: DesignableView!
    @IBOutlet weak var mapView: MGLMapView!
    
    
    @IBAction internal func unwindToHomeViewController(sender: UIStoryboardSegue) {}
    
    @IBAction func toggleOverlayView(sender: UIButton) {
        overlayView.animation = "fadeOut"
        overlayView.animateNext({
            self.overlayView.hidden = true
            
            // MARK: Remove after remove of "Test tutorial button"
            self.overlayView.alpha = CGFloat(1.0)
        })
    }
    
    @IBAction private func touchTestTutorial(sender: UIButton) {
        performSegueWithIdentifier("segueToTutorial", sender: sender)
    }
    
    func performSegueToSettingsOnButton(sender: UIButton?) {
        if let settingsButton = sender as? DesignableButton {
            settingsButton.rotate = -90.0
            settingsButton.animate()
        }
        performSegueWithIdentifier("segueToSettings", sender: sender)
    }
    
    override func viewWillLayoutSubviews() {
        createMaskLayer()
    }
    
    private func createMaskLayer() {
        let xOffset = CGFloat(overlayView.frame.width - 26)
        let yOffset = CGFloat(overlayView.frame.height - 26)
        
        MaskLayer(bindToView: overlayView, radius: 42.0, xOffset: xOffset, yOffset: yOffset).circle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.attributionButton.hidden = true
        
        let point = MGLPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: 52.36907, longitude: 4.89752)
        point.title = "Upstream Gallery"
        
        mapView.addAnnotation(point)
    }
    
    // MARK: Custom image
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("point")
        
        if annotationImage == nil {
            let image = UIImage(named: "icon-pin")!
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "point")
        }
        
        return annotationImage
    }
    
    // MARK: Tap on point
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
