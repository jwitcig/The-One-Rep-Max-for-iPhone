//
//  Lift.swift
//  TheOneRepMax
//
//  Created by Developer on 8/9/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import Foundation
import UIKit

import Firebase
import RealmSwift

struct Lift: Equatable {
    var id: String
    var name: String
    
    init(snapshot: FIRDataSnapshot) {
        id = snapshot.key
        name = snapshot.value!["name"] as! String
    }
}

func ==(lhs: Lift, rhs: Lift) -> Bool {
    return lhs.id == rhs.id
}