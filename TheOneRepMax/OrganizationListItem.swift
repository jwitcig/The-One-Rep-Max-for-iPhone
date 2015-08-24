//
//  OrganizationListItem.swift
//  TheOneRepMax
//
//  Created by Developer on 6/20/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit

@IBDesignable
class OrganizationListItem: NSView {

    var organization: OROrganization!
    
    private var joinButton: NSButton!
    var viewInfoHandler: ((OROrganization)->())!
    var joinHandler: ((OROrganization)->())!
    
    var infoContainer: NSFlippedView!
    
    var organizationNameLabel: NSTextField!
    var athleteCountLabel: NSTextField!
    
    @IBInspectable var title: String!
    @IBInspectable var subtitle: String!

    @IBInspectable var infoContainerBackgroundColor: NSColor = NSColor.whiteColor()
    
    init(frame frameRect: NSRect, organization: OROrganization) {
        self.organization = organization

        super.init(frame: frameRect)
        
        self.updateProperties()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateProperties() {
        self.title = self.organization.orgName
        if let athleteCount = self.organization.athleteReferences?.count {
            self.subtitle = "\(athleteCount) athletes"
        } else {
            self.subtitle = ""
        }
    }
    
    override func drawRect(dirtyRect: NSRect) {
        
        var x = 0 as CGFloat
        var y = 0 as CGFloat
        var width = self.frame.width * (7/10)
        var height = self.frame.height
        
        self.infoContainer = NSFlippedView(frame: NSRect(x: x, y: y, width: width, height: height))
        self.infoContainer.backgroundColor = self.infoContainerBackgroundColor
        
        x = self.frame.width * (1/20)
        y = self.infoContainer.frame.height * (1/15)
        width = self.infoContainer.frame.width - x
        height = self.infoContainer.frame.height - y
        
        let infoContent = NSFlippedView(frame: NSRect(x: x, y: y, width: width, height: height))
        
        x = 0 as CGFloat
        y = 0 as CGFloat
        width = infoContent.frame.width
        height = infoContent.frame.height * (3/5)
        
        self.organizationNameLabel = NSLabel(frame: NSRect(x: x, y: y, width: width, height: height))
        self.organizationNameLabel.font = NSFont(name: "Lucida Grande", size: 18)
        
        self.organizationNameLabel.stringValue = self.title
        self.organizationNameLabel.backgroundColor = NSColor.clearColor()
        
        width = infoContent.frame.width
        height = infoContent.frame.height - self.organizationNameLabel.frame.height
        x = 0 as CGFloat
        y = self.organizationNameLabel.frame.height
        
        self.athleteCountLabel = NSLabel(frame: NSRect(x: x, y: y, width: width, height: height))
        self.athleteCountLabel.stringValue = self.subtitle
        self.athleteCountLabel.font = NSFont(name: "Lucida Grande", size: 12)
        self.athleteCountLabel.backgroundColor = NSColor.clearColor()
        
        
        width = self.frame.width - self.infoContainer.frame.width
        height = self.frame.height
        x = self.infoContainer.frame.width
        y = 0
        
        self.joinButton = RightRoundedButton(frame: NSRect(x: x, y: y, width: width, height: height))
        self.joinButton.target = self
        self.joinButton.action = Selector("joinPressed:")
        
        infoContent.addSubview(self.organizationNameLabel)
        infoContent.addSubview(self.athleteCountLabel)
        self.infoContainer.addSubview(infoContent)
        self.addSubview(self.infoContainer)
        self.addSubview(self.joinButton)

    }
    
    func joinPressed(button: RightRoundedButton) {
        self.joinHandler(self.organization)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        self.viewInfoHandler(self.organization)
    }
    
}