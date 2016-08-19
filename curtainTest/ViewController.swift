//
//  ViewController.swift
//  curtainTest
//
//  Created by Dmytro on 8/9/16.
//  Copyright © 2016 Dmytro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBAction func buttonAction(sender: AnyObject) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("ViewControllerToPresent")
        vc!.transitioningDelegate = self
        self.presentViewController(vc!, animated: true) {
            
        }
    }

    // UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentAnimCtr = CurtainAnimationController.init()
        presentAnimCtr.isPositiveAnimation = true
        return presentAnimCtr
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentAnimCtr = CurtainAnimationController.init()
        presentAnimCtr.isPositiveAnimation = false
        return presentAnimCtr
    }
    
}

