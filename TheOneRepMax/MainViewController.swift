//
//  MainViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    var loginVC: LoginViewController!
    var homeVC: HomeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.instantiateViewControllers()
        self.registerChildViewControllers()
        
        self.view.addSubview(self.loginVC.view)
    }
    
    func instantiateViewControllers() {
        self.loginVC = self.storyboard?.instantiateControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.homeVC = self.storyboard?.instantiateControllerWithIdentifier("HomeViewController") as! HomeViewController
    }
    
    func registerChildViewControllers() {
        self.addChildViewController(self.loginVC)
        self.addChildViewController(self.homeVC)
    }
    
}
