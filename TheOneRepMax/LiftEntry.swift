//
//  LiftEntry.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/11/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class LiftEntry: NSObject {
    var date: NSDate!
    var liftTemplate: LiftTemplate!
    var id: Int!
    var maxOut: Bool!
//    var organization: Organization?
    var user: Int!
    var weightLifted: Int!
    var reps: Int!
    
    enum Field: String, ModelField {
        case weightLifted = "weight_lifted"
        case reps = "reps"
        
        var databaseKey: String {
            get { return self.rawValue }
        }
    }
    
    convenience init(json: AnyObject) {
        self.init()
        
        let items = json as! [Dictionary<String, AnyObject>]
        if items.count == 1 {
            let item = items[0]
            self.date = LiftEntry.captureDate(item["date"] as! String)
            self.liftTemplate = LiftTemplate(id: item["lift_template"] as! Int)
            self.id = item["id"] as! Int
            self.maxOut = item["max_out"] as! Bool
            self.user = item["user"] as! Int
            self.weightLifted = item["weight_lifted"] as! Int
            self.reps = item["reps"] as! Int
        }
    }
    
    private static func captureDate(dateString: String) -> NSDate? {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        return dateFormatter.dateFromString(dateString)
    }
    
    static func entry(data: Dictionary<String, AnyObject>) -> LiftEntry {
        var entry = LiftEntry()
        entry.date = LiftEntry.captureDate(data["date"] as! String)
        entry.liftTemplate = LiftTemplate(id: data["lift_template"] as! Int)
        entry.id = data["id"] as! Int
        entry.maxOut = data["max_out"] as! Bool
        entry.user = data["user"] as! Int
        entry.weightLifted = data["weight_lifted"] as! Int
        entry.reps = data["reps"] as! Int
        
        return entry
    }
    
    
    static func entries(json: AnyObject) -> [LiftEntry] {
        let items = json as! [Dictionary<String, AnyObject>]
        
        var list: [LiftEntry] = []
        for data in items {
            list.append(LiftEntry.entry(data))
        }
        return list
    }
}
