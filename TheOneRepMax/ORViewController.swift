//
//  ORViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 6/29/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit
import ORMKit

class ORViewController: NSViewController {
    
    var parentVC: MainViewController!
    
    public var fromViewController: ORViewController?
    
    var session: ORSession!
    var cloudData: ORCloudData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parentVC = self.parentViewController! as! MainViewController
        
        self.session = ORSession.currentSession
        self.cloudData = self.session.cloudData
    }
    
}
