//
//  SettingsDismissAnimationController.swift
//  Echotags
//
//  Created by bkzl on 20/07/2016.
//

import UIKit

class SettingsDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let settingsVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! SettingsViewController
        let mapVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let mapVCFrame = transitionContext.finalFrame(for: mapVC)
        let containerView = transitionContext.containerView
        
        containerView.sendSubview(toBack: settingsVC.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                settingsVC.overlayView.alpha = 0.0
                settingsVC.settingsScrollView.frame = mapVCFrame.offsetBy(dx: 0, dy: UIScreen.main.bounds.size.height)
            },
            completion: { _ in
                transitionContext.completeTransition(true)
            }
        )
    }
}
