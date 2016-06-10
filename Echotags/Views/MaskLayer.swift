//
//  MaskLayer.swift
//  echotags
//
//  Created by bkzl on 14/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

struct MaskLayer {
    var bindToView: UIView
    var radius: CGFloat
    var xOffset: CGFloat
    var yOffset: CGFloat
    
    func circle() {
        let maskLayer = CAShapeLayer()
        let path = CGPathCreateMutable()
        
        CGPathAddArc(path, nil, xOffset, yOffset, radius, 0.0, 2 * 3.14, false)
        CGPathAddRect(path, nil, CGRectMake(0, 0, bindToView.frame.width, bindToView.frame.height))
        
        maskLayer.path = path
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        bindToView.layer.mask = maskLayer
        bindToView.clipsToBounds = true
    }
    
}