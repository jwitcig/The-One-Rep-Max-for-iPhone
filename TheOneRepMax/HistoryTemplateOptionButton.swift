//
//  HistoryTemplateOptionButton.swift
//  TheOneRepMax
//
//  Created by Developer on 6/28/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit

class HistoryTemplateOptionButton: NSView {
    
    var liftTemplate: ORLiftTemplate!
    
    var clickHandler: ((template: ORLiftTemplate)->())?
    
    init(frame frameRect: NSRect, liftTemplate: ORLiftTemplate) {
        self.liftTemplate = liftTemplate
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let width = 3 as CGFloat
        let length = 10 as CGFloat
        let topRight1 = NSPoint(x: CGRectGetMaxX(dirtyRect)-length, y: CGRectGetMaxY(dirtyRect))
        let topRight2 = NSPoint(x: CGRectGetMaxX(dirtyRect), y: CGRectGetMaxY(dirtyRect))
        let topRight3 = NSPoint(x: CGRectGetMaxX(dirtyRect), y: CGRectGetMaxY(dirtyRect)-length)
        let topRight4 = NSPoint(x: CGRectGetMaxX(dirtyRect)-width, y: CGRectGetMaxY(dirtyRect)-length)
        let topRight5 = NSPoint(x: CGRectGetMaxX(dirtyRect)-width, y: CGRectGetMaxY(dirtyRect)-width)
        let topRight6 = NSPoint(x: CGRectGetMaxX(dirtyRect)-length, y: CGRectGetMaxY(dirtyRect)-width)
        
        var path = NSBezierPath()
        path.moveToPoint(topRight1)
        path.lineToPoint(topRight2)
        path.lineToPoint(topRight3)
        path.lineToPoint(topRight4)
        path.lineToPoint(topRight5)
        path.lineToPoint(topRight6)
        NSColor.blackColor().setFill()
        path.fill()
        
        self.setTitle(self.liftTemplate.liftName)
    }
    
    func setTitle(title: String) {
        var label = NSTextField(frame: NSRect())
        label.backgroundColor = NSColor.clearColor()
        label.bezeled = false
        label.bordered = false
        label.editable = false
        label.alignment = .CenterTextAlignment
        label.stringValue = title
        label.font = NSFont(name: "Lucida Grande", size: 20)
        label.sizeToFit()
        
        let width = label.frame.width
        let height = label.frame.height
        let x = (self.frame.width / 2) - (width / 2)
        let y = (self.frame.height / 2) - (height / 2)
        
        label.frame = NSRect(x: x, y: y, width: width, height: height)
        self.addSubview(label)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        self.clickHandler?(template: self.liftTemplate)
    }
    
}
