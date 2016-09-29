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
    
    public var isPositiveAnimation: Bool = false
    public var isHorizontal: Bool = true
    
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
            
            let viewToSnapshot = isPositiveAnimation ? fromView! : toView!
            
            let snapShotImg = self.imageWithView(viewToSnapshot)
            let firstSnapshotView = UIImageView.init(image: snapShotImg)
            let secondSnapshotView = UIImageView.init(image: snapShotImg)
            firstSnapshotView.contentMode = isHorizontal ? .Left : .Top
            secondSnapshotView.contentMode = isHorizontal ? .Right : .Bottom
            firstSnapshotView.clipsToBounds = true
            secondSnapshotView.clipsToBounds = true
            
            let firstSnapshotViewFrameStart = isHorizontal ? CGRectMake(0.0, 0.0, container!.frame.size.width / 2, container!.frame.size.height) : CGRectMake(0.0, 0.0, container!.frame.size.width, container!.frame.size.height / 2)
            let firstSnapshotViewFrameEnd = isHorizontal ? CGRectMake(-container!.frame.size.width / 2, 0.0, container!.frame.size.width / 2, container!.frame.size.height) : CGRectMake(0.0, -container!.frame.size.height / 2, container!.frame.size.width, container!.frame.size.height / 2)
            
            let secondSnapshotViewFrameStart = isHorizontal ? CGRectMake(container!.frame.size.width / 2, 0.0, container!.frame.size.width / 2, container!.frame.size.height) : CGRectMake(0.0, container!.frame.size.height / 2, container!.frame.size.width, container!.frame.size.height / 2)
            let secondSnapshotViewFrameEnd = isHorizontal ? CGRectMake(container!.frame.size.width, 0.0, container!.frame.size.width / 2, container!.frame.size.height) : CGRectMake(0.0, container!.frame.size.height, container!.frame.size.width, container!.frame.size.height / 2)
            
            firstSnapshotView.frame = isPositiveAnimation ? firstSnapshotViewFrameStart : firstSnapshotViewFrameEnd
            secondSnapshotView.frame = isPositiveAnimation ? secondSnapshotViewFrameStart : secondSnapshotViewFrameEnd
            
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
            container!.addSubview(firstSnapshotView)
            container!.addSubview(secondSnapshotView)
            
            UIView.animateWithDuration(kTransitionDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                fadeView.alpha = endAlpha
                firstSnapshotView.frame = self.isPositiveAnimation ? firstSnapshotViewFrameEnd : firstSnapshotViewFrameStart
                secondSnapshotView.frame = self.isPositiveAnimation ? secondSnapshotViewFrameEnd : secondSnapshotViewFrameStart
                }, completion: { (finished) in
                    if !self.isPositiveAnimation {
                        container!.addSubview(toView!)
                    }
                    fadeView.removeFromSuperview()
                    firstSnapshotView.removeFromSuperview()
                    secondSnapshotView.removeFromSuperview()
                    
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
