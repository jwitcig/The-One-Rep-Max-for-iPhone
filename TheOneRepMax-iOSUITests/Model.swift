//
//  Model.swift
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
    case LiftTemplate
    case LiftEntry
    
    case ORMessage
    
    case Athlete
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

public class Model: Object, ORLocalModel, ORCloudModel {
    
    public dynamic var createdDate: NSDate = NSDate()
    public dynamic var lastLocalSaveDate: NSDate!
    public dynamic var lastCloudSaveDate: NSDate!
    
    var keys: [String] {
        return ["createdDate", "lastLocalSaveDate", "lastCloudSaveDate", "id"]
    }
    
    class var entityName: String { return "Model" }
    var entityName: String { return Model.entityName }
    
    public dynamic var id: String = NSUUID().UUIDString
    
//    static var LocalOnlyFields = [
//        LiftTemplate.recordType: LiftTemplate.Fields.LocalOnly.allValues,
//        LiftEntry.recordType: LiftEntry.Fields.LocalOnly.allValues,
//        Athlete.recordType: Athlete.Fields.LocalOnly.allValues,
//    ]
//    
//    class func modelType(recordType recordType: String) -> Model.Type {
//        switch recordType {
//        case Model.recordType:
//            return Model.self
//        case RecordType.Athlete.rawValue:
//            return Athlete.self
//        case RecordType.LiftTemplate.rawValue:
//            return LiftTemplate.self
//        case RecordType.LiftEntry.rawValue:
//            return LiftEntry.self
//        default:
//            return Model.self
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
