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
        didSet { templatePicker.reloadAllComponents() }
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
            self.templatePicker.reloadAllComponents()
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
        
        let lift = lifts[templatePicker.selectedRowInComponent(0)]
        
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

//        var recentEntryData = fullEntryData.dictionaryWithValuesForKeys(["reps", "weight_lifted", "date", "category_name", "category_type"])
//        recentEntryData["entry_id"] = entryId
        
        let updates = [
//            "recent/\(lift.id)": recentEntryData,
            "\(lift.id)/\(entryId)": fullEntryData,
        ]
        usersEntriesRef.updateChildValues(updates)
        
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
        return self.lifts.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.lifts[row].name
    }
    
    func scrollToOptionPage(optionPage: Int) {
        UIView.animateWithDuration(0.4) {
            self.optionsScrollView.contentOffset = CGPoint(x: self.optionsScrollView.frame.width*CGFloat(optionPage), y: 0)
        }
    }
    
}
