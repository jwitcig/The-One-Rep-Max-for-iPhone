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
    
    @IBOutlet weak var weightField: NSTextField!
    @IBOutlet weak var organizationsScrollView: NSScrollView!

//    var organizations = [OROrganization]()
    @IBOutlet weak var saveButton: NSButton!
        
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.cloudData.fetchModels(model: ORMembership.self, predicate: NSPredicate(key: ORMembership.Fields.athlete.rawValue, comparator: .Equals, value: ORSession.currentSession.currentAthlete!.reference)) { (memberships, response) -> () in
            guard response.success else { return }
            
            self.localData.save(context: response.currentThreadContext)
            
            runOnMainThread {
                @IBOutlet weak var controlSwitcherScrollView: UIScrollView!
                self.displayOrganizations(memberships)
            }
        }
        
    }
    
    @IBAction func repsChanged(stepper: UIStepper) {
        
    }
    
    func displayOrganizations(memberships: [ORMembership]) {
        var membershipsAndOrgs = memberships.map { (membership: ORMembership) -> (ORMembership, OROrganization) in
            return (membership, membership.organization)
        }
        
        guard memberships.count > 0 else {
            self.showJoinOrganizationsButton()
            return
        }
        
        self.organizationsScrollView.documentView?.removeFromSuperview()
        self.organizationsScrollView.documentView = nil
        
        let organizationsContainerView = NSFlippedView(frame: self.organizationsScrollView.bounds)
        
        membershipsAndOrgs.sortInPlace {
            return $0.0.1.orgName.isBefore(string: $0.1.1.orgName)
        }
        
        for (i, (membership, organization)) in membershipsAndOrgs.enumerate() {
            let isAdmin = membership.admin
            
            let topPadding = 15 as CGFloat
            let width = organizationsContainerView.frame.width
            let height = 60 as CGFloat
            let x = 0 as CGFloat
            let y = (height + topPadding) * CGFloat(i)
            let organizationItem = AssociatedOrganizationListItem(frame: NSRect(x: x, y: y, width: width, height: height), organization: organization)
            
            organizationItem.selectedHandler = { organization in
                ORSession.currentSession.currentOrganization = organization
                ORSession.currentSession.userIsAdmin = isAdmin
                
                self.cloudData.syncronizeDataToLocalStore {
                    guard $0.success else { return }
                    
                    self.parentVC.ormVC.fromViewController = self
                    
                    runOnMainThread {
                        self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.ormVC, options: .SlideForward, completionHandler: nil)
                    }
                    
                    self.cloudData.fetchMessages(organization: organization) { (messages, response) in
                        guard response.success else { print(response.error); return }
                        self.localData.save(context: response.currentThreadContext)
                    }
                }
            }
            
            organizationsContainerView.addSubview(organizationItem)
            organizationsContainerView.frame = NSRect(x: 0, y: 0, width: organizationsContainerView.frame.width, height: CGRectGetMaxY(organizationItem.frame))
        }
        self.organizationsScrollView.documentView = organizationsContainerView
    }
    
    func showJoinOrganizationsButton() {
        if let sheetViewController = self.storyboard?.instantiateControllerWithIdentifier("JoinOrgsPopoverViewController") as? NSViewController {
            self.addChildViewController(sheetViewController)
            self.presentViewControllerAsSheet(sheetViewController)
        }
    }
    
    @IBAction func joinOrgsPressed(sender: NSButton) {
        self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.organizationListVC, options: .SlideDown, completionHandler: nil)
    }
    
}
