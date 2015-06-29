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

class ORMViewController: NSViewController, NSTextFieldDelegate {
    
    @IBOutlet weak var ormToolContainer: NSView!
    
    @IBOutlet weak var weightField: NSTextField!
    @IBOutlet weak var repsField: NSTextField!
    
    @IBOutlet weak var ormLabel: NSTextField!

    @IBOutlet weak var liftTemplatesSelect: NSPopUpButton!
    
    @IBOutlet weak var liftTemplatesContainer: NSView!
    
    var parentVC: MainViewController!
    
    var session: ORSession!
    var cloudData: ORCloudData!
    
    var liftTemplates = [ORLiftTemplate]()
    
    var weightLifted: Int {
        return NSString(string: self.weightField.stringValue).integerValue
    }
    
    var reps: Int {
        return NSString(string: self.repsField.stringValue).integerValue
    }
    
    var oneRepMax: Int {
        get {
            if self.reps == 0 {
                return 0
            }
            return Int(Float(self.weightLifted * self.reps) * 0.033) + self.weightLifted
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentVC = self.parentViewController! as! MainViewController
        
        self.session = ORSession.currentSession
        self.cloudData = self.session.cloudData
        
        self.ormToolContainer.wantsLayer = true
        self.ormToolContainer.layer?.backgroundColor = NSColor.darkGrayColor().CGColor
        
        self.cloudData.fetchLiftTemplates(self.session) { (response) -> () in
            
            if response.error == nil {
                
                for record in response.results as! [CKRecord] {
                    self.liftTemplates.append(ORLiftTemplate(record: record))
                    
                    runOnMainThread {
                        self.updateHistoryList(self.liftTemplates)
                        self.updateLiftTemplatePopUp(self.liftTemplates)
                    }
                }
                
            } else {
                println(response.error)
            }
            
        }
    }
    
    func updateHistoryList(templates: [ORLiftTemplate]) {
        for (i, template) in enumerate(templates) {
            
            let topPadding = 15 as CGFloat
            let width = self.liftTemplatesContainer.frame.width
            let height = 40 as CGFloat
            let x = 0 as CGFloat
            let y = (height + topPadding) * CGFloat(i)
            
            var button = HistoryTemplateOptionButton(frame: NSRect(x: x, y: y, width: width, height: height), liftTemplate: template)
            
            self.liftTemplatesContainer.addSubview(button)
        }
    }
    
    func updateLiftTemplatePopUp(templates: [ORLiftTemplate]) {
        self.liftTemplatesSelect.removeAllItems()
        self.liftTemplatesSelect.addItemsWithTitles(templates.map { $0.liftName })
    }
    
    func updateOneRepMax() {
        self.ormLabel.stringValue = "\(oneRepMax) lbs."
    }
    
    @IBAction func saveEntryClicked(button: NSButton) {
        var entry = ORLiftEntry()
        entry.weightLifted = self.weightLifted
        entry.reps = self.reps
        entry.maxOut = true
        entry.date = NSDate()
        entry.liftTemplate = self.liftTemplates[self.liftTemplatesSelect.indexOfSelectedItem]
        self.cloudData.save(model: entry) { (response) in
            if response.error != nil {
                println(response.error)
            }
        }
    }
    
    override func controlTextDidChange(notification: NSNotification) {
        let textField = notification.object as! NSTextField
        
        if textField == self.weightField || textField == self.repsField {
            self.updateOneRepMax()
        }
    }
    
}
