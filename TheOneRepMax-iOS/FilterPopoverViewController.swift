//
//  FilterPopoverViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 12/11/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit


import SwiftTools

class FilterPopoverViewController: ORViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var liftTemplatesTableView: UITableView!
    
    var liftTemplates: [ORLiftTemplate] = []
    
    var selectedLiftPath: NSIndexPath?
    
    var dataViewerViewController: DataViewerViewController!
    
    var selectedLiftTemplate: ORLiftTemplate? {
        get {
            guard let row = liftTemplatesTableView?.indexPathForSelectedRow?.row else {
                return nil
            }
            return liftTemplates[row]
        }
        
        set {
            guard let template = newValue,
                  let index = liftTemplates.indexOf(template) else { return }
            
            liftTemplatesTableView.selectRowAtIndexPath(NSIndexPath(forItem: index, inSection: 0), animated: false, scrollPosition: .Middle)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        var templates = ORModel.all(entityType: ORLiftTemplate.self)

        templates.sortInPlace {
            $0.liftName.isBefore(string: $1.liftName)
        }
        
        liftTemplates = templates
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
        return liftTemplates.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == selectedLiftPath {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        selectedLiftPath = indexPath
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let template = liftTemplates[indexPath.row]
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        
        cell.textLabel?.text = template.liftName
        
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }

}