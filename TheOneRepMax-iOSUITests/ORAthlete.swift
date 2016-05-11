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

import CoreData

import SwiftTools

public class ORAthlete: ORModel {
  
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
    
    override public class var entityName: String { return RecordType.ORAthlete.rawValue }
    override var entityName: String { return RecordType.ORAthlete.rawValue }
    
    public var firstName: String!
    public var lastName: String!
    public var username: String!
    
    public var identityID: String { return id }
    
    public var fullName: String {
        return "\(firstName) \(lastName)"
    }

    public static func getLastAthlete() -> ORAthlete? {
        
        guard let identityID = NSUserDefaults.standardUserDefaults().valueForKey("currentAthleteIdentityID") as? String else {
            return nil
        }
        
        let context = NSManagedObjectContext.contextForCurrentThread()
        
        let fetchRequest = NSFetchRequest(entityName: ORAthlete.entityName)
        fetchRequest.predicate = NSPredicate(key: "identityID", comparator: .Equals, value: identityID)
      
        var athletes: [ORAthlete]?
        do {
            athletes = try context.executeFetchRequest(fetchRequest) as? [ORAthlete]
        } catch let error as NSError {
            print(error)
        }
        
        return athletes?.first
    }
    
    public static func setCurrentAthlete(athlete: ORAthlete) {
        
        NSUserDefaults.standardUserDefaults().setValue(athlete.identityID, forKey: "currentAthleteIdentityID")
        
        let result = NSUserDefaults.standardUserDefaults().synchronize()
        
        if result {
            ORSession.currentSession.currentAthlete = athlete
        }
    }
    
}
