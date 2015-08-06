//
//  AssociatedOrganizationListItem.swift
//  TheOneRepMax
//
//  Created by Developer on 6/26/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit

class AssociatedOrganizationListItem: NSFlippedView {
    
    var organization: OROrganization!
    var selectedHandler: ((organization: OROrganization)->())?
    
    init(frame frameRect: NSRect, organization: OROrganization) {
        self.organization = organization
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
       super.init(coder: coder)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)        
        
        let path = NSBezierPath(roundedRect: dirtyRect, xRadius: 14, yRadius: 14)
        
        NSColor.darkGrayColor().setFill()
        path.fill()
        
        let width = self.frame.width * (3/4)
        let height = self.frame.height * (1/2)
        let x = (self.frame.width / 2) - (width / 2)
        let y = (self.frame.height / 2) - (height / 2)
        let orgNameLabel = NSTextField(frame: NSRect(x: x, y: y, width: width, height: height))
        orgNameLabel.bezeled = false
        orgNameLabel.bordered = false
        orgNameLabel.editable = false
        orgNameLabel.stringValue = self.organization.orgName
        orgNameLabel.backgroundColor = NSColor.clearColor()
        orgNameLabel.alignment = .Center
        orgNameLabel.font = NSFont(name: "Lucida Grande", size: 26)
        
        self.addSubview(orgNameLabel)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.selectedHandler?(organization: self.organization)
    }
    
}
