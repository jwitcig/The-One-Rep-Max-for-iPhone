//
//  ViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/9/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit
import ORMKit

class OrganizationListViewController: NSViewController {
    
    var parentVC: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentVC = self.parentViewController! as! MainViewController
        
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        
        let container = CKContainer.defaultContainer()
        let publicDB = container.publicCloudDatabase
        let athlete = ORSession.currentSession.currentAthlete!
        
        var delegate = NSApplication.sharedApplication().delegate! as! AppDelegate
        var context = delegate.managedObjectContext!
        
        athlete.fetchAssociatedOrganizations { (response) -> () in
            if response.error == nil {
                
            } else {
                println(response.error)
            }
        }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
