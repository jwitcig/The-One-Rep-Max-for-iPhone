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
        
        self.parentVC = self.parentViewController! as! MainViewController
        
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        
        let container = CKContainer.defaultContainer()
        let publicDB = container.publicCloudDatabase
        
        
        var delegate = NSApplication.sharedApplication().delegate! as! AppDelegate
        var context = delegate.managedObjectContext!
        
//        var template = ORLiftTemplate(context: context)
//        template.liftName = "Swag Toss"
//        template.liftName = "Tosser"
//        template.defaultLift = false
//        template.liftDescription = "Lean wit it"
//        template.creator = ORSession.currentSession.currentUser!
//        template.owner = template.creator
        
//        var object = NSEntityDescription.entityForName(ORLiftTemplate.recordType, inManagedObjectContext: context)
//        
//        println(object)
//        
//        var error = NSErrorPointer()
//        context.save(error)
//        
//        var request = NSFetchRequest(entityName: ORLiftTemplate.recordType)
//        request.predicate = NSPredicate(value: true)
//        
//        let results = context.executeFetchRequest(request, error: NSErrorPointer())
//        println(results)
        
//        template.save { (record, error) in
//            if error == nil {
//                println("yay")
//            } else {
//                println(error)
//            }
//        }
        
//        var entry = ORLiftEntry(context: ORSession.managedObjectContext)
//        entry.liftTemplate = template
//        entry.maxOut = true
//        entry.weightLifted = 341
//        entry.reps = 6
//        entry.save { (record, error) in
//            if error == nil {
//                println("yay")
//            } else {
//                println(error)
//            }
//        }

        
    }

    @IBAction func loginPressed(sender: NSButton) {
        let context = ORSession.currentSession.managedObjectContext
        
//        var error = NSErrorPointer()
//        let user = ORUser.signIn(username: usernameField.stringValue, password: passwordField.stringValue, context: context, error: error)
        
        CKContainer.defaultContainer().publicCloudDatabase.performQuery(ORLiftTemplate.query(nil), inZoneWithID: nil, completionHandler: { (results, error) -> Void in
            
            println(results)
            
        })
     
//        self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.childViewControllers[1] as! NSViewController, options: NSViewControllerTransitionOptions.SlideLeft, completionHandler: nil)
    }
    
    @IBAction func signUpPressed(sender: NSButton) {
        let context = ORSession.currentSession.managedObjectContext

        let user = ORUser.signUp(username: usernameField.stringValue, password: passwordField.stringValue, context: context, error: nil)
        
        println(user)
        
    }
    
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

