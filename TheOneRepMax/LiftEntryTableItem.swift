//
//  LiftEntryTableItem.swift
//  TheOneRepMax
//
//  Created by Developer on 6/30/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit


class LiftEntryTableItem: NSView {
    
    var liftEntry: LiftEntry!
    var deleteEntryClosure: (()->())!
    
    init(frame frameRect: NSRect, liftEntry: LiftEntry) {
        self.liftEntry = liftEntry
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var deletePopover: NSPopover?

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let tableFont = NSFont(name: "Lucida Grande", size: 20)
        
        var paddingLeft = 20 as CGFloat
        let width = (self.frame.width - paddingLeft) * (1/2)
        var height = self.frame.height
        var x = paddingLeft
        let y = 0 as CGFloat
        
        let maxLabel = NSLabel(frame: NSRect())
        maxLabel.font = tableFont
        maxLabel.stringValue = "\(self.liftEntry.max.integerValue)"
        maxLabel.sizeToFit()
        
        height = maxLabel.frame.height
        
        maxLabel.frame = NSRect(x: x, y: y, width: width, height: height)
        
        // ------------------------------------------------------------------------------ //
        
        x = CGRectGetMaxX(maxLabel.frame)
        
        let dateLabel = NSLabel(frame: NSRect(x: x, y: y, width: width, height: height))
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d"
        dateLabel.font = tableFont
        dateLabel.alignment = .Right
        dateLabel.stringValue = formatter.stringFromDate(self.liftEntry.date)
        
        // ------------------------------------------------------------------------------ //
        
        x = CGRectGetMaxX(dateLabel.frame)
        
        paddingLeft -= 5
        let top = NSPoint(x: paddingLeft, y: CGRectGetMaxY(maxLabel.frame))
        let bottom = NSPoint(x: paddingLeft, y: CGRectGetMinY(maxLabel.frame))
        
        let path = NSBezierPath()
        path.moveToPoint(top)
        path.lineToPoint(bottom)
        NSColor.blackColor().setFill()
        path.stroke()
        
        // ------------------------------------------------------------------------------ //
        
        self.addSubview(maxLabel)
        self.addSubview(dateLabel)
        
        self.addGestureRecognizers()
    }
    
    func addGestureRecognizers() {
        let deleteRecognizer = NSClickGestureRecognizer(target: self, action: Selector("launchDeletePopover"))
        deleteRecognizer.numberOfClicksRequired = 2
        self.addGestureRecognizer(deleteRecognizer)
    }
    
    func launchDeletePopover() {
        if self.deletePopover == nil {
            self.deletePopover = NSPopover()
        }
        
        let optionsViewController = LiftEntryTableItemOptionsViewController()
        optionsViewController.liftEntry = self.liftEntry
        optionsViewController.deleteEntryClosure = self.deleteEntryClosure
        
        self.deletePopover?.contentViewController = optionsViewController
        self.deletePopover?.behavior = .Transient
        
        self.deletePopover?.showRelativeToRect(self.bounds, ofView: self, preferredEdge: .MaxX)
    }
    
}
