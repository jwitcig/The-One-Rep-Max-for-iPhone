//
//  ORModel.swift
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

enum RecordType: String {
    case OROrganization
    case ORLiftTemplate
    case ORLiftEntry
    
    case ORMessage
    
    case ORAthlete
}

public protocol ModelType {
    var id: String { get set }
}

public protocol ORLocalModel {
    var lastLocalSaveDate: NSDate! { get set }
}

public protocol ORCloudModel {
    var lastCloudSaveDate: NSDate! { get set }
}

public class ORModel: Object, ORLocalModel, ORCloudModel {
    
    public dynamic var createdDate: NSDate = NSDate()
    public dynamic var lastLocalSaveDate: NSDate!
    public dynamic var lastCloudSaveDate: NSDate!
    
    var keys: [String] {
        return ["createdDate", "lastLocalSaveDate", "lastCloudSaveDate", "id"]
    }
    
    class var entityName: String { return "ORModel" }
    var entityName: String { return ORModel.entityName }
    
    public dynamic var id: String = NSUUID().UUIDString
    
//    static var LocalOnlyFields = [
//        ORLiftTemplate.recordType: ORLiftTemplate.Fields.LocalOnly.allValues,
//        ORLiftEntry.recordType: ORLiftEntry.Fields.LocalOnly.allValues,
//        ORAthlete.recordType: ORAthlete.Fields.LocalOnly.allValues,
//    ]
//    
//    class func modelType(recordType recordType: String) -> ORModel.Type {
//        switch recordType {
//        case ORModel.recordType:
//            return ORModel.self
//        case RecordType.ORAthlete.rawValue:
//            return ORAthlete.self
//        case RecordType.ORLiftTemplate.rawValue:
//            return ORLiftTemplate.self
//        case RecordType.ORLiftEntry.rawValue:
//            return ORLiftEntry.self
//        default:
//            return ORModel.self
//        }
//    }
    
    public required init() {
        super.init()
    }
    
    public required init(id: String) {
        self.id = id
        
        super.init()
    }
    
    required public init(value: AnyObject, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required public init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    var dictionaryRepresentation: NSDictionary {
        return [String: AnyObject]()
    }
    
}

extension Object {
    
    class var deletedKeys: [String] { return [] }
    
}
