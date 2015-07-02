//
//  MenuItem.swift
//  TheOneRepMax
//
//  Created by Developer on 7/1/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

@IBDesignable class MenuItem: NSLabel {
    
    var clickHandler: (()->())?

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let width = 10 as CGFloat
        let topRight = NSPoint(x: CGRectGetMaxX(dirtyRect), y: CGRectGetMinY(dirtyRect))
        let topRight1 = NSPoint(x: CGRectGetMaxX(dirtyRect)-width, y: CGRectGetMinY(dirtyRect))
        let topRight2 = NSPoint(x: CGRectGetMaxX(dirtyRect), y: CGRectGetMinY(dirtyRect)+width)

        var path = NSBezierPath()
        path.moveToPoint(topRight1)
        path.lineToPoint(topRight)
        path.lineToPoint(topRight2)
        path.fill()
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.clickHandler?()
    }
    
}
