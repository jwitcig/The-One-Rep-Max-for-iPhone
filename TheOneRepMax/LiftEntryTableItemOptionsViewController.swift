//
//  LiftEntryTableItemOptionsViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 7/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit

extension NSButton {
    
    var textColor: NSColor {
        get { return NSColor.clearColor() }
        set {
            let attributedTitle = NSMutableAttributedString(attributedString: self.attributedTitle)
            let titleRange = NSMakeRange(0, self.title.characters.count)
            
            attributedTitle.addAttribute(NSForegroundColorAttributeName, value: newValue, range: titleRange)
            self.setButtonType(.MomentaryPushInButton)
            self.attributedTitle = attributedTitle
        }
    }
    
}

class LiftEntryTableItemOptionsViewController: NSViewController {

    @IBOutlet var deleteButton: NSClosureButton!
    
    override var nibName: String {
        return "LiftEntryTableItemOptionsViewController"
    }
    
    var liftEntry: LiftEntry!
    var deleteEntryClosure: (()->())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.deleteButton.clickHandlerClosure = self.deleteEntryClosure
        
//        (self.deleteButton.cell() as? NSButtonCell)?.backgroundColor = NSColor.redColor()
//        (self.deleteButton.cell() as? NSButtonCell)?.highlighted = true
//        (self.deleteButton.cell() as? NSButtonCell)?.highlightsBy = NSCellStyleMask.PushInCellMask

        
//        self.deleteButton.wantsLayer = true
//        self.deleteButton.layer?.backgroundColor = NSColor.redColor().CGColor
//        self.view.wantsLayer = true
//        self.view.layer?.backgroundColor = NSColor.lightGrayColor().CGColor
//        
//        self.deleteButton.textColor = NSColor.blackColor()
//        self.deleteButton.alignment = .CenterTextAlignment
    }
    
    
}
