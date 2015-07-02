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
        
        self.cloudData.fetchAssociatedOrganizations(self.session.currentAthlete!) { (response) -> () in
            if response.error == nil {
                
                for record in response.results as! [CKRecord] {
                    self.organizations.append(OROrganization(record: record))
                }
                
                runOnMainThread {
                    self.displayOrganizations(self.organizations)
                }
                
            } else {
                println(response.error)
            }
        }
        
    }
    
    func displayOrganizations(organizations: [OROrganization]) {
        for (i, organization) in enumerate(organizations) {
            
            let topPadding = 15 as CGFloat
            let width = self.organizationsContainerView.frame.width
            let height = 60 as CGFloat
            let x = 0 as CGFloat
            let y = (height + topPadding) * CGFloat(i)
            var organizationItem = AssociatedOrganizationListItem(frame: NSRect(x: x, y: y, width: width, height: height), organization: organization)
            
            organizationItem.selectedHandler = { organization in
                ORSession.currentSession.currentOrganization = organization
                
                self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.ormVC, options: NSViewControllerTransitionOptions.SlideForward, completionHandler: nil)
            }
            
            self.organizationsContainerView.addSubview(organizationItem)
        }
    }
    
}
