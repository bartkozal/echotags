//
//  SettingsDismissAnimationController.swift
//  Echotags
//
//  Created by bkzl on 20/07/2016.
//  Copyright © 2016 Bartłomiej Kozal. All rights reserved.
//

import UIKit

class SettingsDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.2
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let settingsVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! SettingsViewController
        let mapVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let mapVCFrame = transitionContext.finalFrameForViewController(mapVC)
        let containerView = transitionContext.containerView()!
        
        containerView.sendSubviewToBack(settingsVC.view)
        
        UIView.animateWithDuration(
            transitionDuration(transitionContext),
            delay: 0.0,
            options: .CurveEaseOut,
            animations: {
                settingsVC.overlayView.alpha = 0.0
                settingsVC.settingsScrollView.frame = CGRectOffset(mapVCFrame, 0, UIScreen.mainScreen().bounds.size.height)
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
}
