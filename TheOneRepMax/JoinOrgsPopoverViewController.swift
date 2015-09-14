//
//  JoinOrgsPopoverViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 8/28/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import Cocoa

class JoinOrgsPopoverViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func joinPressed(sender: NSButton) {
        
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.mainViewController.transitionFromViewController(self.parentViewController!, toViewController: appDelegate.mainViewController.organizationListVC, options: NSViewControllerTransitionOptions.Crossfade) {
            
            self.dismissController(self)
        }
    }
    
}
