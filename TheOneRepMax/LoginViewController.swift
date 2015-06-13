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

class LoginViewController: NSViewController {
    
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    
    var parentVC: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ORSession.managedObjectContext.persistentStoreCoordinator = ORSession.persistentStoreCooridnator

        
        self.parentVC = self.parentViewController! as! MainViewController
        
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        
        let container = CKContainer.defaultContainer()
        let publicDB = container.publicCloudDatabase
        
        var delegate = NSApplication.sharedApplication().delegate! as! AppDelegate
        var context = delegate.managedObjectContext!
        
        var template = ORLiftTemplate(context: context)
        template.liftName = "Swag Toss"
        template.isDefault = false
        template.liftDescription = "Lean wit it"
        template.creator = ORSession.currentSession.currentUser!
        template.owner = template.creator
        
        
        var error = NSErrorPointer()
        context.save(error)
        
//        template.save { (record, error) in
//            if error == nil {
//                println("yay")
//            } else {
//                println(error)
//            }
//        }
        
        var entry = ORLiftEntry(context: ORSession.managedObjectContext)
        entry.liftTemplate = template
        entry.maxOut = true
        entry.weightLifted = 341
        entry.reps = 6
//        entry.save { (record, error) in
//            if error == nil {
//                println("yay")
//            } else {
//                println(error)
//            }
//        }

        
    }

    @IBAction func loginPressed(sender: NSButton) {
        let ORUser = "jwitcig"
        let password = "540223"
        
        let credential = NSURLCredential(user: ORUser, password: password, persistence: NSURLCredentialPersistence.None)
        
     
        self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.childViewControllers[1] as! NSViewController, options: NSViewControllerTransitionOptions.SlideLeft, completionHandler: nil)
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

