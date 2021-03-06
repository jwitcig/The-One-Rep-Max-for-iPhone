//
//  ORMControlsViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 12/19/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit



protocol OneRepMaxDelegate {
    func oneRepMaxDidChange(oneRepMax: Int, weightLifted: Int, reps: Int)
}

class ORMControlsViewController: UIViewController, UITextFieldDelegate {

    var homeViewController: HomeViewController {
        return self.parentViewController! as! HomeViewController
    }
    
    var oneRepMaxDelegates: [OneRepMaxDelegate] = []
    
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var repsStepper: UIStepper!
    
    @IBOutlet weak var repsDisplay: UILabel!
    
    var weightLifted: Int {
        get {
            guard let value = self.weightField.text else { return 0 }
            guard let integer = Int(value) else { return 0 }
            return integer
        }
        
        set {
            weightField.text = String(newValue)
            callbackDelegatesOneRepMaxDidChange()
        }
    }
    
    var reps: Int {
        get {
            return Int(repsStepper.value)
        }
        
        set {
            repsStepper.value = Double(newValue)
            updateRepsDisplay()
            callbackDelegatesOneRepMaxDidChange()
        }
    }
    
    var oneRepMax: Int {
        return Entry.oneRepMax(weightLifted: weightLifted, reps: reps)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ORMControlsViewController.weightLiftedFieldTextDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: weightField)
    }
    
    @IBAction func repsChanged(stepper: UIStepper) {
        updateRepsDisplay()
        callbackDelegatesOneRepMaxDidChange()
    }
    
    @IBAction func weightLiftedFieldTextDidChange(notification: NSNotification) {
        callbackDelegatesOneRepMaxDidChange()
    }
    
    func updateRepsDisplay() {
        if reps == 1 {
            repsDisplay.text = "\(reps) rep"
            return
        }
        repsDisplay.text = "\(reps) reps"
    }
    
    func addDelegate(delegate: OneRepMaxDelegate) {
        oneRepMaxDelegates.append(delegate)
    }
    
    func callbackDelegatesOneRepMaxDidChange() {
        for delegate in oneRepMaxDelegates {
            delegate.oneRepMaxDidChange(self.oneRepMax, weightLifted: weightLifted, reps: reps)
        }
        
        let userInfo: [NSObject: AnyObject] = [OneRepMaxNotificationDataKey.OneRepMax.rawValue: oneRepMax]
        NSNotificationCenter.defaultCenter().postNotificationName(OneRepMaxNotificationType.OneRepMax.OneRepMaxDidChange.rawValue, object: nil, userInfo: userInfo)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        weightField.resignFirstResponder()
    }

}
