//
//  SaveMaxViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 10/23/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

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
    
    var lifts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateLabels()
        
        let realm = try! Realm()
        
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
        var entry = LocalEntry()
        entry.weightLifted = self.weightLifted
        entry.reps = self.reps
        entry.userId = ""
        entry.lift = ""
        entry.maxOut = true
        entry.date = datePicker.date
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(entry)
        }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lifts.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.lifts[row]
    }
    
    func scrollToOptionPage(optionPage: Int) {
        UIView.animateWithDuration(0.4) {
            self.optionsScrollView.contentOffset = CGPoint(x: self.optionsScrollView.frame.width*CGFloat(optionPage), y: 0)
        }
    }
    
}
