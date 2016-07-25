//
//  RoundedButton
//  Echotags
//
//  Created by bkzl on 19/07/2016.
//  Copyright © 2016 Bartłomiej Kozal. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        
        set {
            layer.borderColor = newValue?.CGColor
            layer.borderWidth = 1
        }
    }
    
    override var enabled: Bool {
        didSet {
            if enabled {
                backgroundColor = .whiteColor()
            } else {
                backgroundColor = .brandColor()
            }
        }
    }
    
}