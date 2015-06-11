//
//  LiftEntry.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/11/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit

class LiftEntry: CKRecord {
    var date: NSDate!
    var liftTemplate: LiftTemplate!
    var id: Int!
    var maxOut: Bool!
//    var organization: Organization?
    var user: Int!
    var weightLifted: Int!
    var reps: Int!
    
}
