//
//  OrgListViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 9/16/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import ORMKit

class OrgListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var temporaryOrganizations = [OROrganization]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ORSession.currentSession.cloudData.fetchAllOrganizations { (organizations, response) -> () in
            self.temporaryOrganizations = organizations
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
        
        destination.organization = selectedCell.organization
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
