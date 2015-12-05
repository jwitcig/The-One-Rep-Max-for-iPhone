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

class SaveMaxViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var factorsLabel: UILabel!
    
    @IBOutlet weak var templatePicker: UIPickerView!
    
    var organization: OROrganization?
    var weightLifted: Int!
    var reps: Int!
    var liftTemplates = [ORLiftTemplate]()
    
    var selectedTemplate: ORLiftTemplate {
        return self.liftTemplates[self.templatePicker.selectedRowInComponent(0)]
    }
    
    override func viewDidLoad() {
        
        self.updateLabels()
        
        let context = NSManagedObjectContext.contextForCurrentThread()
        
        let (templates, _) = ORSession.currentSession.localData.fetchAll(model: ORLiftTemplate.self, context: context)
        self.liftTemplates = templates
        self.templatePicker.reloadAllComponents()
        
    }
    
    func updateLabels() {
        let max = ORStats.oneRepMax(weightLifted: self.weightLifted, reps: self.reps)
        self.maxLabel.text = "\(max) lbs."
        self.factorsLabel.text = "[\(weightLifted) lbs. | \(reps) reps]"
    }
    
    @IBAction func saveMaxPressed(sender: UIBarButtonItem) {
        let entry = ORLiftEntry.entry(context: NSManagedObjectContext.contextForCurrentThread())
        entry.weightLifted = self.weightLifted
        entry.reps = self.reps
        entry.athlete = ORSession.currentSession.currentAthlete!
        entry.liftTemplate = self.selectedTemplate
        entry.organization = self.organization
        entry.maxOut = true
        entry.date = NSDate()
        ORSession.currentSession.localData.save(context: NSManagedObjectContext.contextForCurrentThread())
        ORSession.currentSession.cloudData.syncronizeDataToCloudStore { (response) in
            print(response.success)
            if response.success == false {
                print(response.error)
            }
//            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.liftTemplates.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let liftTemplate = self.liftTemplates[row]
        return liftTemplate.liftName
    }
    
}
