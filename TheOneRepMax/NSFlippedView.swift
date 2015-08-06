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
}

class NSFlippedScrollView: NSScrollView {
    override var flipped:Bool { get { return true } }
}

extension NSView {
    
    var backgroundColor: NSColor? {
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.CGColor
        }
        get { return nil }
    }
    
}