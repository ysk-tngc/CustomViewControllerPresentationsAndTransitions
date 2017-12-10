//
//  CrossDissolveFirstViewController.swift
//  CustomViewControllerPresentationsAndTransitions
//
//  Created by Yusuke Taniguchi on 2017/11/20.
//  Copyright © 2017年 Yusuke Taniguchi. All rights reserved.
//

import UIKit

final class CrossDissolveFirstViewController: UIViewController {
    
    @IBAction func presentWithCustomTransitionAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CrossDissolve", bundle: nil)
        let secondVC = storyboard.instantiateViewController(withIdentifier: "SecondViewController")
        secondVC.modalPresentationStyle = .fullScreen
        secondVC.transitioningDelegate = self
        self.present(secondVC, animated: true, completion: nil)
    }
}

extension CrossDissolveFirstViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveTransitionAnimator()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CrossDissolveTransitionAnimator()
    }
}

