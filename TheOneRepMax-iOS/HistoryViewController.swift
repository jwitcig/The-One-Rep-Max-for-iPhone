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

class HistoryViewController: ORViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var filterBar: UINavigationBar!
    
    @IBOutlet weak var entriesTableView: UITableView!
    
    var filterViewController: FilterPopoverViewController?
        
    var liftEntries = [ORLiftEntry]() {
        didSet {
            entriesTableView.reloadData()
        }
    }
    
    var selectedLiftTemplate: ORLiftTemplate? {
        return filterViewController?.selectedLiftTemplate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshLiftEntriesList()
    }
    
    override func viewWillAppear(animated: Bool) {
        updateFilterBar()
        
        refreshLiftEntriesList()
        
        
        entriesTableView.backgroundColor = UIColor.clearColor()
        entriesTableView.separatorColor = UIColor.blackColor()
    }
    
    func updateFilterBar() {
        guard let filterNavigationItem = filterBar.items?[0] else {
            return
        }
        
        guard let selectedTemplate = self.selectedLiftTemplate else {
            filterNavigationItem.title = "All Entries"
            return
        }
        
        filterNavigationItem.title = selectedTemplate.liftName
    }
    
    func setupFilterViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        filterViewController = storyboard.instantiateViewControllerWithIdentifier("FilterPopover") as? FilterPopoverViewController
                
        filterViewController?.modalPresentationStyle = .Popover
    }
    
    func presentFilterViewController() {
        setupFilterViewController()
        
        self.presentViewController(filterViewController!, animated: true, completion: nil)
    }
    
    func refreshLiftEntriesList() {
        let currentAthlete = session.currentAthlete!
        
        defer {
            self.liftEntries.sortInPlace { $0.date.isBefore(date: $1.date) }
        }
        
        guard let liftTemplate = selectedLiftTemplate else {
            let (entries, _) = localData.fetchLiftEntries(athlete: currentAthlete)
            
            self.liftEntries = entries
            return
        }
        
        
        let (entries, _) = localData.fetchLiftEntries(athlete: currentAthlete, template: liftTemplate)
        self.liftEntries = entries
    }
    
    @IBAction func filterPressed(button: UIBarButtonItem) {
        presentFilterViewController()
        
        // configure the Popover presentation controller
        let popController = filterViewController!.popoverPresentationController!
        
        popController.permittedArrowDirections = .Any
        popController.delegate = self
        
        popController.barButtonItem = self.navigationItem.rightBarButtonItem
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch tableView {
            
        case self.entriesTableView:
            return 1
            
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
            
        case self.entriesTableView:
            return "\(self.liftEntries.count) entries"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
            
        case self.entriesTableView:
            return self.liftEntries.count
            
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let entry = self.liftEntries[indexPath.row]

        let cell = LiftEntryTableViewCell(style: .Value1, reuseIdentifier: "LiftEntryCell", entry: entry)
        
        cell.backgroundColor = UIColor.grayColor()
        cell.contentView.backgroundColor = UIColor.clearColor()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector("didLongPressMaxEntryCell:"))
        cell.addGestureRecognizer(longPressGesture)
        
        switch tableView {
     
        case self.entriesTableView:
            cell.textLabel?.text = "\(cell.entry.max.intValue) lbs."
            cell.detailTextLabel?.text = "[\(cell.entry.weightLifted.integerValue) x \(cell.entry.reps.intValue)]"
            
            cell.textLabel?.textColor = UIColor.whiteColor()
            cell.detailTextLabel?.textColor = UIColor.whiteColor()
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return .Delete
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
            
            self.localData.delete(object: entry)
            self.localData.save(context: entry.managedObjectContext)
            
            
            self.refreshLiftEntriesList()
            self.entriesTableView.reloadData()
        })
        deleteEntryViewController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(deleteEntryViewController, animated: true, completion: nil)
        
    }
    
}
