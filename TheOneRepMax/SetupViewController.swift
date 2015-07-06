//
//  SetupViewController.swift
//  TheOneRepMax
//
//  Created by Developer on 7/5/15.
//  Copyright (c) 2015 JwitApps. All rights reserved.
//

import Cocoa
import ORMKit

class SetupViewController: ORViewController {
    
    @IBOutlet var optionsScrollView: NSScrollView!
    
    var organization: OROrganization?
    
    let optionViewHeight = 40 as CGFloat
    let optionViewTopPadding = 5 as CGFloat
    
    var optionNumber = 0
    
    var options = [SetupOptionView]()
    
    var optionViewOrgName: NSView {
        return self.buildOption(title: "name", type: .Text, value: self.organization?.orgName)
    }
    
    var optionViewOrgDescription: NSView {
        return self.buildOption(title: "description", type: .Text, value: self.organization?.description)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initOptionItems()
    }
    
    func initOptionItems() {
        
        var container = NSFlippedView()
        container.addSubview(self.optionViewOrgName)
        container.addSubview(self.optionViewOrgDescription)

        
        
        var width = self.optionsScrollView.frame.width * (1/2)
        var height =  (self.optionViewHeight + self.optionViewTopPadding) * CGFloat(self.optionNumber)
        
        container.frame = NSRect(origin: CGPointZero, size: CGSize(width: self.optionsScrollView.frame.width, height: height))
        
        self.optionsScrollView.documentView = container
    }
    
    func buildOption(#title: String, type: OROptionType, value: AnyObject?) -> SetupOptionView {
        let origin = NSPoint(x: 0, y: ((self.optionViewHeight + self.optionViewTopPadding) * CGFloat(self.optionNumber)))
        let size = CGSize(width: self.optionsScrollView.frame.width, height: self.optionViewHeight)
        let frame = NSRect(origin: origin, size: size)
        
        self.optionNumber += 1
        var option = SetupOptionView(frame: frame, title: title, type: type, organization: self.organization, value: value)
        option.parentController = self
        self.options.append(option)
        return option
    }
    
}
