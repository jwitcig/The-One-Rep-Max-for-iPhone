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
    var editAthleteInfoVC: EditAthleteInfoViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerAsMainViewController()
        
        let appDelegate = NSApplication.sharedApplication().delegate! as!  AppDelegate
        let context = appDelegate.managedObjectContext!
        let session = ORSession.currentSession
        let container = CKContainer.defaultContainer()
        let publicDatabase = container.publicCloudDatabase
        let dataManager = ORDataManager(localDataContext: context, cloudContainer: container, cloudDatabase: publicDatabase)
        
        ORSession.currentSession.localData = ORLocalData(session: session, dataManager: dataManager)
        ORSession.currentSession.cloudData = ORCloudData(session: session, dataManager: dataManager)
        
        ORSession.currentSession.signInWithCloud { fetchedAthlete, response in
            guard response.success else { return }
            
            self.instantiateViewControllers()
            self.registerChildViewControllers()
            
            guard let athlete = fetchedAthlete else {
                runOnMainThread {
                    self.view.addSubview(self.editAthleteInfoVC.view)
                }
                
                return
            }
            
            ORSession.currentSession.soloStats = ORSoloStats(athlete: ORSession.currentSession.currentAthlete!)
            
            runOnMainThread {
                self.view.addSubview(self.homeVC.view)
            }
        }
    }
    
    func registerAsMainViewController() {
        let delegate = NSApplication.sharedApplication().delegate as! AppDelegate
        delegate.mainViewController = self
    }
    
    func instantiateViewControllers() {
        self.organizationListVC = self.storyboard?.instantiateControllerWithIdentifier("OrganizationListViewController") as! OrganizationListViewController
        self.homeVC = self.storyboard?.instantiateControllerWithIdentifier("HomeViewController") as! HomeViewController
        self.ormVC = self.storyboard?.instantiateControllerWithIdentifier("ORMViewController") as! ORMViewController
        self.historyVC = self.storyboard?.instantiateControllerWithIdentifier("HistoryViewController") as! HistoryViewController
        self.messagesVC = self.storyboard?.instantiateControllerWithIdentifier("MessagesViewController") as! MessagesViewController
        self.viewMessageVC = self.storyboard?.instantiateControllerWithIdentifier("ViewMessageViewController") as! ViewMessageViewController
        self.setupVC = self.storyboard?.instantiateControllerWithIdentifier("SetupViewController") as! SetupViewController
        self.editAthleteInfoVC = self.storyboard?.instantiateControllerWithIdentifier("EditAthleteInfoViewController") as! EditAthleteInfoViewController

    }
    
    func registerChildViewControllers() {
        self.addChildViewController(self.organizationListVC)
        self.addChildViewController(self.homeVC)
        self.addChildViewController(self.ormVC)
        self.addChildViewController(self.historyVC)
        self.addChildViewController(self.messagesVC)
        self.addChildViewController(self.viewMessageVC)
        self.addChildViewController(self.setupVC)
        self.addChildViewController(self.editAthleteInfoVC)
    }
    
}
