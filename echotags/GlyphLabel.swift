//
//  GlyphLabel.swift
//  echotags
//
//  Created by bkzl on 17/05/16.
//  Copyright © 2016 bkzl. All rights reserved.
//

import UIKit

struct GlyphLabel {
    var label: UILabel
    
    func replace(placeholderCharacter: String, withImage: String) -> UILabel {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: withImage)
        
        let image = NSAttributedString(attachment: attachment)
        
        if let currentText = label.text {
            if let placeholderRange = currentText.rangeOfString(placeholderCharacter) {
                let glyphIndex = currentText.startIndex.distanceTo(placeholderRange.startIndex)
                let textWithoutPlaceholder = currentText.stringByReplacingOccurrencesOfString(placeholderCharacter, withString: "")
                let textWithGlyph = NSMutableAttributedString(string: textWithoutPlaceholder)
                
                textWithGlyph.insertAttributedString(image, atIndex: glyphIndex)
                label.attributedText = textWithGlyph
            }
        }
        
        return label
    }
}