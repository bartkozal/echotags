//
//  OvalButton.swift
//  Echotags
//
//  Created by bkzl on 25/07/2016.
//  Copyright © 2016 Bartłomiej Kozal. All rights reserved.
//

import UIKit

class OvalButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        adjustsImageWhenHighlighted = false
        backgroundColor = .whiteColor()
        layer.cornerRadius = bounds.width / 2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.5
    }
    
    override var selected: Bool {
        didSet {
            if selected {
                UIView.animateWithDuration(0.2) {
                    self.backgroundColor = .brandColor()
                }
            } else {
                UIView.animateWithDuration(0.2) {
                    self.backgroundColor = .whiteColor()
                }
            }
        }
    }
}

