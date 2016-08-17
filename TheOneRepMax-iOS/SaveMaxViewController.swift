//
//  SaveMaxViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 10/23/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import AWSMobileHubHelper
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
    
    var lifts: Results<LocalLift>! {
        didSet {
            liftNames = lifts.map{$0.name}
            templatePicker.reloadAllComponents()
        }
    }
    var liftNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateLabels()
        
        lifts = try! Realm().objects(LocalLift).sorted("_name")
        
        self.templatePicker.reloadAllComponents()
    }
    
    func updateLabels() {
        let max = LocalEntry.oneRepMax(weightLifted: weightLifted, reps: reps)
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
        let lift = lifts[templatePicker.selectedRowInComponent(0)]
        
        var entry = LocalEntry()
        entry.weightLifted = self.weightLifted
        entry.reps = self.reps
        entry.userId = ""
        entry.liftId = lift.id
        entry.maxOut = true
        entry.date = datePicker.date
        entry.createdDate = NSDate()
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(entry)
        }
                
        let eventClient = AWSMobileClient.sharedInstance.mobileAnalytics.eventClient
        let event = eventClient.createEventWithEventType("Action_SavedWeightLiftingMax")

        let device = UIDevice.currentDevice()
        if device.batteryMonitoringEnabled {
            event.addMetric(device.batteryLevel, forKey: "battery_level")
        }

        event.addMetric(entry.reps, forKey: "repetitions")
        event.addMetric(entry.weightLifted, forKey: "weight_lifted")
        event.addAttribute("epley", forKey: "one_rep_max_formula")
        event.addAttribute(String(Int(entry.date.timeIntervalSince1970)), forKey: "entry_timestamp")
        event.addAttribute(lift.name, forKey: "entry_category")
        
        let calendar = NSCalendar.currentCalendar()
        let date1 = calendar.startOfDayForDate(entry.date)
        let date2 = calendar.startOfDayForDate(NSDate())
        let offset = calendar.components(.Day, fromDate: date1, toDate: date2, options: []).day
        event.addMetric(offset, forKey: "day_offset")
        
        eventClient.recordEvent(event)
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lifts.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.liftNames[row]
    }
    
    func scrollToOptionPage(optionPage: Int) {
        UIView.animateWithDuration(0.4) {
            self.optionsScrollView.contentOffset = CGPoint(x: self.optionsScrollView.frame.width*CGFloat(optionPage), y: 0)
        }
    }
    
}
