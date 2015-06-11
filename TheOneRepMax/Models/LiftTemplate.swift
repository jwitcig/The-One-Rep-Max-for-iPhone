//
//  LiftTemplate.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa

class LiftTemplate : NSObject {
    var liftName: String!
    var liftDescription: String!
    var id: Int!
    var isDefault: Bool!
    var liftEntries: [Int]!
    var creatorId: Int?
 
    convenience init(id: Int) {
        self.init()
        
        self.id = id
    }
    
    convenience init(json: AnyObject) {
        self.init()
        
        let items = json as! [Dictionary<String, AnyObject>]
        if items.count == 1 {
            let item = items[0]
            self.liftName = item["lift_name"] as! String
            self.liftDescription = item["description"] as! String
            self.id = item["id"] as! Int
            self.isDefault = item["default"] as! Bool
            self.liftEntries = item["lift_entries"] as! [Int]!
            self.creatorId = item["creator_object_id"] as? Int
        }
    }
    
    static func template(data: Dictionary<String, AnyObject>) -> LiftTemplate {
        var template = LiftTemplate()
        template.liftName = data["lift_name"] as! String
        template.liftDescription = data["description"] as! String
        template.id = data["id"] as! Int
        template.isDefault = data["default"] as! Bool
        template.liftEntries = data["lift_entries"] as! [Int]!
        template.creatorId = data["creator_object_id"] as? Int

        return template
    }
    
    
    static func templates(json: AnyObject) -> [LiftTemplate] {
        let items = json as! [Dictionary<String, AnyObject>]
        
        var list: [LiftTemplate] = []
        for data in items {
            list.append(LiftTemplate.template(data))
        }
        return list
    }
}