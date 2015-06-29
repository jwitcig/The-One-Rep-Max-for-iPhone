//
//  OrganizationListItem.swift
//  TheOneRepMax
//
//  Created by Developer on 6/20/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit

class OrganizationListItem: NSView {
    
    let organization: OROrganization
    
    private var joinButton: NSButton!
    var viewInfoHandler: ((OROrganization)->())!
    var joinHandler: ((OROrganization)->())!
    
    init(frame frameRect: NSRect, organization: OROrganization) {
        self.organization = organization
        
        super.init(frame: frameRect)
        
        var x = 0 as CGFloat
        var y = 0 as CGFloat
        var width = self.frame.width * (7/10)
        var height = self.frame.height
        
        
        var infoContainer = NSFlippedView(frame: NSRect(x: x, y: y, width: width, height: height))
        infoContainer.wantsLayer = true
        infoContainer.layer?.backgroundColor = NSColor.lightGrayColor().CGColor
        
        x = self.frame.width * (1/20)
        y = infoContainer.frame.height * (1/15)
        width = infoContainer.frame.width - x
        height = infoContainer.frame.height - y
        
        var infoContent = NSFlippedView(frame: NSRect(x: x, y: y, width: width, height: height))
        
        x = 0 as CGFloat
        y = 0 as CGFloat
        width = infoContent.frame.width
        height = infoContent.frame.height * (3/5)
        
        var orgNameLabel = NSTextField(frame: NSRect(x: x, y: y, width: width, height: height))
        orgNameLabel.bezeled = false
        orgNameLabel.editable = false
        orgNameLabel.bordered = false
        orgNameLabel.font = NSFont(name: "Lucida Grande", size: 18)
        orgNameLabel.stringValue = organization.orgName
        orgNameLabel.backgroundColor = NSColor.clearColor()
        
        width = infoContent.frame.width
        height = infoContent.frame.height - orgNameLabel.frame.height
        x = 0 as CGFloat
        y = orgNameLabel.frame.height
        
        var athleteCountLabel = NSTextField(frame: NSRect(x: x, y: y, width: width, height: height))
        athleteCountLabel.bezeled = false
        athleteCountLabel.editable = false
        athleteCountLabel.bordered = false
        athleteCountLabel.stringValue = "\(organization.athletes.count) athletes"
        athleteCountLabel.font = NSFont(name: "Lucida Grande", size: 12)
        athleteCountLabel.backgroundColor = NSColor.clearColor()
        
        
        width = self.frame.width - infoContainer.frame.width
        height = self.frame.height
        x = infoContainer.frame.width
        y = 0
        
        self.joinButton = RightRoundedButton(frame: NSRect(x: x, y: y, width: width, height: height))
        self.joinButton.target = self
        self.joinButton.action = Selector("joinPressed:")
        
        infoContent.addSubview(orgNameLabel)
        infoContent.addSubview(athleteCountLabel)
        infoContainer.addSubview(infoContent)
        self.addSubview(infoContainer)
        self.addSubview(self.joinButton)
    }
    
    required init?(coder: NSCoder) {
        self.organization = OROrganization()
        super.init(coder: coder)
    }
    
    func joinPressed(button: RightRoundedButton) {
        self.joinHandler(self.organization)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.viewInfoHandler(self.organization)
    }
    
}