//
//  ORLiftEntry.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/11/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif
import RealmSwift

public class ORLiftEntry: Object {

    public enum Fields: String {
        case date
        case maxOut
        case reps
        case weightLifted
        case liftTemplate
        case organization
        case athlete
        
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
    
    class var entityName: String { return RecordType.ORLiftEntry.rawValue }
    var entityName: String { return RecordType.ORLiftEntry.rawValue }
    
    dynamic var model: ORModel? = ORModel()

    var id: String? { return model?.id }
    
    dynamic var date = NSDate()
    dynamic var maxOut = true
    dynamic var reps = 0
    dynamic var weightLifted = 0
    var max: Int {
        return ORLiftEntry.oneRepMax(weightLifted: weightLifted, reps: reps)
    }
    
    class func oneRepMax(weightLifted weightLifted: Int, reps: Int) -> Int {
        guard reps != 1 else { return weightLifted }
        
        let rounded = round( Float(weightLifted) + (Float(weightLifted * reps) * 0.033 ) )
        return Int(rounded)
    }
    dynamic var liftTemplate: ORLiftTemplate?
    dynamic var athlete: ORAthlete?
}