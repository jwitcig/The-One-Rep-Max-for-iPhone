//
//  OneRepMaxContainer.swift
//  TheOneRepMax
//
//  Created by Developer on 7/1/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class OneRepMaxContainer: NSFlippedView {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let cornerRadius = 24 as CGFloat

        let topLeft = NSPoint(x: CGRectGetMinX(dirtyRect), y: CGRectGetMinY(dirtyRect))
        
        let topRight = NSPoint(x: CGRectGetMaxX(dirtyRect), y: CGRectGetMinY(dirtyRect))
        
        let bottomRight = NSPoint(x: CGRectGetMaxX(dirtyRect), y: CGRectGetMaxY(dirtyRect))
        let bottomRight1 = NSPoint(x: CGRectGetMaxX(dirtyRect), y: CGRectGetMaxY(dirtyRect)-cornerRadius)
        let bottomRight2 = NSPoint(x: CGRectGetMaxX(dirtyRect)-cornerRadius, y: CGRectGetMaxY(dirtyRect))
        
        
        let bottomLeft = NSPoint(x: CGRectGetMinX(dirtyRect), y: CGRectGetMaxY(dirtyRect))
        let bottomLeft1 = NSPoint(x: CGRectGetMinX(dirtyRect)+cornerRadius, y: CGRectGetMaxY(dirtyRect))
        let bottomLeft2 = NSPoint(x: CGRectGetMinX(dirtyRect), y: CGRectGetMaxY(dirtyRect)-cornerRadius)
        
        var path = NSBezierPath()
        path.moveToPoint(topLeft)
        path.lineToPoint(topRight)
        
        path.lineToPoint(bottomRight1)
        path.curveToPoint(bottomRight2, controlPoint1: bottomRight, controlPoint2: bottomRight)
        
        path.lineToPoint(bottomLeft1)
        path.curveToPoint(bottomLeft2, controlPoint1: bottomLeft, controlPoint2: bottomLeft)
        
        path.lineToPoint(topLeft)
        
        NSColor.darkGrayColor().setFill()
        path.fill()
        
    }
    
}
