//
//  LiftTableView.swift
//  TheOneRepMax
//
//  Created by Developer on 8/10/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import RealmSwift

class LiftTableView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    let lifts = try! Realm().objects(LocalLift)
    
    var didSelectLiftBlock: ((lift: LocalLift)->())?
    
    var selectedLift: LocalLift? {
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
        
        let eventClient = AWSMobileClient.sharedInstance.mobileAnalytics.eventClient
        let event = eventClient.createEventWithEventType("Action_FilterByLift")
        let device = UIDevice.currentDevice()
        if device.batteryMonitoringEnabled {
            event.addMetric(device.batteryLevel, forKey: "battery_level")
        }
        eventClient.recordEvent(event)
    }
    
}