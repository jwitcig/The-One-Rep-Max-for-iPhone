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
    
    var weightLifted: Int!
    var reps: Int!
    var liftTemplates = [ORLiftTemplate]()
    
    var selectedTemplate: ORLiftTemplate {
        return self.liftTemplates[self.templatePicker.selectedRowInComponent(0)]
    }
    
    override func viewDidLoad() {
        self.updateLabels()
        
        let context = NSManagedObjectContext.contextForCurrentThread()
        
        let (templates, _) = session.localData.fetchAll(model: ORLiftTemplate.self, context: context)
        
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
    
    @IBAction func saveMaxPressed(sender: UIBarButtonItem) {
        let context = NSManagedObjectContext.contextForCurrentThread()
        
        let entry = ORLiftEntry.entry(context: context)
        entry.weightLifted = self.weightLifted
        entry.reps = self.reps
        entry.athlete = session.currentAthlete!
        entry.liftTemplate = self.selectedTemplate
        entry.maxOut = true
        entry.date = NSDate()
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
    
}
