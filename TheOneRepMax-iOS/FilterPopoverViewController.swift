//
//  FilterPopoverViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 12/11/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit

import RealmSwift

import SwiftTools

class FilterPopoverViewController: ORViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var liftTemplatesTableView: UITableView!
    
//    let lifts = try! Realm().objects(Lift)
    let lifts = [Lift]()
    
    var selectedLiftPath: NSIndexPath?
    
    var dataViewerViewController: DataViewerViewController!
    
    var selectedLift: Lift? {
        get {
            guard let row = selectedLiftPath?.row else {
                return nil
            }
            return lifts[row]
        }
        
        set {
            guard let template = newValue,
                  let index = lifts.indexOf(template) else { return }
            
            liftTemplatesTableView.selectRowAtIndexPath(NSIndexPath(forItem: index, inSection: 0), animated: false, scrollPosition: .Middle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        liftTemplatesTableView.reloadData()
        
        liftTemplatesTableView.backgroundColor = UIColor.clearColor()
        liftTemplatesTableView.separatorColor = UIColor.blackColor()
    }
    
    @IBAction func applyPressed(button: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Lift"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lifts.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == selectedLiftPath {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        selectedLiftPath = indexPath
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let lift = lifts[indexPath.row]
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        
        cell.textLabel?.text = lift.name
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }

}