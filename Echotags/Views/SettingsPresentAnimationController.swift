//
//  SettingsPresentAnimationController.swift
//  Echotags
//
//  Created by bkzl on 20/07/2016.
//  Copyright © 2016 Bartłomiej Kozal. All rights reserved.
//

import UIKit

class SettingsPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let settingsVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! SettingsViewController
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: settingsVC)
        
        settingsVC.overlayView.alpha = 0.0
        settingsVC.settingsScrollView.frame = finalFrame.offsetBy(dx: 0, dy: UIScreen.main.bounds.size.height)
        
        containerView.addSubview(settingsVC.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                settingsVC.overlayView.alpha = 1.0
                settingsVC.settingsScrollView.frame = finalFrame
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
}
