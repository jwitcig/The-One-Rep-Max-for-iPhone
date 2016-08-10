//
//  LiftEntryStackView.swift
//  TheOneRepMax
//
//  Created by Developer on 2/5/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

class RecentLiftEntry {
    
    var entry: Entry!
    var stackView: UIStackView!
    
    var target: AnyObject?
    var selector: Selector

    init(entry: Entry, target: AnyObject?, selector: Selector) {
        
        self.entry = entry
        
        self.target = target
        self.selector = selector
        
        let liftLabel = UILabel()
        liftLabel.text = entry.lift
        liftLabel.textAlignment = .Center
        
        let fontDescriptor = liftLabel.font.fontDescriptor().fontDescriptorWithSymbolicTraits(.TraitBold)
        liftLabel.font = UIFont(descriptor: fontDescriptor, size: 0)
        
        let maxLabel = UILabel()
        maxLabel.text = "\(entry.max)"
        maxLabel.textAlignment = .Center
        
        stackView = UIStackView(arrangedSubviews: [liftLabel, maxLabel])
        stackView.axis = .Vertical
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: target, action: selector))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
