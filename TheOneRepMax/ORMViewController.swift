//
//  ORMViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 6/27/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit
import ORMKit

class ORMViewController: ORViewController, NSTextFieldDelegate {
    
    @IBOutlet weak var ormToolContainer: OneRepMaxContainer!
    
    @IBOutlet weak var weightField: NSTextField!
    @IBOutlet weak var repsField: NSTextField!
    
    @IBOutlet weak var ormLabel: NSTextField!

    @IBOutlet weak var liftTemplatesSelect: NSPopUpButton!
    
    @IBOutlet weak var liftTemplatesContainer: NSScrollView!
    
    @IBOutlet weak var messagesMenuItem: MenuItem!
    @IBOutlet weak var setupMenuItem: MenuItem!
    
    var liftTemplates = [ORLiftTemplate]()
    
    var weightLifted: NSNumber {
        return NSNumber(integer: NSString(string: self.weightField.stringValue).integerValue)
    }
    
    var reps: NSNumber {
        return NSNumber(integer: NSString(string: self.repsField.stringValue).integerValue)
    }
    
    var oneRepMax: Int {
        get {
            if self.reps == 0 {
                return 0
            }
            return Int( (self.weightLifted.floatValue * self.reps.floatValue * 0.033) + self.weightLifted.floatValue )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.liftTemplates = Array(self.session.currentOrganization!.liftTemplates).sorted {
            $0.0.liftName.compare($0.1.liftName, options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) == NSComparisonResult.OrderedAscending
        }
        
        self.updateHistoryList(self.liftTemplates)
        self.updateLiftTemplatePopUp(self.liftTemplates)
        
        self.initMenuItems()
    }
    
    func initMenuItems() {
        self.messagesMenuItem.clickHandler = {
            var destination = self.parentVC.messagesVC
            destination.organization = self.session.currentOrganization!
            
            self.parentVC.transitionFromViewController(self, toViewController: destination, options: NSViewControllerTransitionOptions.SlideLeft, completionHandler: nil)
        }
        
        self.setupMenuItem.clickHandler = {
            var destination = self.parentVC.setupVC
            destination.organization = self.session.currentOrganization
            
            self.parentVC.transitionFromViewController(self, toViewController: destination, options: NSViewControllerTransitionOptions.SlideLeft, completionHandler: nil)
        }
    }
    
    func updateHistoryList(templates: [ORLiftTemplate]) {
        var container = NSFlippedView(frame: self.liftTemplatesContainer.frame)
        for (i, template) in enumerate(templates) {
            
            let topPadding = 3 as CGFloat
            let width = self.liftTemplatesContainer.frame.width
            let height = 35 as CGFloat
            let x = (self.liftTemplatesContainer.frame.width - width) * (1/2)
            let y = (height + topPadding) * CGFloat(i)
            
            var button = HistoryTemplateOptionButton(frame: NSRect(x: x, y: y, width: width, height: height), liftTemplate: template)
            button.clickHandler = { template in
                var destinationViewController = self.parentVC.historyVC
                destinationViewController.representedObject = template
                destinationViewController.fromViewController = self
                self.parentVC.transitionFromViewController(self, toViewController: destinationViewController, options: NSViewControllerTransitionOptions.SlideDown, completionHandler: nil)
            }
            
            container.addSubview(button)
            container.frame = NSRect(x: 0, y: 0, width: container.frame.width, height: CGRectGetMaxY(button.frame))
        }
        self.liftTemplatesContainer.documentView = container
    }
    
    func updateLiftTemplatePopUp(templates: [ORLiftTemplate]) {
        self.liftTemplatesSelect.removeAllItems()
        self.liftTemplatesSelect.addItemsWithTitles(templates.map { $0.liftName })
    }
    
    func updateOneRepMax() {
        self.ormLabel.stringValue = "\(oneRepMax) lbs."
    }
    
    @IBAction func saveEntryClicked(button: NSButton) {
        var entry = ORLiftEntry.entry()
        entry.weightLifted = self.weightLifted
        entry.reps = self.reps
        entry.maxOut = true
        entry.date = NSDate()
        entry.liftTemplate = self.liftTemplates[self.liftTemplatesSelect.indexOfSelectedItem]
        entry.athlete = ORSession.currentSession.currentAthlete!
        entry.organization = ORSession.currentSession.currentOrganization!
        self.cloudData.save(model: entry) { (response) in
            if response.error != nil {
                println(response.error)
            }
        }
        self.localData.save()
    }
    
    override func controlTextDidChange(notification: NSNotification) {
        let textField = notification.object as! NSTextField
        
        if textField == self.weightField || textField == self.repsField {
            self.updateOneRepMax()
        }
    }
    
}
