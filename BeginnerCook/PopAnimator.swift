//
//  PopAnimator.swift
//  BeginnerCook
//
//  Created by Huangjunwei on 15/7/15.
//  Copyright © 2015年 Razeware LLC. All rights reserved.
//

import UIKit

class PopAnimator: NSObject,UIViewControllerAnimatedTransitioning{
    let duration:NSTimeInterval = 1.0
    var presenting = true
    var originFrame = CGRect.zeroRect
    var dismissCompletion: (()->())?
    
    
    // This is used for percent driven interactive transitions, as well as for container controllers that have companion animations that might need to
    // synchronize with the main animation.

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval{
    
    return duration
        
    }
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning)
    {
        let containerView = transitionContext.containerView()
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        let herbView = presenting ? toView : transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let herbViewController = transitionContext.viewControllerForKey(presenting ?UITransitionContextToViewControllerKey :UITransitionContextFromViewControllerKey ) as! HerbDetailsViewController
        
        let initialFrame = presenting ? originFrame : herbView.frame
        let finalFrame = presenting ?
        herbView.frame : originFrame
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width
            : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height
            : finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
        if presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(x: CGRectGetMidX(initialFrame),y: CGRectGetMidY(initialFrame))
            herbView.clipsToBounds = true
        }
        containerView!.addSubview(toView)
        containerView!.bringSubviewToFront(herbView)
       
        herbViewController.containerView.alpha = presenting ? 0.0 : 1.0
        
      UIView.animateWithDuration(duration, delay:0.0, usingSpringWithDamping:0.4, initialSpringVelocity: 0.0, options:[], animations: {
        
        herbViewController.containerView.alpha = self.presenting ? 1.0 : 0.0
        
        
            herbView.transform = self.presenting ?
            CGAffineTransformIdentity : scaleTransform
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
         
            }) {_ in
                if !self.presenting{
                self.dismissCompletion?()
                    
                }
          transitionContext.completeTransition(true)
                
        }
       let cornerRadiusAnimation = CABasicAnimation(keyPath: "layer.cornerRadius")
        cornerRadiusAnimation.fromValue = presenting ? 20.0/xScaleFactor : 0.0
        cornerRadiusAnimation.toValue = presenting ? 0.0 : 20.0/xScaleFactor
        cornerRadiusAnimation.duration = duration/2
        herbView.layer.addAnimation(cornerRadiusAnimation, forKey:nil)
        herbView.layer.cornerRadius = presenting ? 0.0 : 20.0/xScaleFactor
        
    }
}
