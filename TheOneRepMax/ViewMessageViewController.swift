//
//  ViewMessageViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 7/2/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit

class ViewMessageViewController: ORViewController {
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet var bodyTextView: NSTextView!
    
    @IBOutlet weak var postButton: NSButton!
    
    var message: ORMessage {
        get { return self.representedObject as! ORMessage }
        set { self.representedObject = newValue }
    }
    
    var editing = false
    
    func setEditingMode(mode: Bool) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d"
        
        if self.editing {
            self.titleLabel.editable = true
            self.bodyTextView.editable = true
            
            self.titleLabel.stringValue = ""
            self.dateLabel.stringValue = formatter.stringFromDate(NSDate())
            self.bodyTextView.string = "message body"
            
            self.postButton.hidden = false
            
        } else {
            self.titleLabel.editable = false
            self.bodyTextView.editable = false
            
            self.titleLabel.stringValue = self.message.title
            self.dateLabel.stringValue = formatter.stringFromDate(self.message.createdDate)
            self.bodyTextView.string = self.message.body
            
            self.postButton.hidden = true
        }
    }
    
    override func viewWillAppear() {
        self.setEditingMode(self.editing)
    }
    
    @IBAction func postPressed(button: NSButton) {
        if let athlete = ORSession.currentSession.currentAthlete {
            
            if let organization = ORSession.currentSession.currentOrganization {
                self.message.organization = organization
            }
            self.message.title = self.titleLabel.stringValue
            self.message.body = self.bodyTextView.string!
            self.message.creator = athlete
            self.message.createdDate = NSDate()
            
            self.cloudData.save(model: self.message) { (response) -> () in
                if response.error == nil {
                    runOnMainThread {
                        self.parentVC.messagesVC.messages.append(self.message)
                        self.parentVC.messagesVC.displayMessages(self.parentVC.messagesVC.messages)
                        self.presentingViewController?.dismissViewController(self)
                    }
                } else {
                    print(response.error)
                }
            }
        }
    }
}
