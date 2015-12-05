//
//  HistoryViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 10/28/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import ORMKitiOS
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var templatesTableview: UITableView!
    
    @IBOutlet weak var entriesTableView: UITableView!
        
    var liftTemplates = [ORLiftTemplate]()
    var liftEntries = [ORLiftEntry]()
    
    var selectedLiftTemplate: ORLiftTemplate? {
        if let selectedRow = self.templatesTableview.indexPathForSelectedRow?.row {
            return self.liftTemplates[selectedRow]
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = NSManagedObjectContext.contextForCurrentThread()
        
        if let organization = ORSession.currentSession.currentOrganization {
            
            let (templates ,_) = ORSession.currentSession.localData.fetchObjects(model: ORLiftTemplate.self, predicates: [NSPredicate(key: ORLiftTemplate.Fields.organization.rawValue, comparator: .Equals, value: organization)], context: context)
            
            let (defaultTemplates, _) = ORSession.currentSession.localData.fetchObjects(model: ORLiftTemplate.self, predicates: [NSPredicate(key: ORLiftTemplate.Fields.defaultLift.rawValue, comparator: .Equals, value: true)], context: context)

            liftTemplates.appendContentsOf(templates)
            liftTemplates.appendContentsOf(defaultTemplates)
            
            self.templatesTableview.reloadData()

            guard liftTemplates.count > 0 else { return }
            
            
            let firstTemplateIndex = NSIndexPath(forRow: 0, inSection: 0)
            self.templatesTableview.selectRowAtIndexPath(firstTemplateIndex, animated: true, scrollPosition: .Top)
            self.tableView(self.templatesTableview, didSelectRowAtIndexPath: firstTemplateIndex)
        }
        
    }
    
    func refreshLiftEntriesList() {
        let organization = ORSession.currentSession.currentOrganization!
        let liftTemplate = self.selectedLiftTemplate!
        
        let (entries, _) = ORSession.currentSession.localData.fetchLiftEntries(athlete: ORSession.currentSession.currentAthlete!, organization: organization, template: liftTemplate)
        self.liftEntries = entries
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch tableView {
            
        case self.templatesTableview:
            return 1
        case self.entriesTableView:
            return 1
            
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
            
        case self.templatesTableview:
            return "Lifts"
        case self.entriesTableView:
            return "\(self.liftEntries.count) entries"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
            
        case self.templatesTableview:
            return self.liftTemplates.count
        case self.entriesTableView:
            return self.liftEntries.count
            
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "Cell")
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector("didLongPressMaxEntryCell:"))
        cell.addGestureRecognizer(longPressGesture)
        
        switch tableView {
            
        case self.templatesTableview:
            let template = self.liftTemplates[indexPath.row]
            cell.textLabel?.text = template.liftName
            
        case self.entriesTableView:
            
            let entry = self.liftEntries[indexPath.row]
            cell.textLabel?.text = "\(entry.max.intValue) lbs."
            cell.detailTextLabel?.text = "[\(entry.weightLifted.integerValue) x \(entry.reps.intValue)]"
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch tableView {
        case self.templatesTableview:
            
            self.refreshLiftEntriesList()
            self.entriesTableView.reloadData()

        case self.entriesTableView:
            break
        default:
            break
        }
        
    }
    
    func didLongPressMaxEntryCell(gestureRecognizer: UILongPressGestureRecognizer) {
        let cell = gestureRecognizer.view! as! UITableViewCell
        let indexPath = self.entriesTableView.indexPathForCell(cell)!
        let entry = self.liftEntries[indexPath.row]
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d"
        let dateString = dateFormatter.stringFromDate(entry.date)

        let deleteEntryViewController = UIAlertController(title: "Delete Entry?", message: "Are you sure you want to delete this entry: \(dateString) - [\(entry.weightLifted.intValue) x \(entry.reps.integerValue)]", preferredStyle: .Alert)
        
        deleteEntryViewController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive) { (action) in
            
            ORSession.currentSession.localData.delete(object: entry)
            ORSession.currentSession.localData.save(context: entry.managedObjectContext)
            
            ORSession.currentSession.cloudData.syncronizeDataToCloudStore { response in
                guard response.success else { return }
                print("Sync complete after record deletion")
                runOnMainThread {
                    self.refreshLiftEntriesList()
                    self.entriesTableView.reloadData()
                }
            }
        })
        deleteEntryViewController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(deleteEntryViewController, animated: true, completion: nil)
        
    }
    
}
