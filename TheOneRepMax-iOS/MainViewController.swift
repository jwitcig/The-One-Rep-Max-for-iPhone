//
//  MainViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 9/20/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import ORMKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ORSession.currentSession.signInWithCloud { fetchedAthlete, response in
            guard response.success else {
                print("Error signing in: \(response.error)")
                return
            }
            
            guard let athlete = fetchedAthlete else {
                runOnMainThread {
//                    transition to EditAthlete screen
                }
                return
            }
            ORSession.currentSession.soloStats = ORSoloStats(athlete: ORSession.currentSession.currentAthlete!)
            
            runOnMainThread {
                self.performSegueWithIdentifier("LoginSegue", sender: self)
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
