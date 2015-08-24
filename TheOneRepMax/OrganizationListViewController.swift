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
    var organizationRecordNames = [String]()
    
    var container: CKContainer!
    var publicDB: CKDatabase!
    var session: ORSession!
    var localData: ORLocalData!
    var cloudData: ORCloudData!
    
    var temporaryOrganizationRecordNames = [String]()
    
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
        self.cloudData.fetchAllOrganizations(options: options) { (threadedOrganizations, response) in
            guard response.success else { return }

            self.localData.save(context: response.currentThreadContext)
            
            self.organizationRecordNames = threadedOrganizations.recordNames
            self.temporaryOrganizationRecordNames = self.organizationRecordNames

            runOnMainThread {
                self.displayOrganizationsList()
            }
        }
        
    }
    
    func displayOrganizationsList() {
        let (organizations, _) = self.localData.fetchAll(model: OROrganization.self)
        
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
                let context = NSManagedObjectContext.contextForCurrentThread()
                
                let unthreadedAthlete = context.crossContextEquivalent(object: self.session.currentAthlete!)
                
                organization.athletes.insert(unthreadedAthlete)
                self.localData.save(context: context)
                
                if let index = self.temporaryOrganizationRecordNames.indexOf(organization.recordName) {
                    self.temporaryOrganizationRecordNames.removeAtIndex(index)
                }
                
                self.deleteTemporaryOrganizationObjects()
                
                self.cloudData.syncronizeDataToCloudStore {
                    guard $0.success else { print($0.error);return }
                    
                    ORSession.currentSession.currentOrganization = organization
                    
                    self.cloudData.syncronizeDataToLocalStore {
                        guard $0.success else { return }
                        
                        runOnMainThread {
                            self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.homeVC, options: .SlideUp, completionHandler: nil)
                        }
                    }
                }
            }
            
            container.addSubview(orgView)
            container.frame = NSRect(x: 0, y: 0, width: container.frame.width, height: CGRectGetMaxY(orgView.frame))
        }
        self.organizationScrollView.documentView = container
    }
    
    func deleteTemporaryOrganizationObjects() {
        let context = NSManagedObjectContext.contextForCurrentThread()
        let resultsToDelete = self.localData.fetchObjects(ids: self.temporaryOrganizationRecordNames, model: OROrganization.self, context: context)
        
        guard let toDelete = resultsToDelete else {
            print("Error fetching organizations to delete.")
            return
        }
        toDelete.map(context.deleteObject)
        self.localData.save(context: context)
    }
    
    @IBAction func clearLocalStoreClicked(sender: NSButton) {
        self.localData.deleteAll(model: OROrganization.self)
        self.localData.deleteAll(model: ORLiftTemplate.self)
        self.localData.deleteAll(model: ORLiftEntry.self)
        self.localData.deleteAll(model: ORMessage.self)
        self.localData.deleteAll(model: ORAthlete.self)
        
        let request = NSFetchRequest(entityName: "CloudRecord")
        do {
            let cloudRecords = try self.localData.context.executeFetchRequest(request) as! [NSManagedObject]
            cloudRecords.map { self.localData.context.deleteObject($0) }
            self.localData.save()
        } catch  { }
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
}
