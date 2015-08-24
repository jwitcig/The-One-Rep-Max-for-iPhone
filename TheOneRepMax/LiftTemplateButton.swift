//
//  LiftTemplateButton.swift
//  TheOneRepMax
//
//  Created by Application Development on 6/10/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit

class LiftTemplateButton: NSButton {
    
    let template: ORLiftTemplate!
    let index: Int!
    
    static let width = 100
    static let height = 30
    static var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }
    var origin: CGPoint {
        return CGPoint(x: (self.index*LiftTemplateButton.width)+((index+1)*LiftTemplateButton.padding), y: 0)
    }
    
    static let padding = 30
    
    var buttonCell: NSButtonCell {
        return self.cell! as! NSButtonCell
    }
    
    init(frame frameRect: NSRect, template: ORLiftTemplate, index: Int) {
        self.template = template
        self.index = index
        super.init(frame: CGRectZero)
        
        let frame = CGRect(origin: self.origin, size: LiftTemplateButton.size)
        
        self.buttonCell.backgroundColor = NSColor.blueColor()
        self.buttonCell.bezelStyle = .InlineBezelStyle
        
        let centeredStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        centeredStyle.alignment = .Center
        
        let colorTitle = NSAttributedString(string: template.liftName, attributes: [NSForegroundColorAttributeName: NSColor.greenColor(), NSParagraphStyleAttributeName: centeredStyle])
        
        self.attributedTitle = colorTitle
        self.frame = frame
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
