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
            return UIColor(cgColor: layer.borderColor!)
        }
        
        set {
            layer.borderColor = newValue?.cgColor
            layer.borderWidth = 1
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                backgroundColor = .white
            } else {
                backgroundColor = .brandColor
            }
        }
    }
    
}
