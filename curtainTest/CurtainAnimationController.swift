//
//  CurtainAnimationController.swift
//  curtainTest
//
//  Created by Dmytro on 8/9/16.
//  Copyright © 2016 Dmytro. All rights reserved.
//

import UIKit

private let kTransitionDuration: NSTimeInterval = 0.7
private let kFadeViewAlpha: CGFloat = 0.3

public class CurtainAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var isPositiveAnimation: Bool
    
    override init() {
        isPositiveAnimation = false
        super.init()
    }
    
    func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!);
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
                
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
        let container = transitionContext.containerView()
        
        if (fromView != nil && toView != nil && container != nil) {
            toView!.frame = container!.bounds
            
            let viewToSnapshot = self.isPositiveAnimation ? fromView! : toView!
            
            let snapShotImg = self.imageWithView(viewToSnapshot)
            let topSnapshotView = UIImageView.init(image: snapShotImg)
            let bottomSnapshotView = UIImageView.init(image: snapShotImg)
            topSnapshotView.contentMode = .Top
            bottomSnapshotView.contentMode = .Bottom
            topSnapshotView.clipsToBounds = true
            bottomSnapshotView.clipsToBounds = true
                        
//            let topSnapshotView = viewToSnapshot.resizableSnapshotViewFromRect(CGRectMake(0, 0, fromView!.bounds.size.width, fromView!.bounds.size.height / 2), afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
//            let bottomSnapshotView = viewToSnapshot.resizableSnapshotViewFromRect(CGRectMake(0, fromView!.bounds.size.height / 2, fromView!.bounds.size.width, fromView!.bounds.size.height / 2), afterScreenUpdates: true, withCapInsets: UIEdgeInsetsZero)
            
            let topYStart = isPositiveAnimation ? 0 : -container!.frame.size.height / 2
            let topYEnd = isPositiveAnimation ? -container!.frame.size.height / 2 : 0
            let bottomYStart = isPositiveAnimation ? container!.frame.size.height / 2 : container!.frame.size.height
            let bottomYEnd = isPositiveAnimation ? container!.frame.size.height : container!.frame.size.height / 2
            
            topSnapshotView.frame = CGRectMake(container!.frame.origin.x, topYStart, container!.frame.size.width, container!.frame.size.height / 2)
            bottomSnapshotView.frame = CGRectMake(container!.frame.origin.x, bottomYStart, container!.frame.size.width, container!.frame.size.height / 2)
            
            let viewToFade = isPositiveAnimation ? toView! : fromView!
            let fadeView = UIView.init(frame: viewToFade.bounds)
            fadeView.backgroundColor = UIColor.blackColor()                        
            let startAlpha:CGFloat = isPositiveAnimation ? kFadeViewAlpha : 0.0
            let endAlpha:CGFloat = isPositiveAnimation ? 0.0 : kFadeViewAlpha
            fadeView.alpha = startAlpha
            viewToFade.addSubview(fadeView)
            
            if isPositiveAnimation {
                container!.addSubview(toView!)
            }
            container!.addSubview(topSnapshotView)
            container!.addSubview(bottomSnapshotView)
            
            UIView.animateWithDuration(kTransitionDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                fadeView.alpha = endAlpha
                topSnapshotView.frame = CGRectOffset(topSnapshotView.frame, 0, topYEnd - topYStart)
                bottomSnapshotView.frame = CGRectOffset(bottomSnapshotView.frame, 0, bottomYEnd - bottomYStart)
                }, completion: { (finished) in
                    if !self.isPositiveAnimation {
                        container!.addSubview(toView!)
                    }
                    fadeView.removeFromSuperview()
                    topSnapshotView.removeFromSuperview()
                    bottomSnapshotView.removeFromSuperview()
                    
                    let success = !transitionContext.transitionWasCancelled()
                    
                    if (self.isPositiveAnimation && !success) || (!self.isPositiveAnimation && success) {
                        toView!.removeFromSuperview()
                    }
                    
                    transitionContext.completeTransition(success)
            })
        } else {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled())
        }
    }
    
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return kTransitionDuration
    }
}
