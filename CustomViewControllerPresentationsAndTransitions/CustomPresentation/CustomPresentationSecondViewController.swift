//
//  CustomPresentationSecondViewController.swift
//  CustomViewControllerPresentationsAndTransitions
//
//  Created by Yusuke Taniguchi on 2017/11/23.
//  Copyright © 2017年 Yusuke Taniguchi. All rights reserved.
//

import UIKit

final class CustomPresentationSecondViewController: UIViewController {
    
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updatePreferredContentSize(with: self.traitCollection)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        self.updatePreferredContentSize(with: newCollection)
    }
    
    private func updatePreferredContentSize(with traitCollection: UITraitCollection) {
        self.preferredContentSize = CGSize(width: self.view.bounds.size.width,
                                           height: traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact ? 270 : 420)
        self.slider.maximumValue = Float(self.preferredContentSize.height);
        self.slider.minimumValue = 220
        self.slider.value = self.slider.maximumValue
    }
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        self.preferredContentSize = CGSize(width: self.view.bounds.size.width, height: CGFloat(sender.value))
    }
}
