//
//  PullableToolbar.swift
//  TheOneRepMax
//
//  Created by Developer on 1/24/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

class PullableToolbar: UIToolbar {

    let resetTime = 0.3
    
    var touch: UITouch?

    var initialTouchLocation: CGPoint = CGPoint.zero {
        didSet {
            touchOriginOffset = CGPoint(x: -initialTouchLocation.x, y: -initialTouchLocation.y)
        }
    }
    
    var interactionEnabled = true
    var activationThreshhold: CGFloat = 0.3
    var activated: Bool {
        return frame.origin.x < -frame.width * activationThreshhold
    }
    var crossedActivationThreshold = false
    var activationBlock: (()->())?
    
    var touchOriginOffset: CGPoint = CGPoint.zero
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        self.touch = touch
        initialTouchLocation = touch.locationInView(self)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches where touch == self.touch {
            
            guard interactionEnabled else { return }
            
            guard let superview = self.superview else { return }
            let firstTouchLocation = superview.convertPoint(initialTouchLocation, toView: superview)
            
            let currentTouchLocation = touch.locationInView(superview)

            
            if activated {
                
                let newPosition = CGPoint(x: (currentTouchLocation.x + touchOriginOffset.x) , y: frame.origin.y)
                
                
                if interactionEnabled && !crossedActivationThreshold {
                    interactionEnabled = false

                    UIView.animateWithDuration(0.15, animations: {
                        self.frame = CGRect(origin: newPosition, size: self.frame.size)
                        }) { (animated) in
                            self.interactionEnabled = true
                    }
                    crossedActivationThreshold = true

                } else {
                    self.frame = CGRect(origin: newPosition, size: self.frame.size)
                }
                
            } else {
                let deltaX = (currentTouchLocation.x - firstTouchLocation.x) * 0.5
                

                guard deltaX < 0 else { return }
                
                let previousPosition = self.frame.origin
                let newPosition = CGPoint(x: firstTouchLocation.x + deltaX + touchOriginOffset.x, y: previousPosition.y)
                
                self.frame = CGRect(origin: newPosition, size: self.frame.size)
            }
            
            crossedActivationThreshold = false

        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches where touch == self.touch {
            
            if !activated {
                resetPosition()
            } else {
                runActivationAnimation()
            }
            
        }
    }
    
    func runActivationAnimation() {
        UIView.animateWithDuration(resetTime, animations: {
            
            let newPosition = CGPoint(x: -self.frame.width, y: self.frame.origin.y)
            
            self.frame = CGRect(origin: newPosition, size: self.frame.size)
            
        }) { (animated) -> Void in
            
            self.activationBlock?()
            
        }
    }
    
    func resetPosition() {
        UIView.animateWithDuration(resetTime) {
            
            let currentPosition = self.frame.origin
            
            let newPosition = CGPoint(x: 0, y: currentPosition.y)
            
            self.frame = CGRect(origin: newPosition, size: self.frame.size)
        }
    }
    
}
