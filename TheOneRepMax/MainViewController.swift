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
    
    var loginVC: LoginViewController!
    var homeVC: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CKContainer.defaultContainer().fetchUserRecordIDWithCompletionHandler { (userRecordId, error) -> Void in
            if error == nil {
                
                
                ORSession.currentSession.currentUserId = userRecordId

                
            } else {
                println(error)
            }
        }
        
        self.instantiateViewControllers()
        self.registerChildViewControllers()
        
        self.view.addSubview(self.loginVC.view)

    
    }
    
    func instantiateViewControllers() {
        self.loginVC = self.storyboard?.instantiateControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.homeVC = self.storyboard?.instantiateControllerWithIdentifier("HomeViewController") as! HomeViewController
        
        self.homeVC.container = CKContainer.defaultContainer()
        self.homeVC.publicDB = self.homeVC.container.publicCloudDatabase
    }
    
    func registerChildViewControllers() {
        self.addChildViewController(self.loginVC)
        self.addChildViewController(self.homeVC)
    }
    
}
