//
//  Lift.swift
//  TheOneRepMax
//
//  Created by Developer on 8/9/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import Foundation
import UIKit

import AWSDynamoDB
import RealmSwift

protocol Lift {
    var id: String { get set }
    var name: String { get set }
}

protocol LocalLiftModel: Lift {
    var _id: String { get set }
    var _name: String { get set }
}


extension Lift {
    init() {
        self.init()
    }
}

extension LocalLiftModel {
    var id: String {
        get { return _id }
        set { _id = newValue }
    }
    var name: String {
        get { return _name }
        set { _name = newValue }
    }
}

class LocalLift: Object, LocalLiftModel {
    dynamic var _id: String = "Lift:"+NSUUID().UUIDString
    dynamic var _name: String = ""
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
