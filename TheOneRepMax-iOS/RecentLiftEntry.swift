//
//  LiftEntryStackView.swift
//  TheOneRepMax
//
//  Created by Developer on 2/5/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth
import RealmSwift

struct RecentEntry {
    let reps: Int
    let weightLifted: Int
    var max: Int { return Entry.oneRepMax(weightLifted: weightLifted, reps: reps) }
    
    init(dictionary: [String: AnyObject]) {
        self.reps = dictionary["reps"] as! Int
        self.weightLifted = dictionary["weight_lifted"] as! Int
    }
}

class RecentLiftEntry {
    
    var entry: Entry
    var stackView: UIStackView!
    
    var categoryID: String
    
    let liftLabel = UILabel()
    let maxLabel = UILabel()
    
    var target: AnyObject?
    var selector: Selector

    init(liftName: String, categoryID: String, entry: Entry, target: AnyObject?, selector: Selector) {
        
        self.entry = entry
        
        self.categoryID = categoryID
        
        self.target = target
        self.selector = selector
        
        liftLabel.text = liftName
        liftLabel.textAlignment = .Center
        
        let fontDescriptor = liftLabel.font.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitBold)
        liftLabel.font = UIFont(descriptor: fontDescriptor, size: 0)
        
        maxLabel.textAlignment = .Center
        
        stackView = UIStackView(arrangedSubviews: [liftLabel, maxLabel])
        stackView.axis = .Vertical
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
        
        update(entry: entry)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(entry entry: Entry) {
        self.entry = entry
        
        maxLabel.text = "\(entry.max)"
    }

}
