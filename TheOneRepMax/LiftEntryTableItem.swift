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
    
    var liftEntry: ORLiftEntry!
    
    init(frame frameRect: NSRect, liftEntry: ORLiftEntry) {
        self.liftEntry = liftEntry
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        let tableFont = NSFont(name: "Lucida Grande", size: 20)

        var width = self.frame.width * (1/3)
        var height = self.frame.height
        var x = 0 as CGFloat
        var y = 0 as CGFloat
        
        var maxLabel = NSLabel(frame: NSRect(x: x, y: y, width: width, height: height))
        maxLabel.font = tableFont
        maxLabel.stringValue = "\(self.liftEntry.max)"
        
        // ------------------------------------------------------------------------------ //
        
        x = self.frame.width * (2/3)
        
        var dateLabel = NSLabel(frame: NSRect(x: x, y: y, width: width, height: height))
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d"
        dateLabel.font = tableFont
        dateLabel.alignment = .RightTextAlignment
        dateLabel.stringValue = formatter.stringFromDate(self.liftEntry.date)
        
        // ------------------------------------------------------------------------------ //
        
        
        x = CGRectGetMaxX(dateLabel.frame)
        
        
        
        
        // ------------------------------------------------------------------------------ //
        
        self.addSubview(maxLabel)
        self.addSubview(dateLabel)
        
    }
    
}
