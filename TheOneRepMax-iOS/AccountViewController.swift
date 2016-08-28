//
//  AccountViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 8/25/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth
import FirebaseDatabase

class AccountViewController: ORViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var instructionLabel: UILabel!
    
    // values used to determine if info was updated
    var originalFirstName: String?
    var originalLastName: String?
    
    let databaseRef = FIRDatabase.database().reference()
    var userInfoRef: FIRDatabaseReference?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        emailLabel.text = ""
        instructionLabel.text = ""
        
        guard let user = FIRAuth.auth()?.currentUser else { return }
        
        if user.anonymous {
            guard let signUpViewController = storyboard?.instantiateViewControllerWithIdentifier("SignUpViewController") as? SignUpViewController else { return }
            signUpViewController.successBlock = {
                signUpViewController.dismissViewControllerAnimated(true, completion: nil)
            }
            presentViewController(signUpViewController, animated: true, completion: nil)
            return
        }
        
        userInfoRef = databaseRef.child("users/\(user.uid)")
        
        userInfoRef!.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.originalFirstName = snapshot.value?["first_name"] as? String
            self.originalLastName = snapshot.value?["last_name"] as? String
            
            self.firstNameField.text = snapshot.value?["first_name"] as? String
            self.lastNameField.text = snapshot.value?["last_name"] as? String
            self.emailLabel.text = snapshot.value?["email"] as? String
            
            self.instructionLabel.text = "Update your info‼️"

            if self.originalFirstName != nil && self.originalLastName != nil
                && self.originalFirstName != "" && self.originalLastName != "" {
                self.instructionLabel.text = "You're all good here👍🏽"
            }
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if firstNameField.text != originalFirstName ||
            lastNameField.text != originalLastName {
            updateUserInfo()
        }
    }
    
    func updateUserInfo() {
        userInfoRef?.updateChildValues([
            "first_name": firstNameField.text ?? "",
            "last_name": lastNameField.text ?? "",
        ])
    }
    
}
