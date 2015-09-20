//
//  OrganizationDetailViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 9/18/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import CoreData
import ORMKit

class OrganizationDetailViewController: UIViewController {
    
    private var organization: OROrganization!
    var organizationID: NSManagedObjectID!
    
    @IBOutlet weak var athleteCountLabel: UILabel!
    @IBOutlet weak var organizationDescriptionLabel: UILabel!
    
    var organizationListViewController: OrgListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let organization = NSManagedObjectContext.contextForCurrentThread().objectRegisteredForID(self.organizationID) as? OROrganization else {
            return
        }
        self.organization = organization
        self.displayOrganizationInformation()
    }
    
    func displayOrganizationInformation() {
        self.navigationItem.title = organization.orgName
        
        if let athleteCount = organization.athleteReferences?.count {
              self.athleteCountLabel.text = "\(athleteCount) athletes"
        }

        self.organizationDescriptionLabel.text = organization.orgDescription
    }
    
    @IBAction func joinOrganizationPressed(sender: UIBarButtonItem) {
        self.organizationListViewController.deleteTemporaryOrganizationObjects(spareOrganizationWithRecordName: self.organization.recordName)
        let context = NSManagedObjectContext.contextForCurrentThread()
        let athlete = ORSession.currentSession.currentAthlete!

        self.organization.athletes.insert(athlete)
        ORSession.currentSession.localData.save(context: context)
        
        ORSession.currentSession.cloudData.syncronizeDataToCloudStore {
            guard $0.success else { print($0.error); return }
            
            ORSession.currentSession.currentOrganization = self.organization
            
            runOnMainThread {

            }
        }
    }
    
}
