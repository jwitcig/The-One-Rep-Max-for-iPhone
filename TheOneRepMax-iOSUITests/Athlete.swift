//
//  Athlete.swift
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

import Realm
import RealmSwift

import SwiftTools

public class Athlete: Object {
    
    override class var fields: [String] {
        return ["model", "id", "firstName", "lastName"]
    }
    
    override class var deletedKeys: [String] {
        return ["username"]
    }
    
    class var entityName: String { return RecordType.Athlete.rawValue }
    var entityName: String { return RecordType.Athlete.rawValue }
    
    dynamic var model: Model? = Model()

    var id: String? { return model?.id }
 
    dynamic var firstName: String!
    dynamic var lastName: String!

    let liftEntries = LinkingObjects(fromType: LiftEntry.self, property: "athlete")
    
    var identityID: String? { return model?.id }
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    static func getLastAthlete() -> Athlete? {
        
        guard let identityID = NSUserDefaults.standardUserDefaults().valueForKey("currentAthleteID") as? String else {
            return nil
        }
        
        return try! Realm().objects(Athlete).filter("model.id == %@", identityID).first
    }
    
    public static func setCurrentAthlete(athlete: Athlete) {
        
        NSUserDefaults.standardUserDefaults().setValue(athlete.identityID, forKey: "currentAthleteID")
        
        let result = NSUserDefaults.standardUserDefaults().synchronize()
        
        if result {
            ORSession.currentSession.currentAthlete = athlete
        }
    }
    
}
