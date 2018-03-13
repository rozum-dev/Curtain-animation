//
//  ViewController.swift
//  curtainTest
//
//  Created by Dmytro on 8/9/16.
//  Copyright © 2016 Dmytro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    fileprivate var isHorizontally = true

    @IBAction func presentHorizAction(_ sender: UIButton) {
        isHorizontally = true
        presentVC()
    }
    
    @IBAction func presentVerAction(_ sender: UIButton) {
        isHorizontally = false
        presentVC()
    }
    
    func presentVC() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerToPresent")
        vc!.transitioningDelegate = self
        self.present(vc!, animated: true) {
            
        }
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentAnimCtr = CurtainAnimationController()
        presentAnimCtr.isPositiveAnimation = true
        presentAnimCtr.isHorizontal = isHorizontally
        return presentAnimCtr
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentAnimCtr = CurtainAnimationController()
        presentAnimCtr.isPositiveAnimation = false
        presentAnimCtr.isHorizontal = isHorizontally
        return presentAnimCtr
    }
    
}

