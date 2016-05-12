//
//  ORAthlete.swift
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

public class ORAthlete: Object {
  
    enum Fields: String {
        case firstName
        case lastName
        case username
        
        enum LocalOnly: String {
            case None
            
            static var allCases: [LocalOnly] {
                return []
            }
            
            static var allValues: [String] {
                return LocalOnly.allCases.map { $0.rawValue }
            }
        }
    }
    
    class var entityName: String { return RecordType.ORAthlete.rawValue }
    var entityName: String { return RecordType.ORAthlete.rawValue }
    
    dynamic var model: ORModel? = ORModel()

    var id: String? { return model?.id }
 
    dynamic var firstName: String!
    dynamic var lastName: String!
    dynamic var username: String!
    
    let liftEntries = LinkingObjects(fromType: ORLiftEntry.self, property: "athlete")
    
    var identityID: String? { return model?.id }
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    static func getLastAthlete() -> ORAthlete? {
        
        guard let identityID = NSUserDefaults.standardUserDefaults().valueForKey("currentAthleteIdentityID") as? String else {
            return nil
        }
        
        return try! Realm().objects(ORAthlete).filter("model.id == %@", identityID).first
    }
    
    public static func setCurrentAthlete(athlete: ORAthlete) {
        
        NSUserDefaults.standardUserDefaults().setValue(athlete.identityID, forKey: "currentAthleteIdentityID")
        
        let result = NSUserDefaults.standardUserDefaults().synchronize()
        
        if result {
            ORSession.currentSession.currentAthlete = athlete
        }
    }
    
}
