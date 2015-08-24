//
//  ManagedAthleteView.swift
//  TheOneRepMax
//
//  Created by Developer on 8/11/15.
//  Copyright © 2015 JwitApps. All rights reserved.
//

import Foundation
import ORMKit

@IBDesignable
class ManagedAthleteView: NSView {
    
    var athlete: ORAthlete!
    
    @IBInspectable var title: String!
    
    var removeAthleteButton: NSClosureButton!
    
    init(frame: NSRect, athlete: ORAthlete) {
        self.athlete = athlete
        
        super.init(frame: frame)
        
        self.updateProperties()
        
        self.drawing()
    }

    func updateProperties() {
        self.title = self.athlete.fullName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func drawing() {
        var width = self.frame.width * (7/10)
        var height = self.frame.height
        var x = 15 as CGFloat
        var y = 0 as CGFloat
        let nameLabel = NSLabel(frame: NSRect(x: x, y: y, width: width, height: height))
        nameLabel.stringValue = self.title
        self.addSubview(nameLabel)
        
        width = self.frame.width - CGRectGetMaxX(nameLabel.frame)
        height = self.frame.height
        x = CGRectGetMaxX(nameLabel.frame)
        y = 0 as CGFloat
        self.removeAthleteButton = NSClosureButton(frame: NSRect(x: x, y: y, width: width, height: height))
        self.removeAthleteButton.title = "remove"
        self.removeAthleteButton.bezelStyle = .RoundRectBezelStyle
        
        self.addSubview(removeAthleteButton)
    }
    
    override func drawRect(dirtyRect: NSRect) {
        
        
    }
    
}