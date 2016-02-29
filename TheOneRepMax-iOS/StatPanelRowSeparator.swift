//
//  StatPanelRowSeparator.swift
//  TheOneRepMax
//
//  Created by Developer on 2/18/16.
//  Copyright © 2016 JwitApps. All rights reserved.
//

import UIKit

class StatPanelRowSeparator: UIView, StatListItem {

    var progressItemType: ProgressItemType = .SpecificLift
    
    var isPrimaryLevelSeparator = false
    
    init(orientation: Orientation) {
        super.init(frame: CGRect.zero)
        
        backgroundColor = UIColor.blackColor()
        
        let horizontalSeparatorHeight = CGFloat(1)
        let verticalSeparatorWidth = CGFloat(1)
        
        var constraint: NSLayoutConstraint!
        
        switch orientation {
            
        case .Horizontal:
            constraint = heightAnchor.constraintEqualToConstant(horizontalSeparatorHeight)
        case .Vertical:
            constraint = widthAnchor.constraintEqualToConstant(verticalSeparatorWidth)
        }
        
        constraint.priority = 990
        
        NSLayoutConstraint.activateConstraints([constraint])

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
