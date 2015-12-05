//
//  HomeViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 10/21/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import ORMKitiOS
import CoreData

class HomeViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var repsField: UITextField!
    
    @IBOutlet weak var ormLabel: UILabel!
    
    @IBOutlet weak var saveMaxButton: UIButton!
    
    private var organization: OROrganization!
    var organizationID: NSManagedObjectID!
    
    var weightLifted: Int {
        guard let value = self.weightField.text else { return 0 }
        guard let integer = Int(value) else { return 0 }
        return integer
    }
    
    var reps: Int {
        guard let value = self.repsField.text else { return 0 }
        guard let integer = Int(value) else { return 0 }
        return integer
    }
    
    var oneRepMax: Int {
        return ORStats.oneRepMax(weightLifted: self.weightLifted, reps: self.reps)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        guard let organization = NSManagedObjectContext.contextForCurrentThread().objectRegisteredForID(self.organizationID) as? OROrganization else {
//            return
//        }
//        self.organization = organization
        
//        self.displayOrganizationInfo()
        
        self.weightField.addTarget(self, action: Selector("textFieldTextChanged:"), forControlEvents: UIControlEvents.EditingChanged)
        self.repsField.addTarget(self, action: Selector("textFieldTextChanged:"), forControlEvents: UIControlEvents.EditingChanged)
        
//        ORSession.currentSession.cloudData.syncronizeDataToLocalStore {
//            guard $0.success else { return }
//                ORSession.currentSession.cloudData.fetchMessages(organization: organization) { (messages, response) in
//                  guard response.success else { print(response.error); return }
//                ORSession.currentSession.localData.save(context: response.currentThreadContext)
//            }
//        }
    }
    
    func displayOrganizationInfo() {
        self.navigationItem.title = self.organization.orgName
    }
    
    func updateSaveButtonStatus(oneRepMax: Int) {
        if oneRepMax == 0 {
            self.saveMaxButton.enabled = false
        } else {
            self.saveMaxButton.enabled = true
        }
    }
    
    @IBAction func saveMaxPressed(sender: UIButton) {
        
        
    }
    
    func textFieldTextChanged(notification: NSNotification) {
        let oneRepMax = self.oneRepMax
        
        self.updateSaveButtonStatus(oneRepMax)
        self.ormLabel.text = "[ \(oneRepMax) lbs. ]"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SaveMaxSegue" {
            let saveMaxViewController = segue.destinationViewController as! SaveMaxViewController
            
            saveMaxViewController.organization = ORSession.currentSession.currentOrganization
            saveMaxViewController.weightLifted = self.weightLifted
            saveMaxViewController.reps = self.reps
        }
    }

}
