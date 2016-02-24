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

class HistoryViewController: ORViewController, UITableViewDelegate, UITableViewDataSource, DataViewerDelegate {
    
    @IBOutlet weak var filterBar: UINavigationBar!
    
    @IBOutlet weak var entriesTableView: UITableView!
    
    var dataViewerViewController: DataViewerViewController!
        
    var liftEntries = [ORLiftEntry]() {
        didSet {
            entriesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableTransparentBackground()
    }
    
    override func viewWillAppear(animated: Bool) {
//        simpleHistoryGraphViewController.requestGraphUpdate(entries: self.liftEntries)
        
        entriesTableView.backgroundColor = UIColor.clearColor()
        entriesTableView.separatorColor = UIColor.blackColor()
    }
    
    func selectedLiftDidChange(liftTemplate liftTemplate: ORLiftTemplate?, liftEntries: [ORLiftEntry]) {
        
        self.liftEntries = liftEntries.sort { !$0.date.isBefore(date: $1.date) }
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
            
            guard self.liftEntries.count > 0 else {
                return 1
            }
            
            return self.liftEntries.count
            
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        var entry: ORLiftEntry?
        
        if liftEntries.count > 0 {
            entry = liftEntries[indexPath.row]
        }

        // Case: No Entries
        guard let liftEntry = entry else {
            let cell = UITableViewCell()
            cell.textLabel?.text = "No Entries"
            
            cell.backgroundColor = UIColor.clearColor()
            cell.contentView.backgroundColor = UIColor.clearColor()
            
            return cell
        }
        
        let cell = LiftEntryTableViewCell(style: .Value1, reuseIdentifier: "LiftEntryCell", entry: liftEntry)
        
        cell.backgroundColor = UIColor.clearColor()
        cell.contentView.backgroundColor = UIColor.clearColor()
        
//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: Selector("didLongPressMaxEntryCell:"))
//        cell.addGestureRecognizer(longPressGesture)
        
        switch tableView {
     
        case self.entriesTableView:
            
            let centerLabel = UILabel()
            cell.contentView.addSubview(centerLabel)
            centerLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activateConstraints([
                centerLabel.centerXAnchor.constraintEqualToAnchor(cell.contentView.centerXAnchor),
                centerLabel.centerYAnchor.constraintEqualToAnchor(cell.contentView.centerYAnchor)
            ])
            
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/d"
            
            let entryDateString = dateFormatter.stringFromDate(cell.entry.date)

            cell.textLabel?.text = entryDateString
            
            centerLabel.text = "\(cell.entry.max.intValue) lbs."
            centerLabel.sizeToFit()
            
            cell.detailTextLabel?.text = "[\(cell.entry.weightLifted.integerValue) x \(cell.entry.reps.intValue)]"
            cell.detailTextLabel?.textColor = UIColor.blackColor()

        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? LiftEntryTableViewCell else {
            return
        }
        
        presentDeletionDialog(cell.entry)
    }

    func presentDeletionDialog(entry: ORLiftEntry) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d"
        let dateString = dateFormatter.stringFromDate(entry.date)
        
        let deleteEntryViewController = UIAlertController(title: "Delete Entry?", message: "Are you sure you want to delete this entry: \(dateString) - [\(entry.weightLifted.intValue) x \(entry.reps.integerValue)]", preferredStyle: .Alert)
        
        deleteEntryViewController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive) { (action) in
            
            self.localData.delete(object: entry)
            self.localData.save(context: entry.managedObjectContext)
            
            self.entriesTableView.reloadData()
        })
        deleteEntryViewController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(deleteEntryViewController, animated: true, completion: nil)
        
    }
    
}
