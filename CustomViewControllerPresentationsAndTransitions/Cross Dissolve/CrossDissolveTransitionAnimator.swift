//
//  CrossDissolveTransitionAnimator.swift
//  CustomViewControllerPresentationsAndTransitions
//
//  Created by Yusuke Taniguchi on 2017/11/20.
//  Copyright © 2017年 Yusuke Taniguchi. All rights reserved.
//

import UIKit

final class CrossDissolveTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to),
            let fromView = transitionContext.view(forKey: .from) ?? fromVC.view,
            let toView = transitionContext.view(forKey: .to) ?? toVC.view
        else { return }
        let containerView = transitionContext.containerView
        
        fromView.frame = transitionContext.initialFrame(for: fromVC)
        toView.frame = transitionContext.finalFrame(for: toVC)
        
        fromView.alpha = 1.0
        toView.alpha = 0.0
        
        containerView.addSubview(toView)
        
        let duration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            fromView.alpha = 0.0
            toView.alpha = 1.0
        }, completion: { (finished) in
            let wasCanceled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCanceled)
        })
    }
    
    
}
