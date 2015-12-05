//
//  OrganizationDetailViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 9/18/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import CoreData
import ORMKitiOS

class OrganizationDetailViewController: UIViewController {
    
    private var organization: OROrganization!
    var organizationID: NSManagedObjectID!
    
    @IBOutlet weak var athleteCountLabel: UILabel!
    @IBOutlet weak var organizationDescriptionLabel: UILabel!
    
    @IBOutlet weak var joinButton: UIBarButtonItem!
    
    var organizationListViewController: OrgListViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let organization = NSManagedObjectContext.contextForCurrentThread().objectRegisteredForID(self.organizationID) as? OROrganization else {
            return
        }
        self.organization = organization
        self.displayOrganizationInformation()
        
        let athlete = ORSession.currentSession.currentAthlete!
        
        let predicates = [
            NSPredicate(key: ORMembership.Fields.organization.rawValue, comparator: .Equals, value: self.organization),
            NSPredicate(key: ORMembership.Fields.athlete.rawValue, comparator: .Equals, value: athlete)
        ]
        let (existing, _) = ORSession.currentSession.localData.fetchObjects(model: ORMembership.self, predicates: predicates)
        let alreadyMember = existing.count != 0
        if alreadyMember {
            self.joinButton.enabled = false
        }

    }
    
    func displayOrganizationInformation() {
        self.navigationItem.title = organization.orgName

        self.organizationDescriptionLabel.text = organization.orgDescription
    }
    
    @IBAction func joinOrganizationPressed(sender: UIBarButtonItem) {
        self.organizationListViewController.deleteTemporaryOrganizationObjects(spareOrganizationWithRecordName: self.organization.recordName)
        let context = NSManagedObjectContext.contextForCurrentThread()
        let athlete = ORSession.currentSession.currentAthlete!
        
        let predicates = [
            NSPredicate(key: ORMembership.Fields.organization.rawValue, comparator: .Equals, value: self.organization),
            NSPredicate(key: ORMembership.Fields.athlete.rawValue, comparator: .Equals, value: athlete)
        ]
        let (existing, _) = ORSession.currentSession.localData.fetchObjects(model: ORMembership.self, predicates: predicates)
        guard existing.count == 0 else { return }
        
        let membership = ORMembership.membership(context: context)
        membership.athlete = athlete
        membership.organization = self.organization
        
        ORSession.currentSession.localData.save(context: context)
        
        ORSession.currentSession.cloudData.syncronizeDataToCloudStore {
            guard $0.success else { print($0.error); return }
            
            ORSession.currentSession.currentOrganization = self.organization
            
            runOnMainThread {

            }
        }
    }
    
}
