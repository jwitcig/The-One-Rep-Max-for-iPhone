//
//  AccountIconView.swift
//  TheOneRepMax
//
//  Created by Developer on 8/25/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

class AccountIconButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        opaque = false
        addObserver(self, forKeyPath: "highlighted", options: .New, context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        let color = highlighted ? UIColor.whiteColor() : UIColor.blackColor()
        
        let rootLayer = CAShapeLayer() // Generated by Svgsus
        ({
            let layer1 = CAShapeLayer()
            layer1.fillColor = color.CGColor
            layer1.strokeColor = color.CGColor
            layer1.lineWidth = 1
            rootLayer.addSublayer(layer1)
            let path = UIBezierPath()
            path.moveToPoint(CGPoint(x: 12, y: 2))
            path.addCurveToPoint(CGPoint(x: 2, y: 12), controlPoint1: CGPoint(x: 6.48, y: 2), controlPoint2: CGPoint(x: 2, y: 6.48))
            path.addCurveToPoint(CGPoint(x: 12, y: 22), controlPoint1: CGPoint(x: 2, y: 17.52), controlPoint2: CGPoint(x: 6.48, y: 22))
            path.addCurveToPoint(CGPoint(x: 22, y: 12), controlPoint1: CGPoint(x: 17.52, y: 22), controlPoint2: CGPoint(x: 22, y: 17.52))
            path.addCurveToPoint(CGPoint(x: 12, y: 2), controlPoint1: CGPoint(x: 22, y: 6.48), controlPoint2: CGPoint(x: 17.52, y: 2))
            path.closePath()
            path.moveToPoint(CGPoint(x: 12, y: 5))
            path.addCurveToPoint(CGPoint(x: 15, y: 8), controlPoint1: CGPoint(x: 13.66, y: 5), controlPoint2: CGPoint(x: 15, y: 6.34))
            path.addCurveToPoint(CGPoint(x: 12, y: 11), controlPoint1: CGPoint(x: 15, y: 9.66), controlPoint2: CGPoint(x: 13.66, y: 11))
            path.addCurveToPoint(CGPoint(x: 9, y: 8), controlPoint1: CGPoint(x: 10.34, y: 11), controlPoint2: CGPoint(x: 9, y: 9.66))
            path.addCurveToPoint(CGPoint(x: 12, y: 5), controlPoint1: CGPoint(x: 9, y: 6.34), controlPoint2: CGPoint(x: 10.34, y: 5))
            path.closePath()
            path.moveToPoint(CGPoint(x: 12, y: 19.2))
            path.addCurveToPoint(CGPoint(x: 6, y: 15.979999999999999), controlPoint1: CGPoint(x: 9.5, y: 19.2), controlPoint2: CGPoint(x: 7.29, y: 17.919999999999998))
            path.addCurveToPoint(CGPoint(x: 12, y: 12.899999999999999), controlPoint1: CGPoint(x: 6.03, y: 13.989999999999998), controlPoint2: CGPoint(x: 10, y: 12.899999999999999))
            path.addCurveToPoint(CGPoint(x: 18, y: 15.979999999999999), controlPoint1: CGPoint(x: 13.99, y: 12.899999999999999), controlPoint2: CGPoint(x: 17.97, y: 13.989999999999998))
            path.addCurveToPoint(CGPoint(x: 12, y: 19.2), controlPoint1: CGPoint(x: 16.71, y: 17.919999999999998), controlPoint2: CGPoint(x: 14.5, y: 19.2))
            path.closePath()
            layer1.path = path.CGPath
        })()
        rootLayer.bounds = CGRect(x: 0, y: 0, width: 24, height: 24)
        rootLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        layer.addSublayer(rootLayer)
    }
    
}