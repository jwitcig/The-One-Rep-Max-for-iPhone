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
        
        self.setTitle(self.liftTemplate.liftName)
    }
    
    func setTitle(title: String) {
        var label = NSTextField(frame: NSRect())
        label.backgroundColor = NSColor.clearColor()
        label.bezeled = false
        label.bordered = false
        label.editable = false
        label.stringValue = title
        label.font = NSFont(name: "Lucida Grande", size: 20)
        label.sizeToFit()
        
        var paddingLeft = 20 as CGFloat
        let width = self.frame.width - paddingLeft
        let height = label.frame.height
        let x = paddingLeft
        let y = (self.frame.height / 2) - (height / 2)
        
        label.frame = NSRect(x: x, y: y, width: width, height: height)
        self.addSubview(label)
        
        
        paddingLeft -= 5
        let top = NSPoint(x: paddingLeft, y: CGRectGetMaxY(label.frame))
        let bottom = NSPoint(x: paddingLeft, y: CGRectGetMinY(label.frame))
        
        var path = NSBezierPath()
        path.moveToPoint(top)
        path.lineToPoint(bottom)
        NSColor.blackColor().setFill()
        path.stroke()
    }
    
    override func mouseUp(theEvent: NSEvent) {
        self.clickHandler?(template: self.liftTemplate)
    }
    
}
