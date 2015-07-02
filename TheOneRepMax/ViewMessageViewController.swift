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
    
    var message: ORMessage {
        get { return self.representedObject as! ORMessage }
        set { self.representedObject = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/d"
        
        self.titleLabel.stringValue = self.message.title
        self.dateLabel.stringValue = formatter.stringFromDate(self.message.createdDate)
        self.bodyTextView.string = self.message.body
    }
}
