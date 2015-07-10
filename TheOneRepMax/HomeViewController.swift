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
        
//        self.cloudData.syncronizeDataToLocalStore { (response) in
//            if response.success {
//                
//                self.organizations = self.localData.fetchAll(model: OROrganization.self).localResults as! [OROrganization]
//                
//                runOnMainThread {
//                    self.displayOrganizations(self.organizations)
//                }
//                
//            }
//        }
        
    
    
//        self.localData.deleteAll(model: OROrganization.self)

        let response = self.localData.fetchAll(model: OROrganization.self)
        if response.success {
            self.organizations = response.localResults as! [OROrganization]
            self.displayOrganizations(self.organizations)
        }
    }
    
    func displayOrganizations(organizations: [OROrganization]) {
        self.organizationsContainerView.subviews = []
        
        for (i, organization) in enumerate(organizations) {
            
            let topPadding = 15 as CGFloat
            let width = self.organizationsContainerView.frame.width
            let height = 60 as CGFloat
            let x = 0 as CGFloat
            let y = (height + topPadding) * CGFloat(i)
            var organizationItem = AssociatedOrganizationListItem(frame: NSRect(x: x, y: y, width: width, height: height), organization: organization)
            
            organizationItem.selectedHandler = { organization in
                ORSession.currentSession.currentOrganization = organization
                
                self.cloudData.fetchLiftTemplates(session: ORSession.currentSession, completionHandler: nil)

                self.parentVC.transitionFromViewController(self, toViewController: self.parentVC.ormVC, options: NSViewControllerTransitionOptions.SlideForward, completionHandler: nil)
                
                self.cloudData.fetchMessages(organization: organization) { (response) -> () in
                    if response.success {
                        
                        var messages = ORMessage.messages(records: response.cloudResults)
                        self.localData.save()
                        
                    } else {
                        println(response.error)
                    }
                }
                
            }
            
            self.organizationsContainerView.addSubview(organizationItem)
        }
    }
    
}
