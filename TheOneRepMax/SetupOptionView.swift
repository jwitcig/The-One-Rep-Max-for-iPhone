//
//  SetupOptionView.swift
//  TheOneRepMax
//
//  Created by Developer on 7/5/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit

public enum OROptionType {
    case Text
    case Custom
}

class SetupOptionView: NSView, NSTextFieldDelegate {
    
    var parentController: SetupViewController!
    var title: String!
    var type: OROptionType?
    var organization: OROrganization?
    
    var titleContainer = NSFlippedView()
    var valueContainer = NSFlippedView()
    
    var optionValue: AnyObject?
    var valueLabel: NSLabel!
    
    var editButton: NSButton!
    
    init(frame frameRect: NSRect, title: String, type: OROptionType, organization: OROrganization?, value: AnyObject?) {
        self.title = title
        self.type = type
        self.organization = organization
        self.optionValue = value
        super.init(frame: frameRect)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        var width = self.frame.width * (1/2)
        var height = self.frame.height
        var x = 0 as CGFloat
        var y = 0 as CGFloat
        
        self.titleContainer.frame = NSRect(x: x, y: y, width: width, height: height)
        
        width = self.frame.width - self.titleContainer.frame.width
        x = CGRectGetMaxX(self.titleContainer.frame)
        self.valueContainer.frame = NSRect(x: x, y: y, width: width, height: height)
        
        // -------------------------------------------------------------------------
        
        let titleLabel = NSLabel(frame: NSRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        titleLabel.delegate = self
        titleLabel.stringValue = self.title
        titleLabel.font = NSFont(name: "Lucida Grande", size: 22)
        
        self.titleContainer.addSubview(titleLabel)
        
        // -------------------------------------------------------------------------
        
        
        width = self.valueContainer.frame.width * (4/5)
        height = self.valueContainer.frame.height
        
        self.valueLabel = NSLabel(frame: NSRect(origin: NSZeroPoint, size: NSSize(width: width, height: height)))
        self.valueLabel.font = NSFont(name: "Lucida Grande", size: 26)
        self.valueLabel.lineBreakMode = .ByTruncatingTail
        (self.valueLabel.cell as! NSTextFieldCell).wraps = false
        
        if let value = self.optionValue as? String {
            self.valueLabel.stringValue = value as String
        }
        self.valueContainer.addSubview(self.valueLabel!)
        
        let leftPadding = 10 as CGFloat
        width = self.valueContainer.frame.width - self.valueLabel.frame.width - leftPadding
        height = self.valueContainer.frame.height
        x = CGRectGetMaxX(self.valueLabel!.frame) + leftPadding
        y = 0 as CGFloat
        self.editButton = NSButton(frame: NSRect(x: x, y: y, width: width, height: height))
        self.editButton.title = "edit"
        self.editButton.bezelStyle = NSBezelStyle.RoundRectBezelStyle
        self.editButton.target = self
        self.editButton.action = Selector("editClicked:")
        self.valueContainer.addSubview(self.editButton)
        
        self.addSubview(self.titleContainer)
        self.addSubview(self.valueContainer)
    }
    
    func editClicked(editButton: NSButton) {
        
        if let type = self.type {
            switch type {
                
            case .Text:
                let destination = self.parentController.parentVC.storyboard?.instantiateControllerWithIdentifier("OptionTextInputViewController") as! OptionTextInputViewController
                self.parentController.addChildViewController(destination)
                
                self.parentController.presentViewController(destination, asPopoverRelativeToRect: editButton.bounds, ofView: editButton, preferredEdge: NSRectEdge.MaxX, behavior: NSPopoverBehavior.Transient)
                
                destination.textValue = self.valueLabel!.stringValue
                destination.baseTextField = self.valueLabel
                
            case .Custom:
                let destination = self.parentController.parentVC.storyboard?.instantiateControllerWithIdentifier("OptionCustomInputViewController") as! OptionCustomInputViewController
                self.parentController.addChildViewController(destination)
                
                self.parentController.presentViewController(destination, asPopoverRelativeToRect: editButton.bounds, ofView: editButton, preferredEdge: NSRectEdge.MaxX, behavior: NSPopoverBehavior.Transient)
                
                destination.customView = self.optionValue as? NSView
            }
        }
    }
    
}

class ClickableTextField: NSTextField {
    
    override func mouseDown(event: NSEvent) {
        self.sendAction(self.action, to: self.target)
    }
    
}