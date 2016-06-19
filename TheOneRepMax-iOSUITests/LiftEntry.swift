//
//  LiftEntry.swift
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

public class LiftEntry: Object {

    override class var fields: [String] {
        return ["model", "id", "date", "maxOut", "reps", "weightLifted", "liftTemplate", "athlete"]
    }
    
    class var entityName: String { return RecordType.LiftEntry.rawValue }
    var entityName: String { return RecordType.LiftEntry.rawValue }
    
    dynamic var model: Model? = Model()

    var id: String? { return model?.id }
    
    dynamic var date = NSDate()
    dynamic var maxOut = true
    dynamic var reps = 0
    dynamic var weightLifted = 0
    var max: Int {
        return LiftEntry.oneRepMax(weightLifted: weightLifted, reps: reps)
    }
    
    class func oneRepMax(weightLifted weightLifted: Int, reps: Int) -> Int {
        guard reps != 1 else { return weightLifted }
        
        let rounded = round( Float(weightLifted) + (Float(weightLifted * reps) * 0.033 ) )
        return Int(rounded)
    }
    dynamic var liftTemplate: LiftTemplate?
    dynamic var athlete: Athlete?
}