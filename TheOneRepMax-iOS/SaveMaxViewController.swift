//
//  SaveMaxViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 10/23/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import ORMKitiOS
import CoreData

class SaveMaxViewController: ORViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var factorsLabel: UILabel!
    
    @IBOutlet weak var templatePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var optionsScrollView: UIScrollView!
    
    var weightLifted: Int!
    var reps: Int!
    var liftTemplates = [ORLiftTemplate]()
    
    var selectedTemplate: ORLiftTemplate {
        return self.liftTemplates[self.templatePicker.selectedRowInComponent(0)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateLabels()
        
        let context = NSManagedObjectContext.contextForCurrentThread()
        
        var (templates, response) = session.localData.fetchAll(model: ORLiftTemplate.self, context: context)
        
        guard response.success else { print("An error occured in fetching LiftTemplates: \(response.error)"); return }
        
        templates.sortInPlace {
            $0.liftName.isBefore(string: $1.liftName)
        }
        
        self.liftTemplates = templates
        self.templatePicker.reloadAllComponents()
    }
    
    func updateLabels() {
        let max = ORLiftEntry.oneRepMax(weightLifted: Float(weightLifted), reps: Float(reps))
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
        let context = NSManagedObjectContext.contextForCurrentThread()
        
        let entry = ORLiftEntry.entry(context: context)
        entry.weightLifted = self.weightLifted
        entry.reps = self.reps
        entry.athlete = session.currentAthlete!
        entry.liftTemplate = self.selectedTemplate
        entry.maxOut = true
        entry.date = datePicker.date
        let saveResponse = localData.save(context: context)
        
        guard saveResponse.success else { return }
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.liftTemplates.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.liftTemplates[row].liftName
    }
    
    func scrollToOptionPage(optionPage: Int) {
        UIView.animateWithDuration(0.4) {
            self.optionsScrollView.contentOffset = CGPoint(x: self.optionsScrollView.frame.width*CGFloat(optionPage), y: 0)
        }
    }
    
}
