//
//  LiftTableView.swift
//  TheOneRepMax
//
//  Created by Developer on 8/10/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import Firebase
import RealmSwift

class LiftTableView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    var lifts = [Lift]() {
        didSet { tableview.reloadData() }
    }
    
    var didSelectLiftBlock: ((lift: Lift)->())?
    
    var selectedLift: Lift? {
        if let row = tableview.indexPathForSelectedRow?.row {
            return lifts[row]
        }
        return nil
    }
    
    static func create() -> LiftTableView {
        return NSBundle.mainBundle().loadNibNamed("LiftTableView", owner: nil, options: nil)[0] as! LiftTableView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lifts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        cell.textLabel?.text = lifts[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        didSelectLiftBlock?(lift: lifts[indexPath.row])
        
        removeFromSuperview()
        
        let device = UIDevice.currentDevice()
        let analyticsItems = device.batteryMonitoringEnabled ? ["battery_level": device.batteryLevel] : [String: NSObject]()
        FIRAnalytics.logEventWithName("ACTION_filtered_by_lift", parameters: analyticsItems)
    }
    
}