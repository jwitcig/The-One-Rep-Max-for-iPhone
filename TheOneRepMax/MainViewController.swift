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
    var ormVC: ORMViewController!
    var historyVC: HistoryViewController!
    var messagesVC: MessagesViewController!
    var viewMessageVC: ViewMessageViewController!
    var setupVC: SetupViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = NSApplication.sharedApplication().delegate! as!  AppDelegate
        let context = appDelegate.managedObjectContext!
        let session = ORSession.currentSession
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        
        let dataManager = ORDataManager(localDataContext: context, cloudContainer: container, cloudDatabase: publicDatabase)
        
        ORSession.currentSession.localData = ORLocalData(session: session, dataManager: dataManager)
        ORSession.currentSession.cloudData = ORCloudData(session: session, dataManager: dataManager)
        
        ORSession.currentSession.signInWithCloud { (success, error) -> () in
            if success {
                self.instantiateViewControllers()
                self.registerChildViewControllers()
                
                runOnMainThread {
                    self.view.addSubview(self.homeVC.view)
                }
            } else {
                println(error)
            }
        }
    }
    
    func instantiateViewControllers() {
        self.organizationListVC = self.storyboard?.instantiateControllerWithIdentifier("OrganizationListViewController") as! OrganizationListViewController
        self.homeVC = self.storyboard?.instantiateControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.ormVC = self.storyboard?.instantiateControllerWithIdentifier("ORMViewController") as! ORMViewController
        self.historyVC = self.storyboard?.instantiateControllerWithIdentifier("HistoryViewController") as! HistoryViewController
        self.messagesVC = self.storyboard?.instantiateControllerWithIdentifier("MessagesViewController") as! MessagesViewController
        self.viewMessageVC = self.storyboard?.instantiateControllerWithIdentifier("ViewMessageViewController") as! ViewMessageViewController
        self.setupVC = self.storyboard?.instantiateControllerWithIdentifier("SetupViewController") as! SetupViewController
    }
    
    func registerChildViewControllers() {
        self.addChildViewController(self.organizationListVC)
        self.addChildViewController(self.homeVC)
        self.addChildViewController(self.ormVC)
        self.addChildViewController(self.historyVC)
        self.addChildViewController(self.messagesVC)
        self.addChildViewController(self.viewMessageVC)
        self.addChildViewController(self.setupVC)
    }
    
}
