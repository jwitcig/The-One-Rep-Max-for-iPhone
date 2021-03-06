//
//  HistoryViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 10/28/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth
import RealmSwift

class HistoryViewController: ORViewController, UITableViewDelegate, UITableViewDataSource, DataViewerDelegate {
    
    @IBOutlet weak var filterBar: UINavigationBar!
    
    @IBOutlet weak var entriesTableView: UITableView!
    
    var dataViewerViewController: DataViewerViewController!
    
    var lift: Lift!
    
    var liftEntries = [Entry]() {
        didSet { entriesTableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableTransparentBackground()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        entriesTableView.backgroundColor = UIColor.clearColor()
        entriesTableView.separatorColor = UIColor.blackColor()
    }
    
    func selectedLiftDidChange(lift lift: Lift?, liftEntries entries: [Entry]) {
        self.lift = lift
        self.liftEntries = entries.sort { $0.0.date.compare($0.1.date) == .OrderedDescending }
        
        filterBar?.topItem?.title = lift?.name ?? "All Entries"
        
        entriesTableView.reloadData()
    }
    
    func updateLiftEntriesList() {
        entriesTableView.reloadData()
    }
    
    override func dataWasChanged() {
        super.dataWasChanged()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        switch tableView {
            
        case entriesTableView:
            return 1
            
        default:
            return 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch tableView {
            
        case self.entriesTableView:
            return "\(liftEntries.count) entries"
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
            
        case entriesTableView:
            
            guard liftEntries.count > 0 else {
                return 1
            }
            
            return liftEntries.count
            
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        var entry: Entry?
        
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
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(HistoryViewController.maxEntryCellLongPressStateChanged(_:)))
        cell.addGestureRecognizer(longPressGesture)
        
        switch tableView {
     
        case self.entriesTableView:
//            let labelFontSize = cell.textLabel?.font.pointSize ?? 12
            let labelFontSize = 18 as CGFloat
            
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
            
            centerLabel.text = "\(cell.entry.max) lbs."
            centerLabel.sizeToFit()
            
            cell.detailTextLabel?.text = "[\(cell.entry.weightLifted) x \(cell.entry.reps)]"
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            
            cell.textLabel?.font = UIFont(name: "Avenir", size: labelFontSize)
            centerLabel.font = UIFont(name: "Avenir", size: labelFontSize)
            cell.detailTextLabel?.font = UIFont(name: "Avenir", size: labelFontSize)
            
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? LiftEntryTableViewCell else {
            return
        }
        
        presentDeletionDialog(cell.entry as! Entry)
    }
    
    func maxEntryCellLongPressStateChanged(longPressRecognizer: UILongPressGestureRecognizer) {
        guard let cell = longPressRecognizer.view as? LiftEntryTableViewCell else { return }
        
        switch longPressRecognizer.state {
        case .Began:
            
            presentDeletionDialog(cell.entry as! Entry)
            
        default:
            break
            
        }
    }
    
    func presentDeletionDialog(entry: Entry) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d"
        let dateString = dateFormatter.stringFromDate(entry.date)
        
        let deleteEntryViewController = UIAlertController(title: "Delete Entry?", message: "Are you sure you want to delete this entry: \(dateString) - [\(entry.weightLifted) x \(entry.reps)]", preferredStyle: .Alert)
        
        deleteEntryViewController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive) { (action) in
            
            guard let userID = FIRAuth.auth()?.currentUser?.uid else { return }
            let database = FIRDatabase.database().reference()
            database.child("entries/\(userID)/\(self.lift.id)/\(entry.id)").removeValue()
            
            self.entriesTableView.reloadData()
            
            // analytics
            let calendar = NSCalendar.currentCalendar()
            var analyticsItems: [String: NSObject] = [
                "category_id": self.lift.id,
                "entry_id": entry.id,
                "entry_timestamp": Int(entry.createdDate.timeIntervalSince1970),
                "entry_date": Int(entry.date.timeIntervalSince1970),
                
                // seconds between the entry's marked date and the current deletion date
                "entry_second_offset_marked": calendar.components(.Second, fromDate: entry.date, toDate: NSDate(), options: []).second,
                // seconds between the entry's timestamped date and the current deletion date
                "entry_second_offset_created": calendar.components(.Second, fromDate: entry.createdDate, toDate: NSDate(), options: []).second,
            ]
            let device = UIDevice.currentDevice()
            if device.batteryMonitoringEnabled {
                analyticsItems["battery_level"] = device.batteryLevel
            }
            FIRAnalytics.logEventWithName("ACTION_deleted_entry", parameters: analyticsItems)
        })
        deleteEntryViewController.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
        
        self.presentViewController(deleteEntryViewController, animated: true, completion: nil)
    }
    
}
