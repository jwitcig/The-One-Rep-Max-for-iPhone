//
//  HomeViewController.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit
import ORMKit

class HomeViewController: ORViewController {
    
    @IBOutlet weak var organizationsContainerView: NSView!

    var organizations = [OROrganization]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if false {
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
        
        self.cloudData.syncronizeDataToLocalStore {
            if $0.success {
                self.organizations = self.localData.fetchAll(model: OROrganization.self).objects as! [OROrganization]
                
                runOnMainThread {
                    self.displayOrganizations(self.organizations)
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("managedObjectContextWillSave:"), name: NSManagedObjectContextWillSaveNotification, object: self.localData.context)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("managedObjectContextDidSave:"), name: NSManagedObjectContextDidSaveNotification, object: self.localData.context)
        

        
//        let response = self.localData.fetchAll(model: OROrganization.self)
//        if response.success {
//            self.organizations = response.objects as! [OROrganization]
//            self.displayOrganizations(self.organizations)
//        }
        
//        print(self.localData.fetchDirtyObjects(model: ORLiftEntry.self).objects)
    }
    
    func managedObjectContextWillSave(notification: NSNotification) {
        let context = notification.object as! NSManagedObjectContext
        
        var observedObjects = context.insertedObjects
        for item in context.updatedObjects {
            observedObjects.insert(item)
        }
                
        for object in observedObjects {
            guard let model = object as? ORModel else { continue }
            if model.changedValues().keys.array.count != 0 {
                model.updateRecord()
                model.cloudRecordDirty = true
            }
        }
    }
    
    func managedObjectContextDidSave(notification: NSNotification) {
        let savedContext = notification.object as! NSManagedObjectContext
        
        let mainMOC = ORSession.currentSession.localData.context
        
        guard savedContext != mainMOC else { return }
    
        guard mainMOC.persistentStoreCoordinator == savedContext.persistentStoreCoordinator else { return }
        
        runOnMainThread {
            mainMOC.mergeChangesFromContextDidSaveNotification(notification)
        }
    }
    
    func displayOrganizations(organizations: [OROrganization]) {
        self.organizationsContainerView.subviews = []
        
        let reorderedOrgs = organizations.sort { $0.0.orgName.isBefore(string: $0.1.orgName) }
        
        for (i, organization) in reorderedOrgs.enumerate() {
            
            let topPadding = 15 as CGFloat
            let width = self.organizationsContainerView.frame.width
            let height = 60 as CGFloat
            let x = 0 as CGFloat
            let y = (height + topPadding) * CGFloat(i)
            let organizationItem = AssociatedOrganizationListItem(frame: NSRect(x: x, y: y, width: width, height: height), organization: organization)
            
            organizationItem.selectedHandler = { organization in
                ORSession.currentSession.currentOrganization = organization
                
                self.cloudData.fetchLiftTemplates(session: ORSession.currentSession, completionHandler: nil)

                self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.ormVC, options: NSViewControllerTransitionOptions.SlideForward, completionHandler: nil)
                
                self.cloudData.fetchMessages(organization: organization) {
                    if $0.success {
                        
                        ORMessage.messages(records: $0.objects)
                        self.localData.save()
                        
                    } else {
                        print($0.error)
                    }
                }
                
            }
            
            self.organizationsContainerView.addSubview(organizationItem)
        }
    }
    
}
