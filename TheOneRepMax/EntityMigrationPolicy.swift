//
//  EntityMigrationPolicy.swift
//  TheOneRepMax
//
//  Created by Developer on 6/14/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class EntityMigrationPolicy: NSEntityMigrationPolicy {

    override func createDestinationInstancesForSourceInstance(sInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager, error: NSErrorPointer) -> Bool {
                
        var newObject = NSEntityDescription.insertNewObjectForEntityForName(mapping.destinationEntityName!, inManagedObjectContext: manager.destinationContext) as! NSManagedObject
        
        newObject.setValue(sInstance.valueForKey("passwordHash"), forKey: "passwordHash")
        
        manager.associateSourceInstance(sInstance, withDestinationInstance: newObject, forEntityMapping: mapping)
        
        return true
    }
    
    
    
//    // Create a new object for the model context
//    NSManagedObject *newObject =
//    [NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName]
//    inManagedObjectContext:[manager destinationContext]];
//    
//    
//    // do the coupling of old and new
//    [manager associateSourceInstance:sInstance withDestinationInstance:newObject forEntityMapping:mapping];
//    
//    }

    
    
}
