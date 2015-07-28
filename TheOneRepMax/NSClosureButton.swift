//
//  NSClosureButton.swift
//  TheOneRepMax
//
//  Created by Developer on 7/18/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class NSClosureButton: NSButton {
    
    var clickHandlerClosure: (()->())? {
        didSet {
            self.target = self
            self.action = Selector("runClickHandlerClosure")
        }
    }
    
    func runClickHandlerClosure() {
        self.clickHandlerClosure?()
    }
    
}
