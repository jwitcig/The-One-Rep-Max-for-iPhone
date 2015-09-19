//
//  OrganizationDetailViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 9/18/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit

import ORMKit

class OrganizationDetailViewController: UIViewController {
    
    var organization: OROrganization!
    
    @IBOutlet weak var athleteCountLabel: UILabel!
    @IBOutlet weak var organizationDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.displayOrganizationInformation()
    }
    
    func displayOrganizationInformation() {
        self.navigationItem.title = organization.orgName
        
        if let athleteCount = organization.athleteReferences?.count {
              self.athleteCountLabel.text = "\(athleteCount) athletes"
        }
        
        self.organizationDescriptionLabel.text = organization.orgDescription
    }
    
}
