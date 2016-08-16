//
//  PercentagesWheel.swift
//  TheOneRepMax
//
//  Created by Developer on 8/15/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

class PercentagesWheel: UIView {
    
    var percent: CGFloat = 0.7 {
        didSet { setNeedsDisplay() }
    }
    
    var percentChangedBlock: ((CGFloat)->())?
    
    private var shouldMove = false

    override func drawRect(rect: CGRect) {
        TORMStyleKit.drawCanvas1(strokeWidth: 3, fraction: percent, containerFrame: rect, handleSize: CGSize(width: 30, height: 30))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInView(self)
            
            let center = self.convertPoint(self.center, fromView: superview!)
            
            let deltaX = location.x - center.x
            let deltaY = location.y - center.y
            
            let distance = sqrt(pow(deltaX, 2) + pow(deltaY, 2))
            guard distance >= (self.frame.width/2) * 0.6 else { return }
            
            shouldMove = true
            
            percent = calculateFraction(deltaX: deltaX, deltaY: deltaY)
            percentChangedBlock?(percent)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let location = touch.locationInView(self)
            
            let center = self.convertPoint(self.center, fromView: superview!)
            
            let deltaX = location.x - center.x
            let deltaY = location.y - center.y
            
            let distance = sqrt(pow(deltaX, 2) + pow(deltaY, 2))
            guard shouldMove else { return }

            percent = calculateFraction(deltaX: deltaX, deltaY: deltaY)
            percentChangedBlock?(percent)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        shouldMove = false
    }
    
    func calculateFraction(deltaX deltaX: CGFloat, deltaY: CGFloat) -> CGFloat {
        var degrees = atan2(deltaY, deltaX) * 180.0 / CGFloat(M_PI) - 270
        
        if degrees < 0 {
            degrees += 360
        }
        
        let value = degrees / 360.0
        return value >= 0 ? value : 0.75 + (0.25 + value)
    }
    
}
