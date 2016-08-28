//
//  SaveMaxViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 10/23/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import Firebase
import FirebaseAuth
import RealmSwift

import SwiftTools

class SaveMaxViewController: ORViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var factorsLabel: UILabel!
    
    @IBOutlet weak var templatePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var optionsScrollView: UIScrollView!
    
    var weightLifted: Int!
    var reps: Int!
    
    var lifts = [Lift]() {
        didSet {
            lifts.sortInPlace {$0.0.name<$0.1.name}
            templatePicker.reloadAllComponents()
            templatePicker.selectRow(1, inComponent: 0, animated: true)
        }
    }
    
    var liftPickerTitles: [String] {
        return ["new lift"] + lifts.map{$0.name}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateLabels()
        
        let database = FIRDatabase.database().reference()
        let liftsRef = database.child("categories/Weight Lifting").queryOrderedByChild("type").queryEqualToValue("entry")
        
        liftsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            self.lifts = snapshot.children
                                    .map { Lift(snapshot: $0 as! FIRDataSnapshot) }
                                    .sort { $0.0.name < $0.1.name }
        })
    }
    
    func updateLabels() {
        let max = Entry.oneRepMax(weightLifted: weightLifted, reps: reps)
        self.maxLabel.text = "\(max) lbs."
        
        if reps == 1 {
            self.factorsLabel.text = "[\(weightLifted) lbs. | \(reps) rep]"
        } else {
            self.factorsLabel.text = "[\(weightLifted) lbs. | \(reps) reps]"
        }
    }
    
    @IBAction func changeDatePressed(button: UIBarButtonItem) {
        scrollToOptionPage(1)
    }

    @IBAction func changeLiftPressed(button: UIBarButtonItem) {
        scrollToOptionPage(0)
    }

    @IBAction func saveMaxPressed(button: UIBarButtonItem) {
        guard let userID = FIRAuth.auth()?.currentUser?.uid else { return }
        let database = FIRDatabase.database().reference()
        
        let calendar = NSCalendar.currentCalendar()
        let pickedDate = calendar.startOfDayForDate(datePicker.date)
        let currentDate = calendar.startOfDayForDate(NSDate())
        let day_offset = calendar.components(.Day, fromDate: pickedDate, toDate: currentDate, options: []).day
        
        let lift = lifts[templatePicker.selectedRowInComponent(0)-1]
        
        let currentTimestamp = Int(NSDate().timeIntervalSince1970)
        
        let weightLifted = self.weightLifted
        let reps = self.reps
        let formula = "epley"
        let entryType = "max"
        let entryDate = day_offset == 0 ? currentTimestamp : Int(pickedDate.timeIntervalSince1970)
        
        let fullEntryData = [
            "weight_lifted": weightLifted,
            "reps": reps,
            "date": entryDate,
            "timestamp": currentTimestamp,
            "formula": formula,
            "entry_type": entryType,
        ]
        
        let usersEntriesRef = database.child("entries/\(userID)")
        let entryId = usersEntriesRef.childByAutoId().key

        usersEntriesRef.updateChildValues([
            "\(lift.id)/\(entryId)": fullEntryData
        ])
        
        self.navigationController?.popViewControllerAnimated(true)

        // analytics
        var analyticsItems: [String: NSObject] = [
            "weight_lifted": weightLifted,
            "reps": reps,
            "formula": formula,
            "entry_type": entryType,
            "entry_timestamp": entryDate,
            "entry_day_offset": day_offset,
        ]
        
        let device = UIDevice.currentDevice()
        if device.batteryMonitoringEnabled {
            analyticsItems["battery_level"] = device.batteryLevel
        }
        FIRAnalytics.logEventWithName("ACTION_saved_entry", parameters: analyticsItems)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return liftPickerTitles.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return liftPickerTitles[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard row == 0 else { return }
        
        displayNewLiftForm()
    }
    
    var blurView: UIVisualEffectView?
    
    var createLiftView: NewLiftFormView?
    
    let BlurAnimationDuration = 0.2
    
    let CreateNewCategoryWarning = "CreateNewCategoryWarning"
    
    func displayNewLiftForm() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.valueForKey(CreateNewCategoryWarning) as? Bool != true {
            let alert = UIAlertController(title: "New lifts are public", message: "While your entries will remain private, new lifts are able to be used by other people!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        userDefaults.setValue(true, forKey: CreateNewCategoryWarning)
        
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        blurView!.translatesAutoresizingMaskIntoConstraints = false
        blurView!.frame = self.view.bounds
        blurView!.alpha = 0
        self.view.addSubview(self.blurView!)
        
        createLiftView = NewLiftFormView(frame: .zero)
        createLiftView!.translatesAutoresizingMaskIntoConstraints = false
        createLiftView!.textField.becomeFirstResponder()
        createLiftView!.saveMaxViewController = self
        createLiftView!.alpha = 0
        self.view.addSubview(createLiftView!)
        
        UIView.animateWithDuration(BlurAnimationDuration) {
            self.createLiftView!.alpha = 1
            self.blurView!.alpha = 1
        }
        
        NSLayoutConstraint.activateConstraints([
            createLiftView!.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor),
            createLiftView!.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor),
            
            createLiftView!.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor),
        ])
        
        blurView?.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(SaveMaxViewController.hideNewLiftForm))
        )
    }
    
    func hideNewLiftForm() {
        UIView.animateWithDuration(BlurAnimationDuration, animations: { 
            self.blurView?.alpha = 0
            self.createLiftView?.alpha = 0
            }) { finished in
            self.blurView?.removeFromSuperview()
            self.blurView = nil
            
            self.createLiftView?.removeFromSuperview()
            self.createLiftView = nil
        }
    }
    
    func saveNewLiftPressed(sender: AnyObject) {
        guard let liftName = createLiftView?.textField.text else { return }
        
        let databaseRef = FIRDatabase.database().reference()
        let newLiftRef = databaseRef.child("categories/Weight Lifting").childByAutoId()
            
        newLiftRef.setValue([
            "name": liftName,
            "type": "entry",
        ])
        
        hideNewLiftForm()
        
        lifts += [Lift(id: newLiftRef.key, name: liftName)]
        if let index = liftPickerTitles.indexOf(liftName) {
            templatePicker.selectRow(index, inComponent: 0, animated: true)
        } else {
            templatePicker.selectRow(1, inComponent: 0, animated: true)
        }
    }
    
    func scrollToOptionPage(optionPage: Int) {
        UIView.animateWithDuration(0.4) {
            self.optionsScrollView.contentOffset = CGPoint(x: self.optionsScrollView.frame.width*CGFloat(optionPage), y: 0)
        }
    }
    
}
