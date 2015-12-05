//
//  ORViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 9/28/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import UIKit
import ORMKitiOS

class ORViewController: UIViewController {

    var session: ORSession!
    var localData: ORLocalData!
    var cloudData: ORCloudData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.session = ORSession.currentSession
        self.localData = self.session.localData
        self.cloudData = self.session.cloudData
    }
    
}
