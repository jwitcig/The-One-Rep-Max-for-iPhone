//
//  LiftEntry.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/11/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Foundation
import UIKit

import Firebase
import RealmSwift

struct Entry: Equatable {

    var id: String
    var date = NSDate()
    var createdDate = NSDate()
    var maxOut = false
    var reps: Int
    var weightLifted: Int
    var formula: String
    var entryType: String

    var max: Int {
        return Entry.oneRepMax(weightLifted: weightLifted, reps: reps)
    }
    
    var hashValue: Int { return id.hashValue }
    
    static func oneRepMax(weightLifted weightLifted: Int, reps: Int) -> Int {
        return Int( CGFloat(reps * weightLifted) * 0.033  + CGFloat(weightLifted) )
    }

    init(snapshot: FIRDataSnapshot) {
        id = snapshot.key
        date = NSDate(timeIntervalSince1970: snapshot.value!["date"] as! NSTimeInterval)
        createdDate = NSDate(timeIntervalSince1970: snapshot.value!["timestamp"] as! NSTimeInterval)
        reps = snapshot.value!["reps"] as! Int
        weightLifted = snapshot.value!["weight_lifted"] as! Int
        formula = snapshot.value!["formula"] as! String
        entryType = snapshot.value!["entry_type"] as! String
    }
    
}

func ==(lhs: Entry, rhs: Entry) -> Bool {
    return lhs.hashValue == rhs.hashValue
}