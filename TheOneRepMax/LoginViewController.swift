//
//  ViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/9/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {
    
    @IBOutlet weak var usernameField: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    
    var parentVC: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentVC = self.parentViewController! as! MainViewController
        
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
    }

    @IBAction func loginPressed(sender: NSButton) {
        let user = "jwitcig"
        let password = "540223"
        
        let credential = NSURLCredential(user: user, password: password, persistence: NSURLCredentialPersistence.None)
        
     
        self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.childViewControllers[1] as! NSViewController, options: NSViewControllerTransitionOptions.SlideLeft, completionHandler: nil)
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

