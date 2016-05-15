//
//  EditAthleteInfoViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 9/5/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit

class EditAthleteInfoViewController: ORViewController {
    
    var athlete: Athlete {
        return self.session.currentAthlete != nil ? self.session.currentAthlete! : Athlete.athlete()
    }
    
    @IBOutlet weak var firstNameField: NSTextField!
    @IBOutlet weak var lastNameField: NSTextField!
    
    var firstName: String {
        get { return self.firstNameField.stringValue }
        set { self.firstNameField.stringValue = newValue }
    }
    
    var lastName: String {
        get { return self.lastNameField.stringValue }
        set { self.lastNameField.stringValue = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstName = self.athlete.firstName
        self.lastName = self.athlete.lastName
    }
    
    @IBAction func continuePressed(button: NSButton) {
        self.writeDataToModel()
        
        self.localData.save()
        self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.homeVC, options: .SlideLeft, completionHandler: nil)
    }
    
}
