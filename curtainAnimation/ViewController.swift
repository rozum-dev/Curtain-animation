//
//  ViewController.swift
//  curtainTest
//
//  Created by Dmytro on 8/9/16.
//  Copyright © 2016 Dmytro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    private var isHorizontally = true

    @IBAction func presentHorizAction(sender: UIButton) {
        isHorizontally = true
        presentVC()
    }
    
    @IBAction func presentVerAction(sender: UIButton) {
        isHorizontally = false
        presentVC()
    }
    
    func presentVC() {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ViewControllerToPresent")
        vc!.transitioningDelegate = self
        self.presentViewController(vc!, animated: true) {
            
        }
    }
    
    //MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentAnimCtr = CurtainAnimationController.init()
        presentAnimCtr.isPositiveAnimation = true
        presentAnimCtr.isHorizontal = isHorizontally
        return presentAnimCtr
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentAnimCtr = CurtainAnimationController.init()
        presentAnimCtr.isPositiveAnimation = false
        presentAnimCtr.isHorizontal = isHorizontally
        return presentAnimCtr
    }
    
}

