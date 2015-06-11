//
//  LiftTemplate.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import CloudKit

class LiftTemplate : CKRecord {
    var liftName: String!
    var liftDescription: String!
    var id: Int!
    var isDefault: Bool!
    var liftEntries: [Int]!
    var creatorId: Int?
 
}