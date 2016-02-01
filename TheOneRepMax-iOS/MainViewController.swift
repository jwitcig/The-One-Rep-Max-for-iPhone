
//  MainViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 9/20/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import ORMKitiOS

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ORSession.currentSession.initDefaultData()
        
        let (success, _) = ORSession.currentSession.signInLocally()

        if !success {
            print("no user")
            
            let athlete = ORAthlete.athlete()
            athlete.firstName = "Jonah"
            athlete.lastName = "Witcig"
            athlete.username = "jwitcig"
            
            ORSession.currentSession.localData.save()
            ORAthlete.setCurrentAthlete(athlete)
        }
    
        ORSession.currentSession.soloStats = ORSoloStats(athlete: ORSession.currentSession.currentAthlete!)
        
        runOnMainThread {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
        
        
    }
    
}
