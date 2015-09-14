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
    
    var athlete: ORAthlete {
        return self.session.currentAthlete != nil ? self.session.currentAthlete! : ORAthlete.athlete()
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
    
    func writeDataToModel() {
        guard let userRecordName = NSUserDefaults.standardUserDefaults()["currentUserRecordName"] as? String else {
            return
        }

        self.athlete.userRecordName = userRecordName
        self.athlete.firstName = self.firstName
        self.athlete.lastName = self.lastName
    }
    
    @IBAction func continuePressed(button: NSButton) {
        self.writeDataToModel()
        
        self.localData.save()
        self.cloudData.syncronizeDataToCloudStore {
            guard $0.success else { return }
            
            runOnMainThread {
                self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.homeVC, options: .SlideLeft, completionHandler: nil)
            }
        }
    }
    
}
