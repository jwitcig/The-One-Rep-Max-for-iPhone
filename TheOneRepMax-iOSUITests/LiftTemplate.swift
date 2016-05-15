//
//  LiftTemplate.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

import RealmSwift

class LiftTemplate: Object {
    
    public enum Fields: String {
        case defaultLift
        case liftDescription
        case liftName
        case solo
        case creator
        case organization
        
        enum LocalOnly: String {
            case NoFields
            
            static var allCases: [LocalOnly] {
                return []
            }
            
            static var allValues: [String] {
                return LocalOnly.allCases.map { $0.rawValue }
            }
        }
    }
    
    class var entityName: String { return RecordType.LiftTemplate.rawValue }
    var entityName: String { return RecordType.LiftTemplate.rawValue }
    
    dynamic var model: Model? = Model()
    
    var id: String? { return model?.id }
    
    dynamic var defaultLift = false
    dynamic var liftDescription = ""
    dynamic var liftName: String!
    
    dynamic var creator: Athlete?
    
    override class var deletedKeys: [String] {
        return ["solo"]
    }
}