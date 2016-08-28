//
//  SignInViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 8/23/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

class SignUpViewController: ORViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var continueButton: UIBarButtonItem!
    
    var email: String { return emailField.text ?? "" }
    var password: String { return passwordField.text ?? "" }
    
    var successBlock: (()->())?

    var linkingAccount = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateContinueButton()
        
        emailField.addTarget(self, action: #selector(SignUpViewController.textFieldTextDidChange(_:)), forControlEvents: .EditingChanged)
        passwordField.addTarget(self, action: #selector(SignUpViewController.textFieldTextDidChange(_:)), forControlEvents: .EditingChanged)
        
        let alert = UIAlertController(title: "Create a new account?", message: "You can create a new account or link and existing login to your current data.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Link", style: .Default, handler: { action in
            self.linkingAccount = true
        }))
        alert.addAction(UIAlertAction(title: "Create", style: .Default, handler: { action in
            self.linkingAccount = false
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateContinueButton() {
        continueButton.enabled = email != "" && password != ""
    }
    
    @IBAction func linkTapped(sender: AnyObject) {
        let callback: FIRAuthResultCallback = { user, error in
            guard let user = user where error == nil else {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .Alert)
                
                switch FIRAuthErrorCode(rawValue: error!.code) {
                
                case .Some(.ErrorCodeNetworkError):
                alert.title =  "No internet connection!"
                alert.message = "Gotta have it!"
                
                case .Some(.ErrorCodeEmailAlreadyInUse):
                alert.title = "Email already in use"
                alert.message = "Try another one!"
                
                case .Some(.ErrorCodeWeakPassword):
                alert.title = "Password to weak"
                alert.message = "Try somthing with a little more meat!"
                    
                case .Some(.ErrorCodeInvalidEmail):
                alert.title = "Invalid email"
                alert.message = "Your email format is a little off!"
                
                default:
                alert.title = "An error has occured😕"
                alert.message = "Give it another go."
                }
                alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            let databaseRef = FIRDatabase.database().reference()
            let userInfoRef = databaseRef.child("users/\(user.uid)")
            userInfoRef.updateChildValues(["email": self.email])
            
            let alert = UIAlertController(title: "You're all good!", message: "Your data is now linked to this email. Get to work!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Awesome", style: .Default, handler: { action in
                self.dismissViewControllerAnimated(true, completion: nil)
                self.successBlock?()
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if linkingAccount {
            guard let currentUser = FIRAuth.auth()?.currentUser else { return }
            linkAccount(withUser: currentUser, callback: callback)
        } else {
            createAccount(callback: callback)
        }
    }

    func linkAccount(withUser user: FIRUser, callback: FIRAuthResultCallback) {
        let accountCredentials = FIREmailPasswordAuthProvider.credentialWithEmail(email, password: password)
        user.linkWithCredential(accountCredentials, completion: callback)
    }
    
    func createAccount(callback callback: FIRAuthResultCallback) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: callback)
    }

    func textFieldTextDidChange(textField: UITextField) {
        updateContinueButton()
    }
    
}
