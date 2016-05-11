//
//  TORM_1.2-1.swift
//  TheOneRepMax
//
//  Created by Developer on 5/10/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import CoreData
import UIKit

class TORM_1_2__1_3: NSEntityMigrationPolicy {

    override func createDestinationInstancesForSourceInstance(sInstance: NSManagedObject, entityMapping mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        let destMOC = manager.destinationContext

        let dInstance = NSEntityDescription.insertNewObjectForEntityForName(sInstance.entity.name!, inManagedObjectContext: destMOC)
        
        let attributeKeys = Array(sInstance.entity.attributesByName.keys)
        let existingAttributeData = sInstance.dictionaryWithValuesForKeys(attributeKeys)

        dInstance.setValuesForKeysWithDictionary(existingAttributeData)
        
        dInstance.setValue(NSUUID().UUIDString, forKey: "id")
        
        manager.associateSourceInstance(sInstance, withDestinationInstance: dInstance, forEntityMapping: mapping)
    }
    
}
