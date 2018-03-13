//
//  CurtainAnimationController.swift
//  curtainTest
//
//  Created by Dmytro on 8/9/16.
//  Copyright © 2016 Dmytro. All rights reserved.
//

import UIKit

private let kTransitionDuration: TimeInterval = 0.7
private let kFadeViewAlpha: CGFloat = 0.3

open class CurtainAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    open var isPositiveAnimation: Bool = false
    open var isHorizontal: Bool = true
    
    func imageWithView(_ view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0);
        view.layer.render(in: UIGraphicsGetCurrentContext()!);
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img!;
    }
    
    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
                
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let container = transitionContext.containerView
        
        if (fromView != nil && toView != nil) {
            toView!.frame = container.bounds
            
            let viewToSnapshot = isPositiveAnimation ? fromView! : toView!
            
            let snapShotImg = self.imageWithView(viewToSnapshot)
            let firstSnapshotView = UIImageView.init(image: snapShotImg)
            let secondSnapshotView = UIImageView.init(image: snapShotImg)
            firstSnapshotView.contentMode = isHorizontal ? .left : .top
            secondSnapshotView.contentMode = isHorizontal ? .right : .bottom
            firstSnapshotView.clipsToBounds = true
            secondSnapshotView.clipsToBounds = true
            
            let firstSnapshotViewFrameStart = isHorizontal ? CGRect(x: 0.0, y: 0.0, width: container.frame.size.width / 2, height: container.frame.size.height) : CGRect(x: 0.0, y: 0.0, width: container.frame.size.width, height: container.frame.size.height / 2)
            let firstSnapshotViewFrameEnd = isHorizontal ? CGRect(x: -container.frame.size.width / 2, y: 0.0, width: container.frame.size.width / 2, height: container.frame.size.height) : CGRect(x: 0.0, y: -container.frame.size.height / 2, width: container.frame.size.width, height: container.frame.size.height / 2)
            
            let secondSnapshotViewFrameStart = isHorizontal ? CGRect(x: container.frame.size.width / 2, y: 0.0, width: container.frame.size.width / 2, height: container.frame.size.height) : CGRect(x: 0.0, y: container.frame.size.height / 2, width: container.frame.size.width, height: container.frame.size.height / 2)
            let secondSnapshotViewFrameEnd = isHorizontal ? CGRect(x: container.frame.size.width, y: 0.0, width: container.frame.size.width / 2, height: container.frame.size.height) : CGRect(x: 0.0, y: container.frame.size.height, width: container.frame.size.width, height: container.frame.size.height / 2)
            
            firstSnapshotView.frame = isPositiveAnimation ? firstSnapshotViewFrameStart : firstSnapshotViewFrameEnd
            secondSnapshotView.frame = isPositiveAnimation ? secondSnapshotViewFrameStart : secondSnapshotViewFrameEnd
            
            let viewToFade = isPositiveAnimation ? toView! : fromView!
            let fadeView = UIView.init(frame: viewToFade.bounds)
            fadeView.backgroundColor = UIColor.black                        
            let startAlpha:CGFloat = isPositiveAnimation ? kFadeViewAlpha : 0.0
            let endAlpha:CGFloat = isPositiveAnimation ? 0.0 : kFadeViewAlpha
            fadeView.alpha = startAlpha
            viewToFade.addSubview(fadeView)
            
            if isPositiveAnimation {
                container.addSubview(toView!)
            }
            container.addSubview(firstSnapshotView)
            container.addSubview(secondSnapshotView)
            
            UIView.animate(withDuration: kTransitionDuration, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                fadeView.alpha = endAlpha
                firstSnapshotView.frame = self.isPositiveAnimation ? firstSnapshotViewFrameEnd : firstSnapshotViewFrameStart
                secondSnapshotView.frame = self.isPositiveAnimation ? secondSnapshotViewFrameEnd : secondSnapshotViewFrameStart
                }, completion: { (finished) in
                    if !self.isPositiveAnimation {
                        container.addSubview(toView!)
                    }
                    fadeView.removeFromSuperview()
                    firstSnapshotView.removeFromSuperview()
                    secondSnapshotView.removeFromSuperview()
                    
                    let success = !transitionContext.transitionWasCancelled
                    
                    if (self.isPositiveAnimation && !success) || (!self.isPositiveAnimation && success) {
                        toView!.removeFromSuperview()
                    }
                    
                    transitionContext.completeTransition(success)
            })
        } else {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
        }
    }
    
    
    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kTransitionDuration
    }
}
