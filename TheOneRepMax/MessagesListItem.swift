//
//  MessagesListItem.swift
//  TheOneRepMax
//
//  Created by Developer on 7/2/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit

class MessagesListItem: NSView {
    
    var message: ORMessage!
    
    var clickHandler: ((message: ORMessage)->())?
    
    init(frame frameRect: NSRect, message: ORMessage) {
        self.message = message
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        self.drawDetail(frame: dirtyRect)
        
        let leftPadding = 10 as CGFloat
        var width = dirtyRect.width * (4/5) - leftPadding
        var height = dirtyRect.height
        var x = leftPadding
        var y = 0 as CGFloat
        
        let titleLabel = NSLabel(frame: NSRect(x: x, y: y, width: width, height: height))
        titleLabel.font = NSFont(name: "Lucida Grande", size: 35)
        titleLabel.stringValue = self.message.title
        titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        
        
        let dateLabel = NSLabel(frame: NSRect())
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d"
        dateLabel.alignment = .Right
        dateLabel.font = NSFont(name: "Lucida Grande", size: 20)
        dateLabel.stringValue = formatter.stringFromDate(self.message.createdDate)
        dateLabel.sizeToFit()
        
        width = dirtyRect.width - (titleLabel.frame.width + leftPadding)
        height = dateLabel.frame.height
        x = CGRectGetMaxX(titleLabel.frame)
        y = 0 as CGFloat
        
        dateLabel.frame = NSRect(x: x, y: y, width: width, height: height)
        
        self.addSubview(titleLabel)
        self.addSubview(dateLabel)
    }
    
    func drawDetail(frame frame: NSRect) {
        let bottomLeft = NSPoint(x: CGRectGetMinX(frame), y: CGRectGetMinY(frame))
        let bottomRight = NSPoint(x: CGRectGetMaxX(frame), y: CGRectGetMinY(frame))
        
        let path = NSBezierPath()
        path.moveToPoint(bottomLeft)
        path.lineToPoint(bottomRight)
        path.stroke()
    }
    
    override func mouseUp(theEvent: NSEvent) {
        self.clickHandler?(message: self.message)
    }
    
}
