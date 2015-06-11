//
//  BackgroundView.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class BackgroundView: NSView {

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
        
        self.layer?.backgroundColor = NSColor.lightGrayColor().CGColor
        
        self.autoresizingMask = NSAutoresizingMaskOptions.ViewWidthSizable | NSAutoresizingMaskOptions.ViewHeightSizable

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.wantsLayer = true
        
        self.layer?.backgroundColor = NSColor.lightGrayColor().CGColor
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

    }
    
}
