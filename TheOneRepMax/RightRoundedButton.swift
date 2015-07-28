//
//  RightRoundedButton.swift
//  TheOneRepMax
//
//  Created by Developer on 6/23/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class RightRoundedButton: NSButton {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        NSRectFillUsingOperation(self.bounds, NSCompositingOperation.CompositeClear)
        
        var width = dirtyRect.width
        var height = dirtyRect.height
        
        let cornerRadius = 25 as CGFloat
        
        let path = NSBezierPath()
        let topLeft = NSPoint(x: NSMinX(self.bounds), y: NSMinY(self.bounds))
        let topRight = NSPoint(x: NSMaxX(self.bounds), y: NSMinY(self.bounds))
        let bottomRight = NSPoint(x: NSMaxX(self.bounds), y: NSMaxY(self.bounds))
        let bottomLeft = NSPoint(x: NSMinX(self.bounds), y: NSMaxY(self.bounds))
        
        let topRight1 = NSPoint(x: topRight.x - cornerRadius, y: topRight.y)
        let topRight2 = NSPoint(x: topRight.x, y: topRight.y + cornerRadius)
        let bottomRight1 = NSPoint(x: bottomRight.x, y: bottomRight.y - cornerRadius)
        let bottomRight2 = NSPoint(x: bottomRight.x - cornerRadius, y: bottomRight.y)
        
        // Start drawing from upper left corner
        path.moveToPoint(topLeft)
        
        // Draw top border and a top-right rounded corner
        path.lineToPoint(topRight1)
        path.curveToPoint(topRight2, controlPoint1: topRight, controlPoint2: topRight)
        
        path.lineToPoint(bottomRight1)
        path.curveToPoint(bottomRight2, controlPoint1: bottomRight, controlPoint2: bottomRight)
        
        path.lineToPoint(bottomLeft)
        path.lineToPoint(topLeft)
        
        
        NSColor(red: 52/255, green: 204/255, blue: 51/255, alpha: 1).setFill()
        path.fill()
        
        self.addTitle("Join")
    }
    
    func addTitle(title: String) {
        var width = self.frame.width
        var height = self.frame.height
        var x = 0 as CGFloat
        var y = 0 as CGFloat
        let label = NSTextField()
        label.bezeled = false
        label.editable = false
        label.bordered = false
        label.stringValue = title
        label.font = NSFont(name: "Lucida Grande", size: 25)
        label.backgroundColor = NSColor.clearColor()
        label.alignment = .Center
        
        label.sizeToFit()
        
        var frame = label.frame
        width = frame.width
        height = frame.height
        x = (self.frame.width / 2) - (width / 2)
        y = (self.frame.height / 2) - (height / 2)
        
        label.frame = NSRect(x: x, y: y, width: width, height: height)
        
        self.addSubview(label)
    }
    
}
