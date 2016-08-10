//
//  LiftEntry.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/11/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Foundation
import UIKit

import AWSDynamoDB
import RealmSwift

protocol Entry {
    var id: String { get set }
    
    var date: NSDate { get set }
    var createdDate: NSDate { get set }
    var maxOut: Bool { get set }
    var reps: Int { get set }
    var weightLifted: Int { get set }
    
    var max: Int { get }
    
    var liftId: String { get set }
    var userId: String { get set }
}

protocol LocalEntryModel: Entry {
    var _id: String { get set }
    
    var _date: Int { get set }
    var _createdDate: Int { get set }
    var _maxOut: Bool { get set }
    var _reps: Int { get set }
    var _weightLifted: Int { get set }

    var _categoryId: String { get set }
    var _userId: String { get set }
}

protocol CloudEntryModel: Entry {
    var _id: String? { get set }
    
    var _date: NSNumber? { get set }
    var _createdDate: NSNumber? { get set }
    var _maxOut: NSNumber? { get set }
    var _reps: NSNumber? { get set }
    var _weightLifted: NSNumber? { get set }
    
    var _categoryId: String? { get set }
    var _userId: String? { get set }
}

extension Entry {
    init() {
        self.init()
    }
}

extension LocalEntryModel {
    var id: String {
        get { return _id }
        set { _id = newValue }
    }
    var date: NSDate {
        get { return NSDate(timeIntervalSince1970: Double(_date)) }
        set { _date = Int(newValue.timeIntervalSince1970) }
    }
    var createdDate: NSDate {
        get { return NSDate(timeIntervalSince1970: Double(_createdDate)) }
        set { _createdDate = Int(newValue.timeIntervalSince1970) }
    }
    var maxOut: Bool {
        get { return _maxOut }
        set { _maxOut = newValue }
    }
    var reps: Int {
        get { return _reps }
        set { _reps = newValue }
    }
    var weightLifted: Int {
        get { return _weightLifted }
        set { _weightLifted = newValue }
    }
    var liftId: String {
        get { return _categoryId }
        set { _categoryId = newValue }
    }
    var userId: String {
        get { return _userId ?? "" }
        set { _userId = newValue }
    }
}

extension CloudEntryModel {
    var id: String {
        get { return _id ?? "Entry:"+NSUUID().UUIDString }
        set { _id = newValue }
    }
    var date: NSDate {
        get {
            if let interval = _date?.doubleValue {
                return NSDate(timeIntervalSince1970: interval)
            }
            return NSDate()
        }
        set { _date = newValue.timeIntervalSince1970 }
    }
    var createdDate: NSDate {
        get {
            if let interval = _createdDate?.doubleValue {
                return NSDate(timeIntervalSince1970: interval)
            }
            return NSDate()
        }
        set { _createdDate = newValue.timeIntervalSince1970 }
    }
    var maxOut: Bool {
        get { return _maxOut?.boolValue ?? false }
        set { _maxOut = newValue }
    }
    var reps: Int {
        get { return _reps?.integerValue ?? 0 }
        set { _reps = newValue }
    }
    var weightLifted: Int {
        get { return _weightLifted?.integerValue ?? 0 }
        set { _weightLifted = newValue }
    }
    var liftId: String {
        get { return _categoryId ?? "Lift"+NSUUID().UUIDString }
        set { _categoryId = newValue }
    }
    var userId: String {
        get { return _userId ?? "" }
        set { _userId = newValue }
    }
}

class LocalEntry: Object, LocalEntryModel {
    dynamic var _id: String = "Entry:" + NSUUID().UUIDString
    
    dynamic var _date: Int = 0
    dynamic var _createdDate: Int = 0
    dynamic var _maxOut: Bool = false
    dynamic var _reps: Int = 0
    dynamic var _weightLifted: Int = 0
    
    dynamic var _categoryId: String = ""
    dynamic var _userId: String = ""
    
    static func oneRepMax(weightLifted weightLifted: Int, reps: Int) -> Int {
        guard reps != 1 else { return weightLifted }
        
        let rounded = round( Float(weightLifted) + (Float(weightLifted * reps) * 0.033 ) )
        return Int(rounded)
    }
    
    var max: Int {
        return LocalEntry.oneRepMax(weightLifted: weightLifted, reps: reps)
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["max"]
    }
}

class CloudEntry: AWSDynamoDBObjectModel, AWSDynamoDBModeling, CloudEntryModel  {
    var _id: String? = ""
    
    var _date: NSNumber? = 0
    var _createdDate: NSNumber? = 0
    var _maxOut: NSNumber? = false
    var _reps: NSNumber? = 0
    var _weightLifted: NSNumber? = 0
    
    var _categoryId: String? = ""
    var _userId: String? = ""
  
    var max: Int {
        return LocalEntry.oneRepMax(weightLifted: weightLifted, reps: reps)
    }
    
    class func dynamoDBTableName() -> String {
        
        return "tripple-mobilehub-1169331636-Entry"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {
        
        return "_id"
    }
    
    override class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject] {
        return [
            "_id":              "id",
            "_date":            "date",
            "_createdDate":     "createdDate",
            "_maxOut":          "maxOut",
            "_reps":            "reps",
            "_weightLifted":    "weightLifted",
            "_categoryId":      "cateogryId",
            "_userId":          "userId",
        ]
    }
    
    // additions
    
    override init() {
        super.init()
    }
    
    override init(dictionary dictionaryValue: [NSObject : AnyObject]!, error: ()) throws {
        try super.init(dictionary: dictionaryValue, error: error)
    }
    
    required init!(coder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
