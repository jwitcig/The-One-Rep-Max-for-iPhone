//
//  OrgListViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 9/16/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import ORMKitiOS

class OrgListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchTimer: NSTimer!
    
    var temporaryOrganizations = [OROrganization]()
    
    var temporaryOrganizationRecordNames: [String] {
        return self.temporaryOrganizations.recordNames
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("fetching")
        ORSession.currentSession.cloudData.fetchAllOrganizations { (threadedOrganizations, response) -> () in
            
            print(response.success)
            guard response.success else { return }
            
            ORSession.currentSession.localData.save(context: response.currentThreadContext)

            self.temporaryOrganizations = NSManagedObjectContext.contextForThread(NSThread.mainThread()).crossContextEquivalents(objects: threadedOrganizations)
            
            runOnMainThread {
                self.tableView.reloadData()
            }
        }
        
        // Keeps UITableView locked to navigation bar
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.temporaryOrganizations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let organization = self.temporaryOrganizations[indexPath.row]

        let cell = OrganizationTableViewCell(style: .Default, reuseIdentifier: "OrganizationListTableViewCellIdentifier", organization: organization)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("cellLongPressed:"))
        longPressRecognizer.minimumPressDuration = 1.0
        longPressRecognizer.delegate = self
        cell.addGestureRecognizer(longPressRecognizer)
        
        cell.textLabel?.text = organization.orgName
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowOrgDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard segue.identifier == "ShowOrgDetail" else { return }
        
        guard let selectedIndexPath = self.tableView.indexPathForSelectedRow else { return }
        let selectedCell = self.tableView.cellForRowAtIndexPath(selectedIndexPath) as! OrganizationTableViewCell
        
        let destination = segue.destinationViewController as! OrganizationDetailViewController
        
        destination.organizationListViewController = self
        destination.organizationID = selectedCell.organization.objectID
    }
    
    func cellLongPressed(longPressRecognizer: UIGestureRecognizer) {
        guard longPressRecognizer.state == .Began else { return }

        let organizationTableViewCell = longPressRecognizer.view as! OrganizationTableViewCell
        let organization = organizationTableViewCell.organization
        
        let alertController = UIAlertController(title: "Description", message: organization.orgDescription, preferredStyle: .ActionSheet)
        let dismissalAction = UIAlertAction(title: "Close", style: .Default, handler: nil)
        alertController.addAction(dismissalAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func deleteTemporaryOrganizationObjects(spareOrganizationWithRecordName spareRecordName: String) {
        let idsToDelete = self.temporaryOrganizationRecordNames.filter { $0 != spareRecordName }
        
        let context = NSManagedObjectContext.contextForCurrentThread()
        let resultsToDelete = ORSession.currentSession.localData.fetchObjects(ids: idsToDelete, model: OROrganization.self, context: context)
        
        guard let toDelete = resultsToDelete else {
            print("Error fetching organizations to delete.")
            return
        }
        _ = toDelete.map(context.deleteObject)
        ORSession.currentSession.localData.save(context: context)
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if self.searchTimer != nil {
            self.searchTimer!.invalidate()
        }
        
        let userInfo = ["searchText": searchText]
        self.searchTimer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("search:"), userInfo: userInfo, repeats: false)
    }
    
    func search(timer: NSTimer) {
        guard let searchText = (timer.userInfo as? NSDictionary)?["searchText"] else {
            print("No search text was provided for the query.")
            return
        }
        
        let predicate = NSPredicate(key: "self", comparator: .Contains, value: searchText)
        
        ORSession.currentSession.cloudData.fetchModels(model: OROrganization.self, predicate: predicate) { (threadedOrganizations, response) in
            guard response.success else { print(response.error);return }
            
            ORSession.currentSession.localData.save(context: response.currentThreadContext)
            
            let mainThread = NSThread.mainThread()
            let mainThreadContext = NSManagedObjectContext.contextForThread(mainThread)
            self.temporaryOrganizations = mainThreadContext.crossContextEquivalents(objects: threadedOrganizations)
            
            runOnMainThread {
                self.tableView.reloadData()
            }
        }
    }
    
}

class OrganizationTableViewCell: UITableViewCell {
    
    var organization: OROrganization

    required init(style: UITableViewCellStyle, reuseIdentifier: String?, organization: OROrganization) {
        self.organization = organization
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
