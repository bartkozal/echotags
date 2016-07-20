//
//  SettingsPresentAnimationController.swift
//  Echotags
//
//  Created by bkzl on 20/07/2016.
//  Copyright © 2016 Bartłomiej Kozal. All rights reserved.
//

import UIKit

class SettingsPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let settingsVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! SettingsViewController
        let containerView = transitionContext.containerView()!
        let finalFrame = transitionContext.finalFrameForViewController(settingsVC)
        
        settingsVC.overlayView.alpha = 0.0
        settingsVC.settingsScrollView.frame = CGRectOffset(finalFrame, 0, UIScreen.mainScreen().bounds.size.height)
        
        containerView.addSubview(settingsVC.view)
        
        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0.0,
            options: .CurveEaseIn,
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
