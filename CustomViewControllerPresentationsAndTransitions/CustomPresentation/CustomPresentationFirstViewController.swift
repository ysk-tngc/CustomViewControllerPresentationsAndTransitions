//
//  CustomPresentationFirstViewController.swift
//  CustomViewControllerPresentationsAndTransitions
//
//  Created by Yusuke Taniguchi on 2017/11/23.
//  Copyright © 2017年 Yusuke Taniguchi. All rights reserved.
//

import UIKit

final class CustomPresentationFirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        guard let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") else { return }
        let presentationController = CustomPresentationController(presentedViewController: secondVC, presenting: self)
        withExtendedLifetime(presentationController) {
            secondVC.transitioningDelegate = presentationController
            self.present(secondVC, animated: true, completion: nil)
        }
        
    }
}
