//
//  NSLabel.swift
//  TheOneRepMax
//
//  Created by Developer on 6/30/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class NSLabel: NSTextField {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.bezeled = false
        self.bordered = false
        self.editable = false
        self.backgroundColor = NSColor.clearColor()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
