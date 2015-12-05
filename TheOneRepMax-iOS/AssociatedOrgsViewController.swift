//
//  AssociatedOrgsViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 9/24/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import CoreData
import ORMKitiOS

class AssociatedOrgsViewController: ORViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var organizations = [OROrganization]()
    var organizationIDs: [NSManagedObjectID] {
        return self.organizations.map { $0.objectID }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ORSession.currentSession.cloudData.fetchAssociatedOrganizations(athlete: ORSession.currentSession.currentAthlete!) { threadedOrganizations, response in

            guard response.success else { return }
        
            ORSession.currentSession.localData.save(context: response.currentThreadContext)
        
            let mainThread = NSThread.mainThread()
            let mainThreadContext =  NSManagedObjectContext.contextForThread(mainThread)
            self.organizations = mainThreadContext.crossContextEquivalents(objects: threadedOrganizations)
        
            runOnMainThread {
                self.tableView.reloadData()
            }
        }
    
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.organizations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let organization = self.organizations[indexPath.row]
        
        let cell = OrganizationTableViewCell(style: .Default, reuseIdentifier: "OrganizationListTableViewCellIdentifier", organization: organization)
        cell.textLabel?.text = organization.orgName
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let organization = self.organizations[indexPath.row]
        ORSession.currentSession.currentOrganization = organization
        self.performSegueWithIdentifier("ShowOrgHome", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "ShowOrgHome" else { return }
        
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else { return }
        let selectedCell = self.tableView.cellForRowAtIndexPath(selectedIndexPath) as! OrganizationTableViewCell
        
        let destination = segue.destinationViewController as! HomeViewController
        
        destination.organizationID = selectedCell.organization.objectID
    }
    
    @IBAction func clearStorePressed(sender: AnyObject) {
        self.localData.deleteAll(model: OROrganization.self)
        self.localData.deleteAll(model: ORLiftTemplate.self)
        self.localData.deleteAll(model: ORLiftEntry.self)
        self.localData.deleteAll(model: ORMessage.self)
        self.localData.deleteAll(model: ORAthlete.self)
        self.localData.deleteAll(model: ORMembership.self)
        
        let request = NSFetchRequest(entityName: "CloudRecord")
        do {
            let cloudRecords = try self.localData.context.executeFetchRequest(request) as! [NSManagedObject]
            cloudRecords.map { self.localData.context.deleteObject($0) }
            self.localData.save()
        } catch  { }
    }

}
