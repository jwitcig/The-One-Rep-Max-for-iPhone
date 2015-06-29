//
//  NSFlippedView.swift
//  TheOneRepMax
//
//  Created by Developer on 6/23/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class NSFlippedView: NSView {

    override var flipped:Bool { get { return true } }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
}
