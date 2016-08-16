
//  MainViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 9/20/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit

import AWSMobileHubHelper
import RealmSwift

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ORSession.currentSession.soloStats = ORSoloStats(userId: "")
        
        runOnMainThread {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
        
    }
    
}
