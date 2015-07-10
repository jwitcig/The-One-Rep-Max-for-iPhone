//
//  ViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/9/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit
import ORMKit

class OrganizationListViewController: NSViewController, NSCollectionViewDelegate {
    
    @IBOutlet weak var organizationListView: NSView!
    @IBOutlet weak var organizationInfoContainer: NSView!
    @IBOutlet weak var orgNameLabel: NSTextField!
    @IBOutlet weak var orgAthleteCountLabel: NSTextField!
    
    var parentVC: MainViewController!
    var organizations = [OROrganization]()
    
    var container: CKContainer!
    var publicDB: CKDatabase!
    var session: ORSession!
    var localData: ORLocalData!
    var cloudData: ORCloudData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentVC = self.parentViewController! as! MainViewController
        
        self.view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        
        self.container = CKContainer.defaultContainer()
        self.publicDB = container.publicCloudDatabase
        self.session = ORSession.currentSession
        self.localData = session.localData
        self.cloudData = session.cloudData
        
        self.cloudData.fetchAllOrganizations { (response) -> () in
            
            if response.error == nil {
                for record in response.results as! [CKRecord] {
                    
                    let org = OROrganization.organization(record: record)
                    self.organizations.append(org)
                }
                
                runOnMainThread {
                    self.displayOrganizationsList(self.organizations)
                }
            }
        }

    }
    
    func displayOrganizationsList(organizations: [OROrganization]) {
        let container = self.organizationListView
        
        for (i, organization) in enumerate(organizations) {
            
            let topPadding = 15 as CGFloat
            let width = container.frame.width
            let height = 50 as CGFloat
            let x = 0 as CGFloat
            let y = (height + topPadding) * CGFloat(i)
            var orgView = OrganizationListItem(frame: CGRect(x: x, y: y, width: width, height: height), organization: organization)
            
            orgView.viewInfoHandler = { (organization) in
                self.orgNameLabel.stringValue = organization.orgName
                self.orgAthleteCountLabel.stringValue = "\(organization.athletes.count) athletes"
            }
            
            orgView.joinHandler = { (organization) in
                
                var mutableAthletes = NSMutableSet(set: organization.athletes)
                mutableAthletes.addObject(self.session.currentAthlete!)
                self.localData.save()
                
                self.publicDB.saveRecord(organization.record) { (record, error) -> Void in
                    println(error)
                }
            }
            
            self.organizationListView.addSubview(orgView)
        }
        
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}
