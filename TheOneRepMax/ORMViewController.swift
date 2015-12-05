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
            guard self.reps != 0 else { return 0 }
            return Int( (self.weightLifted.floatValue * self.reps.floatValue * 0.033) + self.weightLifted.floatValue )
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.initMenuItems()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        let context = NSManagedObjectContext.contextForCurrentThread()
        let organization = context.crossContextEquivalent(object: self.session.currentOrganization!)
        
        self.liftTemplates = Array(organization.liftTemplates).sort {
            $0.0.liftName.compare($0.1.liftName, options: .CaseInsensitiveSearch, range: nil, locale: nil) == .OrderedAscending
        }
        
        let (defaultTemplates, _) = ORSession.currentSession.localData.fetchObjects(model: ORLiftTemplate.self, predicates: [NSPredicate(key: ORLiftTemplate.Fields.defaultLift.rawValue, comparator: .Equals, value: true)], context: context)
        
        self.liftTemplates.appendContentsOf(defaultTemplates)
        
        self.updateHistoryList(self.liftTemplates)
        self.updateLiftTemplatePopUp(self.liftTemplates)
    }
    
    func initMenuItems() {
        self.messagesMenuItem.clickHandler = {
            let destination = self.parentVC.messagesVC
            destination.organization = self.session.currentOrganization!
            destination.fromViewController = self
            
            self.parentVC.transitionFromViewController(self, toViewController: destination, options: .SlideLeft, completionHandler: nil)
        }
        
        guard ORSession.currentSession.userIsAdmin else {
            if self.setupMenuItem != nil {
                self.setupMenuItem.removeFromSuperview()
            }
            return
        }
        
        self.setupMenuItem.clickHandler = {
            let destination = self.parentVC.setupVC
            destination.organization = self.session.currentOrganization
            destination.fromViewController = self
            
            self.parentVC.transitionFromViewController(self, toViewController: destination, options: .SlideLeft, completionHandler: nil)
        }
    }
    
    func updateHistoryList(templates: [ORLiftTemplate]) {
        let container = NSFlippedView(frame: self.liftTemplatesContainer.frame)
        for (i, template) in templates.enumerate() {
            
            let topPadding = 3 as CGFloat
            let width = self.liftTemplatesContainer.frame.width
            let height = 35 as CGFloat
            let x = (self.liftTemplatesContainer.frame.width - width) * (1/2)
            let y = (height + topPadding) * CGFloat(i)
            
            let button = HistoryTemplateOptionButton(frame: NSRect(x: x, y: y, width: width, height: height), liftTemplate: template)
            button.clickHandler = { template in
                let destinationViewController = self.parentVC.historyVC
                destinationViewController.liftTemplate = template
                destinationViewController.fromViewController = self
                self.parentVC.transitionFromViewController(self, toViewController: destinationViewController, options: .SlideDown, completionHandler: nil)
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
        let entry = ORLiftEntry.entry()
        entry.weightLifted = self.weightLifted
        entry.reps = self.reps
        entry.maxOut = true
        entry.date = NSDate()
        entry.liftTemplate = self.liftTemplates[self.liftTemplatesSelect.indexOfSelectedItem]
        entry.athlete = ORSession.currentSession.currentAthlete!
        entry.organization = ORSession.currentSession.currentOrganization!
        
//        self.cloudData.save(model: entry) { (response) in
//            if !response.success {
//                print(response.error)
//            }
//        }
        self.localData.save()
        
        self.cloudData.syncronizeDataToCloudStore()
    }
    
    override func controlTextDidChange(notification: NSNotification) {
        let textField = notification.object as! NSTextField
        
        if textField == self.weightField || textField == self.repsField {
            self.updateOneRepMax()
        }
    }
    
    @IBAction func backPressed(sender: NSButton) {
        if let destination = self.fromViewController {
            self.parentVC.transitionFromViewController(self, toViewController: destination, options: .SlideRight, completionHandler: nil)
        }
    }
    
}
