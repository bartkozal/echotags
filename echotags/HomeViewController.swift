//
//  HomeViewController.swift
//  echotags
//
//  Created by bkzl on 11/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit
import Spring

class HomeViewController: UIViewController {

    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var overlayViewMask: DesignableView!
    
    @IBAction internal func unwindToHomeViewController (sender: UIStoryboardSegue) {}

    @IBAction func toggleOverlayView(sender: UIButton) {
        overlayView.hidden = !overlayView.hidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maskLayer = createMaskLayer()
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true
    }
    
    private func createMaskLayer() -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        let path = CGPathCreateMutable()
        let radius = CGFloat(42.0)
        let xOffset = CGFloat(overlayView.frame.width - 26)
        let yOffset = CGFloat(overlayView.frame.height - 26)
        
        CGPathAddArc(path, nil, xOffset, yOffset, radius, 0.0, 2 * 3.14, false)
        CGPathAddRect(path, nil, CGRectMake(0, 0, overlayView.frame.width, overlayView.frame.height))
        
        maskLayer.path = path;
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        return maskLayer
    }
}
