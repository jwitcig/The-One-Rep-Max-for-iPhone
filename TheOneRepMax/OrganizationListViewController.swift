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
    
    @IBOutlet weak var organizationScrollView: NSScrollView!
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
                
        self.container = CKContainer.defaultContainer()
        self.publicDB = container.publicCloudDatabase
        self.session = ORSession.currentSession
        self.localData = session.localData
        self.cloudData = session.cloudData
        
        
        let options = ORDataOperationOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "orgName", ascending: false)]
        self.cloudData.fetchAllOrganizations(options: options) {
            guard $0.success else { return }
            
            let threadedOrgs = OROrganization.organizations(records: $0.objects, context: $0.currentThreadContext)
            
            self.localData.save(context: $0.currentThreadContext)
            
            print(threadedOrgs.map {$0.orgName})
            
            runOnMainThread {
                let context = NSManagedObjectContext.contextForCurrentThread()
                self.organizations = context.crossContextEquivalents(objects: threadedOrgs)
                
                self.displayOrganizationsList(self.organizations)
            }
        }
        
    }
    
    func displayOrganizationsList(organizations: [OROrganization]) {
        let container = NSFlippedView(frame: self.organizationScrollView.bounds)
        
        for (i, organization) in organizations.enumerate() {
            
            let topPadding = 10 as CGFloat
            let width = container.frame.width
            let height = 50 as CGFloat
            let x = 0 as CGFloat
            let y = (height + topPadding) * CGFloat(i)
            let orgView = OrganizationListItem(frame: CGRect(x: x, y: y, width: width, height: height), organization: organization)
            
            orgView.viewInfoHandler = { (organization) in
                self.orgNameLabel.stringValue = organization.orgName
                self.orgAthleteCountLabel.stringValue = "\(organization.athletes.count) athletes"
            }
            
            orgView.joinHandler = { (organization) in
                organization.athletes.insert(self.session.currentAthlete!)
                self.localData.save()
                
                self.cloudData.syncronizeDataToCloudStore {
                    guard $0.success else { return }
                    
                    ORSession.currentSession.currentOrganization = organization
                    
                    runOnMainThread {
                        self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.homeVC, options: .SlideUp, completionHandler: nil)
                    }
                }
            
            }
            
            container.addSubview(orgView)
            container.frame = NSRect(x: 0, y: 0, width: container.frame.width, height: CGRectGetMaxY(orgView.frame))
        }
        self.organizationScrollView.documentView = container
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}
