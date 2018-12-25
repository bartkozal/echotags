//
//  DiscoveryButton.swift
//  echotags
//
//  Created by bkzl on 06/01/2017.
//

import UIKit

class DiscoveryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStyles()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setStyles()
    }

    private func setStyles() {
        self.backgroundColor = .positiveColor
        layoutIfNeeded()
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = bounds.width / 2
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.2, animations: {
                    self.backgroundColor = .brandColor
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.backgroundColor = .positiveColor
                })
            }
        }
    }
}
