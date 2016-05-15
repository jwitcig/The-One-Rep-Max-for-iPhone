
//  MainViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 9/20/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit

import RealmSwift

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session = ORSession.currentSession
        
        let (success, _) = session.signInLocally()
        
        if !success {
            print("no user")
            
            let athlete = Athlete()
            athlete.firstName = ""
            athlete.lastName = ""
            
            let realm = try! Realm()
            try! realm.write {
                realm.add(athlete)
            }
            
            Athlete.setCurrentAthlete(athlete)
        }
        
        session.soloStats = ORSoloStats(athlete: session.currentAthlete!)
        
        runOnMainThread {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
        
    }
    
}
