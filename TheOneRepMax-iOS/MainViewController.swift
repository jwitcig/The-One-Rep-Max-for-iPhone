
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
        
        let session = ORSession.currentSession
        
        
        let (success, _) = session.signInLocally()
        
        if !success {
            print("no user")
            
            let athlete = ORAthlete.athlete()
            athlete.firstName = "suh dude"
            athlete.lastName = "nuttin"
            athlete.username = athlete.fullName
            
            session.localData.save()
            ORAthlete.setCurrentAthlete(athlete)
        }
        
        session.soloStats = ORSoloStats(athlete: session.currentAthlete!)
        
        
        runOnMainThread {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
        
    }
    
}
