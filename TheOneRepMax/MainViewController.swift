//
//  MainViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit
import ORMKit

class MainViewController: NSViewController {
    
    var organizationListVC: OrganizationListViewController!
    var homeVC: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = NSApplication.sharedApplication().delegate! as! AppDelegate
        let context = appDelegate.managedObjectContext!
        ORSession.currentSession.managedObjectContext = context

        
        let (success, athlete) = ORAthlete.signInLocally()
        if success {
            self.instantiateViewControllers()
            self.registerChildViewControllers()
            
            self.view.addSubview(self.organizationListVC.view)
        }
    }
    
    func instantiateViewControllers() {
        self.organizationListVC = self.storyboard?.instantiateControllerWithIdentifier("OrganizationListViewController") as! OrganizationListViewController
        self.homeVC = self.storyboard?.instantiateControllerWithIdentifier("HomeViewController") as! HomeViewController
        
        self.homeVC.container = CKContainer.defaultContainer()
        self.homeVC.publicDB = self.homeVC.container.publicCloudDatabase
    }
    
    func registerChildViewControllers() {
        self.addChildViewController(self.organizationListVC)
        self.addChildViewController(self.homeVC)
    }
    
}
