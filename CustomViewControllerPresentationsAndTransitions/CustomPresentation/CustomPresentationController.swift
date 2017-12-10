//
//  CustomPresentationController.swift
//  CustomViewControllerPresentationsAndTransitions
//
//  Created by Yusuke Taniguchi on 2017/11/23.
//  Copyright © 2017年 Yusuke Taniguchi. All rights reserved.
//

import UIKit

final class CustomPresentationController: UIPresentationController, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private static let cornerRadius: CGFloat = 16.0
    
    private var dimmingView: UIView?
    private var presentationWrappingView: UIView?
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
    }
    
    override var presentedView: UIView? {
        return self.presentationWrappingView
    }
    
    override func presentationTransitionWillBegin() {
        guard
            let presentedViewControllerView = super.presentedView,
            let containerView = self.containerView
        else { return }
        
        do {
           let presentationWrapperView = UIView(frame: self.frameOfPresentedViewInContainerView)
            presentationWrapperView.layer.shadowOpacity = 0.44
            presentationWrapperView.layer.shadowRadius = 13.0
            presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -0.6)
            self.presentationWrappingView = presentationWrapperView
            
            let presentationRoundedCornerView = UIView(frame: UIEdgeInsetsInsetRect(presentationWrapperView.bounds,
                                                                                    UIEdgeInsets(top: 0,
                                                                                                 left: 0,
                                                                                                 bottom: -CustomPresentationController.cornerRadius,
                                                                                                 right: 0)))
            presentationRoundedCornerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            presentationRoundedCornerView.layer.cornerRadius = CustomPresentationController.cornerRadius
            presentationRoundedCornerView.layer.masksToBounds = true
            
            let presentedViewControllerWrapperView = UIView(frame: UIEdgeInsetsInsetRect(presentationRoundedCornerView.bounds,
                                                                                         UIEdgeInsets(top: 0,
                                                                                                      left: 0, bottom: CustomPresentationController.cornerRadius,
                                                                                                      right: 0)))
            presentedViewControllerWrapperView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            presentedViewControllerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds
            presentedViewControllerWrapperView.addSubview(presentedViewControllerView)
            
            presentationRoundedCornerView.addSubview(presentedViewControllerWrapperView)
            
            presentationWrapperView.addSubview(presentationRoundedCornerView)
        }
        
        
        do {
            let dimmingView = UIView(frame: containerView.bounds)
            dimmingView.backgroundColor = UIColor.black
            dimmingView.isOpaque = false
            dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmigViewTapped(_:))))
            self.dimmingView = dimmingView
            self.containerView?.addSubview(dimmingView)
            
            let transitionCoordinator = self.presentingViewController.transitionCoordinator
            
            self.dimmingView?.alpha = 0
            transitionCoordinator?.animate(alongsideTransition: { [weak self] (_) in
                self?.dimmingView?.alpha = 0.5
            }, completion: nil)
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.presentationWrappingView = nil
            self.dimmingView = nil
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let transitionCoordinator = self.presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { (_) in
            self.dimmingView?.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.presentationWrappingView = nil
            self.dimmingView = nil
        }
    }
    
    // MARK: -
    // MARK: - Layout
    
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        if container === self.presentedViewController {
            self.containerView?.setNeedsLayout()
        }
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container === self.presentedViewController {
            return (container as! UIViewController).preferredContentSize
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let containerViewBounds = self.containerView?.bounds ?? CGRect(origin: CGPoint.zero, size: CGSize.zero)
        let presentedViewContentSize = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerViewBounds.size)
        
        var presentedViewControllerFrame = containerViewBounds
        presentedViewControllerFrame.size.height = presentedViewContentSize.height
        presentedViewControllerFrame.origin.y = containerViewBounds.maxY - presentedViewContentSize.height
        return presentedViewControllerFrame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        self.dimmingView?.frame = self.containerView?.bounds ?? CGRect(origin: CGPoint.zero, size: CGSize.zero)
        self.presentationWrappingView?.frame = self.frameOfPresentedViewInContainerView
    }
    
    // MARK: - UIGestureRecognizer
    
    @objc private func dimmigViewTapped(_ sender: UITapGestureRecognizer) {
        self.presentingViewController.dismiss(animated: true)
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated) ?? false ? 0.35 : 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            return
        }
        
        let containerView = transitionContext.containerView
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
//        let fromViewInitialFrame = transitionContext.initialFrame(for: fromVC)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        var toViewInitialFrame = transitionContext.initialFrame(for: toVC)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)
        
        let isPresenting = fromVC == self.presentingViewController
        let animations: () -> Void
        if isPresenting {
            guard let toView = transitionContext.view(forKey: .to) else { preconditionFailure("toView is nil.") }
            
            containerView.addSubview(toView)
            toViewInitialFrame.origin = CGPoint(x: containerView.bounds.minX, y: containerView.bounds.maxY)
            toViewInitialFrame.size = toViewFinalFrame.size
            toView.frame = toViewInitialFrame
            
            animations = {
                toView.frame = fromViewFinalFrame
            }
        } else {
            guard let fromView = transitionContext.view(forKey: .from) else { preconditionFailure("fromView is nil.") }
            fromViewFinalFrame = fromView.frame.offsetBy(dx: 0, dy: fromView.frame.height)
            animations = {
                fromView.frame = fromViewFinalFrame
            }
        }
        
        let animationCompletion: ((Bool) -> Void) = { (finished) in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
        
        UIView.animate(withDuration: transitionDuration, animations: animations, completion: animationCompletion)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        precondition(self.presentedViewController === presented,
                     "You didn't initialize \(self) with the correct presentedViewController.  Expected \(presented), got \(self.presentedViewController).")
        return self
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}
