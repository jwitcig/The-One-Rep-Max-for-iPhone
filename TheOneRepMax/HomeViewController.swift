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
    
    @IBOutlet weak var organizationsScrollView: NSScrollView!

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
        } else {
    
            self.cloudData.syncronizeDataToLocalStore {
                guard $0.success else { return }
                
                runOnMainThread {
                    self.organizations = self.session.currentAthlete!.athleteOrganizations.array
                    self.displayOrganizations(self.organizations)
                }
            }
        }
        
    }
    
    func displayOrganizations(organizations: [OROrganization]) {
        self.organizationsScrollView.documentView?.removeFromSuperview()
        self.organizationsScrollView.documentView = nil
        
        let organizationsContainerView = NSFlippedView(frame: self.organizationsScrollView.bounds)
        
        let reorderedOrgs = organizations.sort { $0.0.orgName.isBefore(string: $0.1.orgName) }
        
        for (i, organization) in reorderedOrgs.enumerate() {
            
            let topPadding = 15 as CGFloat
            let width = organizationsContainerView.frame.width
            let height = 60 as CGFloat
            let x = 0 as CGFloat
            let y = (height + topPadding) * CGFloat(i)
            let organizationItem = AssociatedOrganizationListItem(frame: NSRect(x: x, y: y, width: width, height: height), organization: organization)
            
            organizationItem.selectedHandler = { organization in
                ORSession.currentSession.currentOrganization = organization

                self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.ormVC, options: .SlideForward, completionHandler: nil)
                
                self.cloudData.fetchMessages(organization: organization) { (messages, response) in
                    guard response.success else { print(response.error); return }
                    self.localData.save(context: response.currentThreadContext)
                }
            }
            
            organizationsContainerView.addSubview(organizationItem)
            organizationsContainerView.frame = NSRect(x: 0, y: 0, width: organizationsContainerView.frame.width, height: CGRectGetMaxY(organizationItem.frame))
        }
        self.organizationsScrollView.documentView = organizationsContainerView
    }
    
    @IBAction func joinOrgsPressed(sender: NSButton) {
        self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.organizationListVC, options: .SlideDown, completionHandler: nil)
    }
    
}
