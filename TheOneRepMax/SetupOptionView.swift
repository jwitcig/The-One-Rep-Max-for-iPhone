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
}

class SetupOptionView: NSView, NSTextFieldDelegate {
    
    var parentController: SetupViewController!
    var title: String!
    var type: OROptionType?
    var organization: OROrganization?
    
    var titleContainer = NSFlippedView()
    var valueContainer = NSFlippedView()
    
    var optionValue: AnyObject?
    var textField: ClickableTextField?
    
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
        
        var titleLabel = NSLabel(frame: NSRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        titleLabel.delegate = self
        titleLabel.stringValue = self.title
        titleLabel.font = NSFont(name: "Lucida Grande", size: 22)
        
        self.titleContainer.addSubview(titleLabel)
        
        // -------------------------------------------------------------------------
        
        if let type = self.type {
            switch type {
            
            case .Text:
                self.textField = ClickableTextField(frame: self.valueContainer.bounds)
                self.textField?.delegate = self
                self.textField?.target = self
                self.textField?.action = Selector("textFieldSelected:")
                (self.textField?.cell() as! NSTextFieldCell).wraps = false
                self.textField?.font = NSFont(name: "Lucida Grande", size: 26)
                
                if let value = self.optionValue as? String {
                    self.textField!.stringValue = value as String
                }
                
                self.valueContainer.addSubview(self.textField!)
            }
        }
        
        self.addSubview(self.titleContainer)
        self.addSubview(self.valueContainer)
    }
    
    func textFieldSelected(textField: ClickableTextField) {
        let destination = self.parentController.parentVC.storyboard?.instantiateControllerWithIdentifier("OptionTextInputViewController") as! OptionTextInputViewController
        self.parentController.addChildViewController(destination)
        
        self.parentController.presentViewController(destination, asPopoverRelativeToRect: textField.frame, ofView: textField, preferredEdge: NSMaxXEdge, behavior: NSPopoverBehavior.Transient)
        destination.textValue = textField.stringValue
        destination.baseTextField = textField
    }
    
}

class ClickableTextField: NSTextField {
    
    override func mouseDown(event: NSEvent) {
        self.sendAction(self.action, to: self.target)
    }
    
}