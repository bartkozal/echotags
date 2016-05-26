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
import RealmSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var overlayView: DesignableView!
    @IBOutlet weak var mapView: MGLMapView! {
        didSet {
            mapView.delegate = self
            mapView.attributionButton.hidden = true
            
            let camera = MGLMapCamera(lookingAtCenterCoordinate: mapView.centerCoordinate, fromDistance: 4000, pitch: 45, heading: 0)
            
            mapView.setCamera(camera, animated: false)
            
            for point in Data.db.objects(Point) {
                let marker = MGLPointAnnotation()
                marker.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                marker.title = point.title
                
                mapView.addAnnotation(marker)
            }
        }
    }
    
    
    @IBAction internal func unwindToHomeViewController(sender: UIStoryboardSegue) {}
    
    @IBAction func toggleOverlayView(sender: UIButton) {
        overlayView.animation = "fadeOut"
        overlayView.animateNext { [weak weakSelf = self] in
            weakSelf?.overlayView.hidden = true
            
            // MARK: Remove after remove of "Test tutorial button"
            weakSelf?.overlayView.alpha = CGFloat(1.0)
        }
    }
    
    @IBAction private func touchTestTutorial(sender: UIButton) {
        performSegueWithIdentifier("segueToTutorial", sender: sender)
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
        createMaskLayer()
    }
    
    private func createMaskLayer() {
        let xOffset = CGFloat(overlayView.frame.width - 26)
        let yOffset = CGFloat(overlayView.frame.height - 26)
        
        MaskLayer(bindToView: overlayView, radius: 42.0, xOffset: xOffset, yOffset: yOffset).circle()
    }

}

extension HomeViewController: MGLMapViewDelegate {
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
