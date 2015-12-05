//
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
        
        
        let (success, _) = ORSession.currentSession.signInLocally()
        
        if !success {
            print("no user")
            
            let athlete = ORAthlete.athlete()
            ORAthlete.setCurrentAthlete(athlete)
            
            ORSession.currentSession.localData.save()
        }
    
        ORSession.currentSession.soloStats = ORSoloStats(athlete: ORSession.currentSession.currentAthlete!)
        
        runOnMainThread {
            print("logged in")
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
        
        guard false else { return }
        
        ORSession.currentSession.signInWithCloud { fetchedAthlete, response in
            guard response.success else {
                
                if response.error?.code == 9 {
                    let errorAlertController = UIAlertController(title: "Sign in with iCloud", message: "To use the cloud features of The One Rep Max you must be signed into iCloud on your device.", preferredStyle: .Alert)
                    self.presentViewController(errorAlertController, animated: true, completion: nil)
                }
                
                return
            }
            
            guard let athlete = fetchedAthlete else {
                runOnMainThread {
//                    transition to EditAthlete screen
                }
                return
            }
            
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
